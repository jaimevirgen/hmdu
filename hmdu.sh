#!/bin/bash

# Main thread for countdown logic
main() {
	greeting
}

greeting() {

	echo "How many days until…"

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
