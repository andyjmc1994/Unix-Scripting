if [ $# != 2 ]                                                                          #make sure there is 2 arguaments given
  then
    echo "Wrong number of arguaments given"                                                     #if not, print error message
    exit                                                                                #then exit program
fi

normalpostcode=$(echo $1 |sed -f normalise.sed )                                        #remove spaces and make upper case (from CW1)
areacode=$(echo "${normalpostcode}" |sed -f areacode.sed)                                                #get the area code (from cw1)

cat codepoint/"$areacode"_position.nt | sed  -f  extractCoords.sed > extractedCoords.txt        #get the coordinates from the file with matching areacode

#extract the lattitude, longitude, easting and northing values using the postcode and assign them to variables
lat=` cat extractedCoords.txt | awk -v POSTCODE1="$normalpostcode" -f latitude.awk`
long=` cat extractedCoords.txt | awk -v POSTCODE1="$normalpostcode" -f longitude.awk`
east=` cat extractedCoords.txt | awk -v POSTCODE1="$normalpostcode" -f easting.awk`
north=` cat extractedCoords.txt | awk -v POSTCODE1="$normalpostcode" -f northing.awk`

#get the distance, longitute and lattitude of the nearby accidents using easting and northing values extracted above and put them in a temperary text file.
cat DfTRoadSafety_Accidents_2012.csv | awk -v EASTING="${east}" -v NORTHING="${north}" -v RADIUS=$2 -f nearby-accidents2.awk > accidentCoords.txt

sort -n -k 1 accidentCoords.txt > sortedCoords.txt                                              #sort the list of accidents by distanc from postcode


themonth=1
for themonth in $(seq -f "%02g" 01 12)								#loop through each month with 2 digits. eg 01, 02,...10,11,12 
do	
	cat sortedCoords.txt | awk -v DAY="1" -v MONTH=${themonth} -f count-by-week-and-month.awk >> daysMonths1.txt		#for each day put the month and number of
        cat sortedCoords.txt | awk -v DAY="2" -v MONTH=${themonth} -f count-by-week-and-month.awk >> daysMonths2.txt		#accidents in a txt file to be read later
        cat sortedCoords.txt | awk -v DAY="3" -v MONTH=${themonth} -f count-by-week-and-month.awk >> daysMonths3.txt
        cat sortedCoords.txt | awk -v DAY="4" -v MONTH=${themonth} -f count-by-week-and-month.awk >> daysMonths4.txt
        cat sortedCoords.txt | awk -v DAY="5" -v MONTH=${themonth} -f count-by-week-and-month.awk >> daysMonths5.txt
        cat sortedCoords.txt | awk -v DAY="6" -v MONTH=${themonth} -f count-by-week-and-month.awk >> daysMonths6.txt
        cat sortedCoords.txt | awk -v DAY="7" -v MONTH=${themonth} -f count-by-week-and-month.awk >> daysMonths7.txt
	
done

gnuplot <<eof
set style data linespoints												#set the graph style to linepoints
set xlabel 'Month'													#specify labels for axis
set ylabel 'Count by accidents'
set title 'Accidents within a radius of $2 from ${normalpostcode}.							#specify title
set xrange [ 1: 12 ]													#specify the range for each axis
set yrange [ 5: 35 ]
set ytics 5														#specify the steps each axis goes up in
set xtics 1
set key outside														#place the key outside th graph
set terminal png
set output 'accidents_${normalpostcode}.png'										#specify the output name of file
#plot onto the graph the data from the text file rpresenting each day
plot 'daysMonths1.txt' title "Monday", 'daysMonths2.txt' title "Tuesday",  'daysMonths3.txt' title "Wednesday", 'daysMonths4.txt' title "Thursday", 'daysMonths5.txt' title "Friday", 'daysMonths6.txt' title "Saturday", 'daysMonths7.txt' title "Sunday"
eof


#delete all the temporary files created during the process.
rm -f -r accidentCoords.txt
rm -f -r sortedCoords.txt
rm -f -r extractedCoords.txt 
rm -f -r daysMonths1.txt
rm -f -r daysMonths2.txt
rm -f -r daysMonths3.txt
rm -f -r daysMonths4.txt
rm -f -r daysMonths5.txt
rm -f -r daysMonths6.txt
rm -f -r daysMonths7.txt

