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

echo -e ${RED}    "###############################################################"
echo -e ${ORANGE} " #                  DOMAIN TO IP RESOLVERS & NMAP SCAN         #  "
echo -e ${PINK}   " #                                                             #  "
echo -e ${BLUE}   " #                   DARKBOSS1BD PRESENTS                      #  "
echo -e ${YELLOW} " #             Coded By: darkboss1bd                           #  "
echo -e ${CP}     " #             Telegram: https://t.me/darkvaiadmin             #  "
echo -e ${CP}     " #             Website: https://serialkey.top/                 #  "
echo -e ${CP}     " #             Channel: https://t.me/windowspremiumkey         #  "
echo -e ${RED}    "################################################################ \n "

d=$(date +"%b-%d-%y %H:%M")
sleep 1
echo -e ${CP}"[+] Installation Started On: $d \n"
sleep 1
echo -e ${BLUE}"[+] Checking Go Installation\n"

if ! command -v go &> /dev/null; then
  echo -e ${RED}"[+] Go is not Installed. Please install it and run the script again"
  echo -e ${CP}"[+] For Installation check: https://golang.org/doc/install"
  exit 1
else
  echo -e ${BLUE}"..........Go is installed..............\n"
fi

echo -e ${GREEN}"[+] Installing Assetfinder\n"
sleep 1

assetfinder_checking(){
  if ! command -v assetfinder &> /dev/null; then 
    go install github.com/tomnomnom/assetfinder@latest
    sudo cp ~/go/bin/assetfinder /usr/local/bin/
    echo -e ".............assetfinder successfully installed..............\n"
  else
    echo -e ".......assetfinder already installed..........\n"
  fi
}
assetfinder_checking

sleep 1
echo -e ${RED}"[+] Installing Seclists\n"
if [ ! -d /usr/share/seclists ]; then 
  sudo apt update
  sudo apt install seclists -y
  echo -e "....................Seclists Successfully Installed.................\n"
else
  echo -e ".................Seclists Already Exists.................\n"
fi

sleep 1
echo -e ${PINK}"[+] Installing Amass\n"
amass_checking(){
  if ! command -v amass &> /dev/null; then
    sudo apt-get install amass -y
    echo -e "................Amass successfully installed..............\n"
  else
    echo -e "..........Amass is already installed..........\n"
  fi
}
amass_checking

sleep 1
echo -e ${GRAY}"[+] Installing jq\n"
jq_checking(){
  if ! command -v jq &> /dev/null; then
    sudo apt-get install jq -y
    echo -e ".................jq successfully installed..............\n"
  else
    echo -e "...........jq is already installed..............\n"
  fi
}
jq_checking

sleep 1
echo -e ${ORANGE}"[+] Installing Subfinder\n"
subfinder_checking(){
  if ! command -v subfinder &> /dev/null; then
    go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
    sudo cp ~/go/bin/subfinder /usr/local/bin/
    echo -e "................subfinder successfully installed..............\n"
  else
    echo -e "...........subfinder is already installed.............\n"
  fi
}
subfinder_checking

sleep 1
echo -e ${YELLOW}"[+] Installing massdns\n"
massdns_checking(){
  mkdir -p ~/tools
  if ! command -v massdns &> /dev/null; then
    cd ~/tools
    git clone https://github.com/blechschmidt/massdns.git
    cd massdns
    make
    sudo cp bin/massdns /usr/local/bin/
    echo -e "............massdns installed successfully............\n"
  else
    echo -e "..........massdns is already installed............\n"
  fi
}
massdns_checking

sleep 1
echo -e ${CNC}"[+] Installing dnsvalidator (Branding Removed)\n"
dnsvalidator_installing(){
  mkdir -p ~/tools
  mkdir -p ~/tools/resolvers

  if ! command -v dnsvalidator &> /dev/null; then
    cd ~/tools
    git clone https://github.com/vortexau/dnsvalidator.git
    cd dnsvalidator
    
    # Remove all branding from the source code
    echo -e ${YELLOW}"[+] Removing dnsvalidator branding...\n"
    # Remove version and author information from __init__.py
    sed -i 's/^__version__ = .*$/__version__ = "1.1"/' dnsvalidator/__init__.py
    sed -i '/by James McLean/d' dnsvalidator/__init__.py
    sed -i '/@vortexau/d' dnsvalidator/__init__.py
    sed -i '/Michael Skelton/d' dnsvalidator/__init__.py
    sed -i '/@codingo_/d' dnsvalidator/__init__.py
    
    # Remove branding from validator.py
    sed -i '/dnsvalidator v/d' dnsvalidator/validator.py
    sed -i '/by James McLean/d' dnsvalidator/validator.py
    sed -i '/@vortexau/d' dnsvalidator/validator.py
    sed -i '/Michael Skelton/d' dnsvalidator/validator.py
    sed -i '/@codingo_/d' dnsvalidator/validator.py
    
    sudo apt-get install python3-pip -y
    sudo python3 setup.py install 
    
    dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 25 -o resolvers.txt
    cat resolvers.txt | tail -n 60 > ~/tools/resolvers/resolver.txt
    echo -e ".............dnsvalidator successfully installed (branding removed)..............\n"
  else
    echo -e ".......dnsvalidator already exist.........\n"
  fi
}
dnsvalidator_installing

sleep 1
echo -e ${CPO}"[+] Installing shuffledns\n"
if ! command -v shuffledns &> /dev/null; then
  go install -v github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest
  sudo cp ~/go/bin/shuffledns /usr/local/bin/
  echo -e ".................shuffledns successfully installed..............\n"
else
  echo -e "...............shuffledns is already installed.............\n"
fi

sleep 1
echo -e ${CPO}"[+] Installing httpx\n"
if ! command -v httpx &> /dev/null; then
  go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
  sudo cp ~/go/bin/httpx /usr/local/bin/
  echo -e ".................httpx successfully installed..............\n"
else
  echo -e "...............httpx is already installed.............\n"
fi

sleep 1
echo -e ${CP}"[+] Installing httprobe\n"
if ! command -v httprobe &> /dev/null; then
  go install github.com/tomnomnom/httprobe@latest
  sudo cp ~/go/bin/httprobe /usr/local/bin/
  echo -e ".............httprobe successfully installed..............\n"
else
  echo -e "...........httprobe is already installed...............\n"
fi

sleep 1
echo -e ${CG}"[+] Installing NMAP NSE scripts\n"
nmap_script(){
  if [ ! -f /usr/share/nmap/scripts/vulners.nse ]; then
    cd /usr/share/nmap/scripts
    sudo wget https://raw.githubusercontent.com/vulnersCom/nmap-vulners/master/vulners.nse
    echo -e "...............vulners.nse successfully installed..................\n"
  else
    echo -e "...............vulners.nse already exists................\n"
  fi

  sleep 1
  echo -e ${CP}"[+] Installing vulnscan For NMAP\n"
  if [ ! -d /usr/share/nmap/scripts/vulscan ]; then
    cd /usr/share/nmap/scripts
    sudo git clone https://github.com/scipag/vulscan.git
    echo -e "......................vulnscan successfully installed................\n"
  else
    echo -e "....................vulnscan already exists....................\n"
  fi
}
nmap_script

echo -e ${BLUE}"[+] Installation Complete! "
echo -e ${GREEN}"[+] Run the script.sh to start scanning"
