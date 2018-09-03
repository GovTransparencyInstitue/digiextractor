#!/bin/bash

dpath="/home/digiwhist/flatten-tool/tempo/"
for file in `ls "$dpath" | grep flattened`;do

echo "handling files in $dpath$file/"
    for element in `ls "$dpath$file/" | grep csv`;do
echo "handling file $dpath$file/$element"
	if [ -e "$dpath""result/$element" ]; then
		tail -n +2 "$dpath$file/$element" >> "$dpath""result/$element"
		echo "$dpath""result/$element already exists.."
	else
		cp "$dpath$file/$element" "$dpath""result/$element"
	fi
    done
done
