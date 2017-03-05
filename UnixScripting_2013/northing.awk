BEGIN {FS = " "}{
}
$1 == POSTCODE1 && $2 == "northing" { print $3 }


