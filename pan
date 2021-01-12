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
. "$datadir/colors.sh";
debug=0;

b_conv_from=""
v_conv_from=""
b_iconv=""

help_string="$yellow USAGE: $blank
    $bold pan $blank [flags/options]
$yellow
 FLAGS: $blank
    $green -f/i   $blank format of files to convert from (e.g. pdf).
    $green -t/o   $blank format of files to convert to (e.g. txt).
    $green -c     $blank convert to utf-8.
    $green -h     $blank show list of command-line options.
"

while getopts 'ci:f:o:t:hd-:' opt; do
	case "${opt}" in
		d) debug=1;;
		f|i) v_conv_from="$OPTARG";;
		t|o) v_conv_to="$OPTARG";;
		c) b_iconv=1;;
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
if [[ "$v_conv_to" == "plain" ]]; then v_conv_to="txt"; fi

# }; elif [[ $v_conv_from == "doc" ]]; then {
# 	for i in $(fd -I -e doc -d1 -x echo {.}); do {
# 		echo "converting:	$i...";
# 		soffice --headless --convert-to "$v_conv_to" "$i.doc";
# 	}; done;

if [[ $v_conv_from == "pdf" ]]; then {
<<<<<<< HEAD
	if [[ $v_conv_to == "plain" ]]; then {
		v_conv_to="txt";
	}; fi
	while read i; do {
		echo "converting:	$i...";
		mutool convert -o "$i.$v_conv_to" "$i.pdf";
	}; done <<< "$(fd -I -e pdf -d1 -x echo {.})"
}; elif [[ ($v_conv_from == "xlsx") || ($v_conv_from == "xls") || ($v_conv_from == "ods") ||
		                               ($v_conv_from == "doc") || ($v_conv_from == "odt") ||
		   ($v_conv_from == "pptx") || ($v_conv_from == "ppt") || ($v_conv_from == "odp")
		   ]]; then {
	if [[ "$v_conv_to" == "plain" ]]; then {
		v_conv_to="txt"
	}; fi
	while read i; do {
		echo "converting:	$i...";
		soffice --headless --convert-to "$v_conv_to" "$i.$v_conv_from";
		echo "saved to $i\.$v_conv_to"
	}; done <<< "$(fd -I -e "$v_conv_from" -d1 -x echo {.})"
}; else {
	while read i; do {
#	for i in $(fd -i -I -e pdf -d1 -x echo {.}); do {
#		if [[ -e "$i.$v_conv_to" ]]; then continue; fi
#		echo "converting:	$i...";
#		mutool convert -o "$i.$v_conv_to" "$i.pdf";
#	}; done;
#}; else {
#	for i_ in $(fd -i -I $b_conv_from "$v_conv_from" -d1 -x echo "{.}¬{}"); do {
		i=($(echo $i_ | tr -s ¬ ' '));
		b_app="";
		b_app=$(file -i "$i_" | grep application);
		b_utf="";
		b_utf=$(file -i "$i_" | grep "charset=us-ascii");
		base_path="${i[0]}";
		n_base_path=$(( ${#base_path} + 1 ));
		extension="${i[1]:$n_base_path}";
		if [[ -e "$base_path.$v_conv_to" ]]; then continue; fi
		if [[ $debug -eq 1 ]]; then {
			echo "$base_path";
			echo "$extension";
			echo "b_app: $b_app";
		}; fi
		echo "converting:	$base_path from $extension to $v_conv_to";
		if [[ $v_conv_to == "txt" ]]; then {
			#if [[ (-z "$b_app" ) && "" && (-z "$b_utf") ]]; then {
			if [[ ! -z "$b_iconv" ]]; then {
				echo "converting to utf-8";
				iconv -ct utf8 "$base_path.$extension" | pandoc -i - -o "$base_path.txt" -t plain;
			}; else {
				pandoc -i "$base_path.$extension" -o "$base_path.txt" -t plain;
			}; fi
		}; else {
			pandoc -i "$base_path.$extension" -o "$base_path.$v_conv_to";
		}; fi
	}; done <<< "$(fd -I $b_conv_from "$v_conv_from" -d1 -x echo "{.}¬{}")"
}; fi

if [[ $debug -eq 1 ]]; then {
	rename -fs '.html.' '.' *;
}; fi
