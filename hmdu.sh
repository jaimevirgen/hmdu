#!/bin/bash

# ##################################################
#
version="0.1.1"              # Sets version variable
#
# HISTORY:
#
# * DATE - v0.1.0  - Main Template with Colors defined and options
#
# ##################################################

# Store all arguments passed in special array
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

	file="/Users/jaimev/countdown.txt"

	while IFS=, read -r name event; do
		if [ "$name" = "$args" ]; then
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

			echo " There are ${color}${count}${reset} Days until ${args} "
		fi
	done <$file

}

read_list() {

	# read_list function
	# -----------------------------------
	# Iterate through full event List and Echo each in seperate lines.
	# Define colors, and embed day countdown into each event.
	# -----------------------------------

	sort -t"," -k2,2 "/Users/jaimev/countdown.txt" > "/Users/jaimev/countdown.temp"

	file="/Users/jaimev/countdown.temp"

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

	rm "/Users/jaimev/countdown.temp"
}

add_to_list() {

	# add_to_list function
	# -----------------------------------
	# Add event to countdown list with passed parameters, name date.
	# Validate arguments passed or return error message.
	# -----------------------------------

	echo ${args[1]},${args[2]} >> "/Users/jaimev/countdown.txt"
	sed -i '' -n p "/Users/jaimev/countdown.txt"

}

remove_from_list() {

	# add_to_list function
	# -----------------------------------
	# Add event to countdown list with passed parameters, name date.
	# Validate arguments passed or return error message.
	# -----------------------------------

	sed "/${args[1]}/d" "/Users/jaimev/countdown.txt" > "/Users/jaimev/countdown.temp" ; mv "/Users/jaimev/countdown.temp" "/Users/jaimev/countdown.txt"

	echo "deleted " ${args[1]}

}

# Set Flags
# -----------------------------------
# Flags which can be overridden by user input.
# -----------------------------------
while getopts "a:d:l" opt;
do
  case $opt in
    a)
      args=("$@")
      add_to_list
      ;;
    d)
      args=("$@")
      remove_from_list
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

# always call main regardless of flag or parameter
main
