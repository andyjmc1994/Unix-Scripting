BEGIN { 
 FS=" " # Initialising the field separator 
 COUNT=0 # Initialising the accident counter 
} 
 
# Pattern for checking the two conditions. For the month condition 
# we need to extract a substring from the date. 
$7==DAY && substr($6,4,2)==MONTH { 
 COUNT++ 
} 
 
# Printing the final count 
END { 
 print MONTH, COUNT 
}	
