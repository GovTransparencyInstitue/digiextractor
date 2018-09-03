#!/bin/bash

while IFS='' read -r line || [[ -n "$line" ]]; do
    wget 'http://195.201.218.26:8080/tender/'$line -O "$line.json"
done < "$1"