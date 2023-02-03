#!/bin/bash

while read line; do
    if [[ "$line" =~ ^\.[[:space:]]\./lib.+ ]]; then
        file="$(echo "$line" | cut -d' ' -f2)"
        echo "$(cat $file|sed '/#!/d')"
    else
        echo "$line"
    fi
done < ./main.sh > src.sh
