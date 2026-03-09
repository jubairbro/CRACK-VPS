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

# ১. আর্কিটেকচার চেক (শুধুমাত্র ৬৪-বিট সাপোর্ট)
arch=$(uname -m)
if [ "$arch" != "aarch64" ]; then
    echo -e "${RED}[!] Error: Your device ($arch) is not supported by this tool.${NC}"
    echo -e "${YELLOW}[*] Please contact Admin: @JubairSensei${NC}"
    exit 1
fi

echo -e "${GREEN}[+] Architecture: 64-bit (Supported)${NC}"

# ২. সিস্টেম আপডেট এবং ডিপেন্ডেন্সি ইন্সটল
echo -e "${YELLOW}[*] Updating system and installing dependencies...${NC}"
pkg update -y && pkg upgrade -y
pkg install python binutils ncurses-utils curl -y

# আপনার টুলসের জন্য দরকারি পাইথন লাইব্রেরি
echo -e "${YELLOW}[*] Installing required Python modules...${NC}"
pip install rich requests aiohttp beautifulsoup4

# ৩. বাইনারি ফাইল ডাউনলোড করা
echo -e "${YELLOW}[*] Downloading core binary from GitHub...${NC}"
BINARY_URL="https://github.com/jubairbro/CRACK-VPS/raw/refs/heads/main/vps"
curl -Ls "$BINARY_URL" -o vps

# ৪. ফাইলটি /usr/bin এ মুভ করা (যাতে সরাসরি 'vps' লিখলে রান হয়)
if [ -f "vps" ]; then
    chmod +x vps
    # টারমাক্সের জন্য সঠিক পাথে মুভ করা
    mv vps $PREFIX/bin/vps
    
    # লিন্কার ক্লিন করা যাতে এরর না দেয়
    termux-elf-cleaner $PREFIX/bin/vps > /dev/null 2>&1
    
    echo -e "${GREEN}──────────────────────────────────────────────────${NC}"
    echo -e "${GREEN}[+] SUCESSFULLY INSTALLED!${NC}"
    echo -e "${CYAN}[*] Now you can run the tool by typing: ${YELLOW}vps${NC}"
    echo -e "${GREEN}──────────────────────────────────────────────────${NC}"
else
    echo -e "${RED}[!] Download failed! Check your internet connection.${NC}"
    exit 1
fi

# ৫. নিজেকে নিজে ডিলিট করা (Self-destruction)
rm -f "$0"
