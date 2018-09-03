#!/bin/bash

inputfiles[1]=""
dpath="/home/digiwhist/input-data/ocds/"
function convertToBigOne() {
fullfile=$1_mexico_fullfile.json
cat <<EOF >$fullfile
{"main":
[
EOF
first=0
for ielement in ${inputfiles[@]}; do
    [ -e "$dpath$ielement" ] || continue
    if (( "$first" == 0 )); then
      first=2
    else
    cat <<EOF >>$fullfile
,
EOF
    fi
 cat "$dpath$ielement" >> $fullfile
done
cat <<EOF >>$fullfile
]}
EOF
}

counter=1
fcounter=1
for jsonfile in `ls "$dpath" | grep .json`;do
        inputfiles[counter]="$jsonfile"
        if (($counter > 30000)); then
		echo "merge to one (30000) into file: $fcounter"
                convertToBigOne $fcounter
                fcounter=`expr $fcounter + 1`
                unset counter
                unset inputfiles
		counter=1
        else
                counter=`expr $counter + 1`
        fi
done
if [ ${#inputfiles[@]} -eq 0 ]; then
    echo "all data processed"
else
    echo "Oops, there are some data to process left.. doing.."
    printf '%s\n' "${inputfiles[@]}"
    convertToBigOne $fcounter
fi
