#!/bin/bash
echo "Enter a temperature (e.g., 100F or 37C):"
read temp

unit=${temp: -1}
num=${temp:0:-1}

if [[ unit == "C" ]]
    answer=$(echo "scale=2; ($num * 9/5) + 32" | bc)
    echo "temp = ${answer}C"
elif [[ unit == "F" ]]
    answer=$(echo "scale=2; ($num - 32) * 5/9" | bc)
    echo "$temp = ${answer}F"
fi