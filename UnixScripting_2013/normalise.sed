# Removing all non-alphanumeric characters 
s/[^A-Za-z0-9]//g 
# Converting the whole pattern to uppercase 
s/.*/\U&/g 

