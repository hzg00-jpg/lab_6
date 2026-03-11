#!/bin/bash

COUNT=0
read file_type 

for FILE in *; do
    if [[ "$FILE" == *.file_type ]]; then
        ((COUNT++))
    fi
done

echo "There are $COUNT .txt files in the current directory."