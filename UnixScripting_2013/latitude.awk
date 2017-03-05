BEGIN {FS = " "}{
}
$1 == POSTCODE1 && $2 == "lat" { print $3 }
