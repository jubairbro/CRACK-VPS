#!/bin/bash

# কালার কোড
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}──────────────────────────────────────────────────${NC}"
echo -e "${YELLOW}       SENSEI VPS CRACKER AUTO-INSTALLER          ${NC}"
echo -e "${CYAN}──────────────────────────────────────────────────${NC}"

# ১. আর্কিটেকচার চেক (৬৪-বিট মাস্ট)
arch=$(uname -m)
if [ "$arch" != "aarch64" ]; then
    echo -e "${RED}[!] Error: Your device ($arch) is not supported.${NC}"
    echo -e "${YELLOW}[*] Please contact Admin: @JubairSensei${NC}"
    exit 1
fi

# ২. আপডেট এবং আপগ্রেড অপশনাল (Y/n)
echo -e "${CYAN}[?] Do you want to update and upgrade system packages? (y/n): ${NC}"
read -r opt
if [[ "$opt" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo -e "${YELLOW}[*] Updating system...${NC}"
    pkg update -y && pkg upgrade -y
else
    echo -e "${YELLOW}[*] Skipping system update...${NC}"
fi

# ৩. পাইথন ভার্সন চেক এবং ইন্সটল
if command -v python &>/dev/null; then
    py_version=$(python --version 2>&1 | awk '{print $2}')
    echo -e "${GREEN}[+] Python $py_version already installed.${NC}"
else
    echo -e "${YELLOW}[*] Python not found. Installing latest Python...${NC}"
    pkg install python -y
fi

# ৪. প্রয়োজনীয় ডিপেন্ডেন্সি চেক (curl, binutils)
echo -e "${YELLOW}[*] Checking required tools...${NC}"
pkg install binutils curl ncurses-utils -y

echo -e "${YELLOW}[*] Checking Python modules (rich, requests, etc.)...${NC}"
pip install rich requests aiohttp beautifulsoup4 --quiet

echo -e "${YELLOW}[*] Downloading core binary from GitHub...${NC}"
BINARY_URL="https://github.com/jubairbro/CRACK-VPS/raw/refs/heads/main/vps"
curl -Ls "$BINARY_URL" -o vps

if [ -f "vps" ]; then
    chmod +x vps
    mv vps $PREFIX/bin/vps
    
    termux-elf-cleaner $PREFIX/bin/vps > /dev/null 2>&1
    
    echo -e "${GREEN}──────────────────────────────────────────────────${NC}"
    echo -e "${GREEN}[+] SUCESSFULLY INSTALLED!${NC}"
    echo -e "${CYAN}[*] Command to run: ${YELLOW}vps${NC}"
    echo -e "${GREEN}──────────────────────────────────────────────────${NC}"
else
    echo -e "${RED}[!] Download failed! Check your internet connection.${NC}"
    exit 1
fi

rm -f "$0"
