BEGIN {FS = " "}{
}
$1 == POSTCODE1 && $2 == "easting" { print $3 }
