#!/bin/bash

# Main thread for countdown logic
main() {
	greeting
	read_list
}

greeting() {

	red=`tput setaf 1`
	green=`tput setaf 2`
	reset=`tput sgr0`

	#echo $'\n' There are ${green}$(( ($(gdate --date="160922" +%s) - $(gdate +%s) )/(60*60*24) ))${reset} Days Left $'\n'
}

read_list() {
	file="/Users/jaimev/countdown.txt"

	while IFS=, read -r name event; do
		count=$(( ($(gdate --date="$event" +%s) - $(gdate +%s) )/(60*60*24) ))
		echo "$name" "$count"
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
      echo "-l was triggered, Parameter: $OPTARG" >&2
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

main
