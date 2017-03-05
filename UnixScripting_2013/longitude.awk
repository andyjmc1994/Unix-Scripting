BEGIN {FS = " "}{
}
$1 == POSTCODE1 && $2 == "long" { print $3 }

