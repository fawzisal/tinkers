#!/bin/bash
# 
# plot:   convenience wrapper for GNUplot
# 

b_debug="";
b_separate="";
v_file=()
help_string="
$bold plot$blank: Plot using GNUplot.

$yellow USAGE: $blank
    $bold plot $blank [flags/options] [filename]

$yellow FLAGS: $blank
    $green -s   $blank plot each function/data file in a separate graph.
    $green -h   $blank show list of command-line options.

$yellow
OPTIONS: $blank
    $green -f [file]   $blank plot file data.

"

while getopts 'hds-:f:' opt; do
    case "${opt}" in
    f) v_file+=("$OPTARG");;
    d) b_debug="1";;
    s) b_separate="1";;
    h|\?) printf "$help_string"; b_help="help"; exit 1;;
    -) if [[ $OPTARG == "help" ]]; then printf "$help_string"; b_help="help"; exit 1; fi; ;;
    *) echo "Unknown flag $OPTARG."; exit 1;;
  esac
done
shift $(expr $OPTIND - 1 )

q="$@";
v_plots=()

if [[ "$b_debug" == 1 ]]; then {
	echo "debug";
	echo "q: {$q}";
}; fi

for i in ${v_file[@]}; do {
		v_plots+=("\"$i\"")
	# if [[ -e "$i" ]]; then {
	# }; else {
	# 	echo "file <$red$i$blank> does not exit. Ignored."
	# }; fi
}; done

for j in $q; do {
	v_plots+=("$i");
}; done

function join_by { local d=$1; shift; local f=$1; shift; printf %s "$f" "${@/#/$d}"; }

if [[ "$b_separate" == 1 ]]; then {
	v_plotstr=$(join_by "; set terminal x $RANDOM; plot " ${v_plots[@]});
}; else {
	v_plotstr=$(join_by ", " ${v_plots[@]});
}; fi

echo "${v_plots[@]}"
echo "${v_plotstr[@]}"
echo "$v_plots"
echo "$v_plotstr"

