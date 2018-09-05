#!/bin/bash
for filename in x*; do
dir=${filename:1}
mkdir d$dir
echo "{\"root\":[" > d$dir/input.json
while IFS='' read -r line || [[ -n "$line" ]]; do
	wget 'http://localhost:8080/columbia/tender/'$line -q -O - >> d$dir/input.json
	echo "," >> d$dir/input.json
done < $filename
truncate -s-2 d$dir/input.json
echo "]}" >> d$dir/input.json
flatten-tool/flatten-tool flatten -f csv d$dir/input.json  --root-id=ocid --main-sheet-name releases --root-list-path='root' --output-name d$dir/flattened
mv $filename done
done
