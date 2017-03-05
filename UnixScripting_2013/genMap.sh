											
if [ $# != 2 ]										#make sure there is 2 arguaments given
  then	
    echo "Wrong number of arguaments given"							#if not, print error message
    exit										#then exit program
fi

normalpostcode=$(echo $1 |sed -f normalise.sed )					#remove spaces and make upper case (from CW1)
areacode=$(echo "${normalpostcode}" |sed -f areacode.sed)						#get the area code (from cw1)

cat codepoint/"$areacode"_position.nt | sed  -f  extractCoords.sed > extractedCoords.txt	#get the coordinates from the file with matching areacode

#extract the lattitude, longitude, easting and northing values using the postcode and assign them to variables
lat=` cat extractedCoords.txt | awk -v POSTCODE1="$normalpostcode" -f latitude.awk`		
long=` cat extractedCoords.txt | awk -v POSTCODE1="$normalpostcode" -f longitude.awk`		
east=` cat extractedCoords.txt | awk -v POSTCODE1="$normalpostcode" -f easting.awk`		
north=` cat extractedCoords.txt | awk -v POSTCODE1="$normalpostcode" -f northing.awk`

#get the distance, longitute and lattitude of the nearby accidents using easting and northing values extracted above and put them in a temperary text file. 
cat DfTRoadSafety_Accidents_2012.csv | awk -v EASTING="${east}" -v NORTHING="${north}" -v RADIUS=$2 -f nearby-accidents.awk > accidentCoords.txt

sort -n -k 1 accidentCoords.txt > sortedCoords.txt  						#sort the list of accidents by distanc from postcode

#place the longitute and latitude into the image url
url="http://staticmap.openstreetmap.de/staticmap.php?center=""${lat}"",""${long}""&zoom=16&size=1024x768&markers="

x=1
while [ $x != 16 ]			#initiate loop so thatit loops 15 times
do
    aclong=` cat sortedCoords.txt | sed $x'q;d' | awk '{print $2}'`               #retrieve the longitude and lattitude of accidents from the sorted text file
    aclat=` cat sortedCoords.txt | sed $x'q;d' | awk '{print $3}'` 		  #sed script iscolates the specific line, awk prints eithe the long or lat
    url="${url}""${aclat}"",""${aclong}"",ol-marker|"				  #put the coordinates of the accidents in the marker url to be added	
    x=$(( $x + 1 ))
done
curl -o map_"${normalpostcode}".png "${url}"					  #rtrieve the image using the created url


#delete all the temporary files created during the process.
rm -f -r accidentCoords.txt			
rm -f -r sortedCoords
rm -f -r extractedCoords

