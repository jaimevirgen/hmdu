#!/bin/bash

# ##################################################
#
version="0.0.1"              # Sets version variable
#
# HISTORY:
#
# 20160609 - v0.0.1  - Restart, Clean Slate
#
# ##################################################

args=("$@")

#main_lookup no options just single argument
function main_lookup {

    file="/Users/jaimev/countdown.txt"

	while IFS=, read -r name event; do
		if [ "$name" = ${args[0]} ]; then
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

			echo "There are ${color}${count}${reset} Days until ${args}"
		fi
	done <$file

}

#add event function
function add_event {

  echo $OPTARG >> "/Users/jaimev/countdown.txt"
  sed -i '' -n p "/Users/jaimev/countdown.txt"
  echo "added " ${args[1]}

  exit 1
}

#delete event function
function delete_event {

  sed "/$OPTARG/d" "/Users/jaimev/countdown.txt" > "/Users/jaimev/countdown.temp" ; mv "/Users/jaimev/countdown.temp" "/Users/jaimev/countdown.txt"
  echo "deleted " $OPTARG

  exit 1
}

#lookup event function
function list_events {

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

  exit 1
}

while getopts "a:d:l" opt; do
  case $opt in
    a)
      add_event
      ;;
    d)
      delete_event
      ;;
    l)
      list_events
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
    list_events
    exit 1
fi

main_lookup