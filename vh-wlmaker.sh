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
		echo "127.0.0.1,about,admin,admin01,admin10,administration,administrator,ads,adserver,alerts,alpha,ap,apache,api,app,apps,appserver,aptest,auth,backup,beta,blog,blogadmin,cdn,chat,citrix,cms,corp,crs,cvs,dashboard,database,db,demo,dev,devel,development,devsql,devtest,dhcp,direct,dmz,dns,dns0,dns1,dns2,door,download,en,erp,eshop,exchange,f5,fileserver,firewall,forum,ftp,ftp0,git,gw,help,helpdesk,home,host,http,id,images,info,internal,internet,intra,intranet,ipv6,lab,ldap,linux,local,localadmin,localhost,log,lol,m,mail,mail2,mail3,mailgate,main,manage,mgmt,mirror,mobile,monitor,mssql,mta,mx,mx0,mx1,mysql,news,noc,ns,ns0,ns1,ns2,ns3,ntp,old,ops,oracle,owa,pbx,phone,portal,s3,secure,server,sharepoint,shop,sip,smtp,sql,squid,ssh,ssl,stage,staging,stats,status,svn,syslog,test,test1,test2,tester,testing,uat,upload,v1,v2,v3,vm,vmm,vnc,voip,vpn,web,web2test,webmail,whois,wiki,www,www2,xml" | tr "," "\n" > $domain-vh-wl.txt
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
