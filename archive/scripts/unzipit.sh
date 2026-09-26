#!/bin/sh

input="$1"

[[ -z $input ]] && echo "PLEASE SPECIFY ZIP FILE" && exit 1

fname=$(basename "$input")

[[ ! -f "$fname" ]] && echo "PLEASE SPECIFY ZIP FILE" && exit 1
echo $fname

extension="${fname##*.}"
stem="${fname%.*}"
echo $extension
echo $stem

mkdir -v "$stem"
unzip -d "$stem" "$fname"
