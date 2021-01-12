#!/bin/bash
#
# vh:  Lorem ipsum dolor sit amet consectetur adipiscing,
# 		elit dapibus accumsan suscipit euismod tincidunt.
# 
# REQUIREMENTS: req1, re2, req3
# 

q="$BASH_ARGV";
debug=0;
help_string="
$bold vh$blank: search vim help.

$yellow USAGE: $blank
    $bold vh $blank [flags/options] [from] [to]

$yellow FLAGS: $blank
    $green -h   $blank show list of vh options.

"

while getopts 'h-:' opt; do
    case "${opt}" in
		d) debug=1;;
	    h|\?) printf "$help_string"; b_help="help"; exit 1;;
	    -) if [[ $OPTARG == "help" ]]; then printf "$help_string"; b_help="help"; exit 1; fi; ;;
	    *) echo "Unknown flag $OPTARG."; exit 1;;
	esac
done

if [[ "$debug" == 1 ]]; then {
	echo "debugging";
}; fi

rg -i "$q" $(fd '^doc$' -td ~/.vim//bundle/);

