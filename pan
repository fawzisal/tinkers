#!/bin/bash

q="$BASH_ARGV";

conv_from=""
while getopts 'i:f:o:t:' opt; do
	case "${opt}" in
		f|i) conv_from="$OPTARG";;
		t|o) conv_to="$OPTARG";;
		# h) echo "TODO: write help function";;
		\?) echo "Invalid option: -$OPTARG" >&2; exit 1;;
		:) echo "Option -$OPTARG requires an argument."; exit 1;;
		*) echo "Option -$OPTARG requires an argument."; exit 1;;
	esac
done

# echo "from: $conv_from"
# echo "to: $conv_to"

if [[ $conv_from == "pdf" ]]; then {
	for i in $(fd -e pdf -d1 -x echo {.}); do {
		echo "converting:	$i...";
		mutool convert -o "$i.$conv_to" "$i.$conv_from";
	}; done;
}; else {
	for i in $(fd -e "$conv_from" -d1 -x echo {.}); do {
		echo "converting:	$i...";
		if [[ $conv_to == "txt" ]]; then {
			pandoc -i "$i.$conv_from" -o "$i.$conv_to" -t plain;
		}; else {
			pandoc -i "$i.$conv_from" -o "$i.$conv_to";
		}; fi
	}; done;
}; fi

# # rename -fs '.html.' '.' *;