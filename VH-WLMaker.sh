#!/bin/bash

RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

suppress_output=false

function print_output {
	if [ "$suppress_output" = false ]; then
		  echo -e "${CYAN}$1${NC}"
	fi
}

help_menu() {
	banner
	echo -e "${CYAN}Usage: -w [path to ur wl] -i [subdomain file] [-h] [-s]${NC}\n"
	echo -e "${CYAN} -i: Path to file with subdomains${NC}"
	echo -e "${CYAN} -w: Path to your wl${NC}"
	echo -e "${CYAN} -s: Display output in silent mode${NC}"
	echo -e "${CYAN} -h: Show this message${NC}"
	exit 0
}

banner() {
	print_output "+-+-+-+-+-+-+-+-+-+-+"
	print_output "|V|H| |W|L|M|a|k|e|r|"
	print_output "+-+-+-+-+-+-+-+-+-+-+\n"
}

while getopts "w:i:s :h" opt; do
	case $opt in
	w)
		if [ -f "$OPTARG" ]; then
			wordlist="$OPTARG"
		else
			print_output "Error: File not found"
			help_menu
			exit 1
		fi
		;;
	i)
		if [ -f "$OPTARG" ]; then
			subdomains="$OPTARG"
		else
			print_output "Error: File not found"
			help_menu
			exit 1
		fi
		;;
	h)
		help_menu
		exit 0
		;;
	s)
		suppress_output=true
		;;
	\?)
		echo "Invalid option: -$OPTARG" >&2
		exit 1
		;;
	esac
done


if [[ $(cat $subdomains | sed 's/http:\/\/\|https:\/\///g' | cut -d'/' -f1 | cut -d';' -f1 | cut -d'#' -f1 | cut -d'?' -f1 | grep -vE '^[^.]*\.[^.]*$' | sort -u | wc -l) -ne 0 ]]; then
	if [[ $(cat $wordlist | wc -l) -ne 0 ]]; then
		banner
		domain=$(cat $subdomains | sed 's/http:\/\/\|https:\/\///g' | cut -d'/' -f1 | cut -d';' -f1 | cut -d'#' -f1 | cut -d'?' -f1 | grep -vE '^[^.]*\.[^.]*$' | awk '{print length, $0}' | sort -n | head -n 1 | cut -d ' ' -f 2- | sed 's/^[^.]*\.//' | sort -u)  
		cat $wordlist > $domain-vh-wl.txt
		cat $wordlist | sed "s/$/.$domain/" >> $domain-vh-wl.txt
		cat $subdomains | sed 's/http:\/\/\|https:\/\///g' | cut -d'/' -f1 | cut -d';' -f1 | cut -d'#' -f1 | cut -d'?' -f1 | grep -vE '^[^.]*\.[^.]*$' | sort -u >> $domain-vh-wl.txt
		print_output "+-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-+-+-+"
		print_output "your wordlist is ready: `pwd`/$domain-vh-wl.txt"
		print_output "+-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-+-+-+"
		print_output "final wordlist lenght: `cat $domain-vh-wl.txt | wc -l`"
		print_output "+-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-+-+-+"
		print_output "ffuf -u target -H \"Host: FUZZ\" -w `pwd`/$domain-vh-wl.txt"
		print_output "+-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-+-+-+"


	else
		echo -e "${RED}The word list you gave me is empty. +_+${NC}"
	fi
else
	echo -e "${RED}No valid subdomain detected +_+${NC}"
fi
