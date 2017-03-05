BEGIN { 
 	FS="," # Initialising the field delimiter 
} 

function distance(e1,n1,e2,n2) { 
 	return sqrt( (e1-e2)^2 + (n1-n2)^2 ) 
} 
 
{ 
dist=distance(EASTING,NORTHING, $2, $3)  
if(dist<RADIUS) { 
	print dist,$2,$3,$4,$5,$10,$11 
} 
} 
