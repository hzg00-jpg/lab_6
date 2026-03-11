#!/bin/bash

COUNT = 0

for FILE in *; do
    if [[ "$FILE" == *."$EXT" ]]; then
        ((COUNT++))
    fi
done

echo "There are $COUNT .txt files in the current directory."