#!/bin/bash
NC='\033[0m'
RED='\033[1;38;5;196m'
GREEN='\033[1;38;5;040m'
ORANGE='\033[1;38;5;202m'
BLUE='\033[1;38;5;012m'
BLUE2='\033[1;38;5;032m'
PINK='\033[1;38;5;013m'
GRAY='\033[1;38;5;004m'
NEW='\033[1;38;5;154m'
YELLOW='\033[1;38;5;214m'
CG='\033[1;38;5;087m'
CP='\033[1;38;5;221m'
CPO='\033[1;38;5;205m'
CN='\033[1;38;5;247m'
CNC='\033[1;38;5;051m'

function nmap_scan(){
echo -e ${RED}    "###############################################################"
echo -e ${ORANGE} " #             DOMAIN TO IP RESOLVERS & NMAP SCAN              #  "
echo -e ${PINK}   " #                                                             #  "
echo -e ${BLUE}   " #                   DARKBOSS1BD PRESENTS                      #  "
echo -e ${YELLOW} " #             Coded By: darkboss1bd                           #  "
echo -e ${CP}     " #             Telegram: https://t.me/darkvaiadmin             #  "
echo -e ${CP}     " #             Website: https://serialkey.top/                 #  "
echo -e ${CP}     " #             Channel: https://t.me/windowspremiumkey         #  "
echo -e ${RED}    "################################################################ \n "
}

d=$(date +"%b-%d-%y %H:%M")

function scan_single(){
clear
nmap_scan
echo -n -e ${RED}"\n[+] Enter Single domain (e.g target.com): " 
read domain
mkdir -p $domain $domain/masscan $domain/nmap
echo "$domain" > $domain/domain.txt
echo -e ${BLUE}"\n[+] Resolving domain to IP:- \n"
massdns -r ~/tools/resolvers/resolver.txt -t A -o S -w $domain/masscan/results.txt $domain/domain.txt
cat $domain/masscan/results.txt | awk -F ". " '{print $3}' | sort -u | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | tee $domain/masscan/ip.txt
echo -e ${GREEN}"\n[+] NMAP NSE Scan Started On Domain:- "
nmap -sV --script vulners.nse -iL $domain/masscan/ip.txt -oN $domain/nmap/scan.txt
}

function scan_all(){
clear
nmap_scan
echo -e -n ${ORANGE}"\n[+] Enter domain name (e.g target.com): "
read domain
mkdir -p $domain $domain/domain_enum $domain/final_domains $domain/nmap $domain/masscan 

echo -e ${BLUE}"\n[+] Finding Subdomains.....:- \n"
sleep 1

echo -e ${CP}"\n[+] Crt.sh Started:- "
curl -s "https://crt.sh/?q=%25.$domain&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | tee $domain/domain_enum/crt.txt

echo -e ${PINK}"\n[+] Subfinder Started:- "
subfinder -d $domain -o $domain/domain_enum/subfinder.txt -silent

echo -e ${YELLOW}"[+] Assetfinder Started:- "
assetfinder -subs-only $domain | tee $domain/domain_enum/assetfinder.txt

echo -e ${GREEN}"\n[+] Amass Started:- "
amass enum -passive -d $domain -o $domain/domain_enum/amass.txt

echo -e ${BLUE}"\n[+] Shuffledns Started:- "
shuffledns -d $domain -w /usr/share/seclists/Discovery/DNS/deepmagic.com-prefixes-top50000.txt -r ~/tools/resolvers/resolver.txt -o $domain/domain_enum/shuffledns.txt -silent

echo -e ${CPO}"\n[+] Collecting All Subdomains Into Single File:- "
cat $domain/domain_enum/*.txt | sort -u > $domain/domain_enum/all.txt

echo -e ${RED}"\n[+] Resolving All Subdomains:- "
shuffledns -d $domain -list $domain/domain_enum/all.txt -o $domain/domains.txt -r ~/tools/resolvers/resolver.txt -silent

echo -e ${BLUE}"\n[+] Checking Services on Domains:- "
cat $domain/domains.txt | httpx -threads 30 -o $domain/final_domains/httpx.txt -silent

echo -e ${CP}"[+] Resolving Domains to IP'S:- "
massdns -r ~/tools/resolvers/resolver.txt -t A -o S -w $domain/masscan/results.txt $domain/domains.txt
cat $domain/masscan/results.txt | awk -F ". " '{print $3}' | sort -u | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | tee $domain/masscan/ip.txt

echo -e ${GREEN}"\n[+] Started NMAP NSE Scan:- "
nmap -sV --script vulners.nse -iL $domain/masscan/ip.txt -oN $domain/nmap/scan.txt
}

function scan_list(){
clear
nmap_scan
echo -n -e ${BLUE2}"\n[+] Enter path of domains list (e.g domains.txt): "
read hostlist

if [ ! -f "$hostlist" ]; then
  echo -e ${RED}"[!] File not found: $hostlist"
  sleep 2
  menu
  return
fi

for domain in $(cat $hostlist); do
  domain=$(echo $domain | tr -d '\r')
  mkdir -p $domain $domain/masscan $domain/nmap
  echo "$domain" > $domain/domain.txt
  echo -e ${BLUE}"[+] Resolving $domain to IP:- "
  massdns -r ~/tools/resolvers/resolver.txt -t A -o S -w $domain/masscan/results.txt $domain/domain.txt
  cat $domain/masscan/results.txt | awk -F ". " '{print $3}' | sort -u | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | tee $domain/masscan/ip.txt

  echo -e ${GREEN}"\n[+] NMAP NSE SCAN Started for $domain:- "
  nmap -sV --script vulners.nse -iL $domain/masscan/ip.txt -oN $domain/nmap/scan.txt
done
}

menu(){
clear
nmap_scan
echo -e ${YELLOW}"\n[*] Which Type of Scan do you want to perform?\n "
echo -e "  ${NC}[${CG}"1"${NC}]${CNC} Single domain Scan"
echo -e "  ${NC}[${CG}"2"${NC}]${CNC} List of domains"
echo -e "  ${NC}[${CG}"3"${NC}]${CNC} Full domain scan with subdomains"
echo -e "  ${NC}[${CG}"4"${NC}]${CNC} Exit"

echo -n -e ${YELLOW}"\n[+] Select: "
read choice
case $choice in
  1) scan_single ;;
  2) scan_list ;;
  3) scan_all ;;
  4) exit 0 ;;
  *) 
    echo -e ${RED}"\n[!] Invalid option. Please try again."
    sleep 2
    menu
    ;;
esac
}

# Check if required tools are installed
check_dependencies() {
  local missing=()
  local tools=("massdns" "subfinder" "assetfinder" "amass" "shuffledns" "httpx" "jq" "nmap")
  
  for tool in "${tools[@]}"; do
    if ! command -v $tool &> /dev/null; then
      missing+=("$tool")
    fi
  done
  
  if [ ${#missing[@]} -ne 0 ]; then
    echo -e ${RED}"[!] The following tools are missing: ${missing[*]}"
    echo -e ${YELLOW}"[!] Please run install.sh first to install all dependencies"
    exit 1
  fi
  
  if [ ! -f ~/tools/resolvers/resolver.txt ]; then
    echo -e ${RED}"[!] Resolver file not found at ~/tools/resolvers/resolver.txt"
    echo -e ${YELLOW}"[!] Please run install.sh first to set up resolvers"
    exit 1
  fi
}

# Main execution
check_dependencies
menu
