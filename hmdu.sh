#!/bin/bash

# ##################################################
#
version="0.1.0"              # Sets version variable
#
# HISTORY:
#
# * DATE - v0.1.0  - Main Template with Colors defined and options
#
# ##################################################

## Store all arguments passed in special array
args=("$@")

main() {

	# Main thread for countdown logic
	# -----------------------------------
	# Perform regardless of any option or parameter used.
	# this will also run trap and CLI overhead.
	# -----------------------------------

	lookup_event
}

lookup_event() {

	# lookup_event function
	# -----------------------------------
	# Iterate through event parameter name lookup through full event List.
	# Define colors, and embed day countdown into message.
	# -----------------------------------

	count=$(( ($(gdate --date="20161225" +%s) - $(gdate +%s) )/(60*60*24) ))
	reset=`tput sgr0`

	if [ $count -lt 30 ]; then
		color=`tput setaf 1`
	elif [ $count -lt 60 ]; then
		color=`tput setaf 3`
	elif [ $count -lt 100 ]; then
		color=`tput setaf 6`
	else
		color=`tput setaf 2`
	fi

	echo " There are ${color}${count}${reset} Days until ${args} "
}

read_list() {

	# read_list function
	# -----------------------------------
	# Iterate through full event List and Echo each in seperate lines.
	# Define colors, and embed day countdown into each event.
	# -----------------------------------

	file="/Users/jaimev/countdown.txt"

	while IFS=, read -r name event; do
		count=$(( ($(gdate --date="$event" +%s) - $(gdate +%s) )/(60*60*24) ))
		reset=`tput sgr0`

		if [ $count -lt 30 ]; then
			color=`tput setaf 1`
		elif [ $count -lt 60 ]; then
			color=`tput setaf 3`
		elif [ $count -lt 100 ]; then
			color=`tput setaf 6`
		else
			color=`tput setaf 2`
		fi

		echo "$name" ${color} "$count" ${reset}
	done <$file
}

while getopts "a:d:l" opt;
do
  case $opt in
    a)
      echo "-a was triggered, Parameter: $OPTARG" >&2
      ;;
    d)
      echo "-d was triggered, Parameter: $OPTARG" >&2
      ;;
    l)
	  read_list
	  exit 1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# catch if no flag or parameter is passed
if [ $# -eq 0 ]; then
    echo "How many days until...what?"
    exit 1
fi

# if an argument is passed call main
main
