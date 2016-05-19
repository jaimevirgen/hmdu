#!/bin/bash

#store all arguments passed in special array
args=("$@")

# Main thread for countdown logic
main() {
	lookupdate
}

lookupdate() {

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
