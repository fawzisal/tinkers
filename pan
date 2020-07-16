#!/bin/bash
#
# pan:   convert all files in the current folder
# 
# 
# REQUIREMENTS: pandoc, mupdf-tools
#

q="$BASH_ARGV";

datadir="$DATAPATH"
if [[ -z "$datadir" ]]; then datadir=$(pwd); fi
. "$(datadir)/colors.sh";
debug=0;

b_conv_from=""
v_conv_from=""

help_string="$yellow USAGE: $blank
    $bold pan $blank [flags/options]
$yellow
 FLAGS: $blank
    $green -f/i   $blank format of files to convert from (e.g. pdf).
    $green -t/o   $blank format of files to convert to (e.g. txt).
    $green -h     $blank show list of command-line options.
"

while getopts 'i:f:o:t:hd-:' opt; do
	case "${opt}" in
		d) debug=1;;
		f|i) v_conv_from="$OPTARG";;
		t|o) v_conv_to="$OPTARG";;
		h|\?) printf "$help_string"; b_help="help"; exit 1;;
		-) if [[ $OPTARG == "help" ]]; then printf "$help_string"; b_help="help"; exit 1; fi; ;;
		:) echo "Option -$OPTARG requires an argument."; exit 1;;
		*) echo "Option -$OPTARG requires an argument."; exit 1;;
	esac
done

if [[ $debug -eq 1 ]]; then {
	echo "from: $v_conv_from"
	echo "to: $v_conv_to"
}; fi

if [[ ! -z "$v_conv_from" ]]; then b_conv_from="-e"; fi

if [[ $v_conv_from == "pdf" ]]; then {
	for i in $(fd -e pdf -d1 -x echo {.}); do {
		echo "converting:	$i...";
		mutool convert -o "$i.txt" "$i.pdf";
	}; done;
}; else {
	for i_ in $(fd $b_conv_from "$v_conv_from" -d1 -x echo "{.}¬{}"); do {
		i=($(echo $i_ | tr -s ¬ ' '));
		base_path="${i[0]}";
		n_base_path=$(( ${#base_path} + 1 ));
		extension="${i[1]:$n_base_path}";
		if [[ $debug -eq 1 ]]; then {
			echo "$base_path";
			echo "$extension";
		}; fi
		echo "converting:	$base_path from $extension to $v_conv_to";
		if [[ $v_conv_to == "txt" || $v_conv_to == "plain" ]]; then {
			pandoc -i "$base_path.$extension" -o "$base_path.txt" -t plain;
		}; elif [[ $extension == "pdf" ]]; then {
			mutool convert -o "$i.txt" "$i.$extension";
		}; else {
			pandoc -i "$base_path.$extension" -o "$base_path.$v_conv_to";
		}; fi
	}; done;
}; fi

if [[ $debug -eq 1 ]]; then {
	rename -fs '.html.' '.' *;
}; fi
