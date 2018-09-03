#!/bin/bash
dpath="/home/digiwhist/flatten-tool/3kjsons/"
for file in `ls "$dpath" | grep .json`;do
	filename=$(basename -- "$file")
        filename="${filename%.*}"
	echo "flattening $file into flattened$filename directory..."
	../flatten-tool flatten -f csv "$file" --output-name flattened"$filename" --root-id=records/ocid --main-sheet-name records --root-list-path='main'
done
