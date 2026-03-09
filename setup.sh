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

# ১. আর্কিটেকচার ডিটেক্ট এবং সঠিক .so ফাইলের লিংক সেটআপ
arch=$(uname -m)
if [[ "$arch" == *"aarch64"* ]]; then
    echo -e "${GREEN}[+] 64-bit architecture detected.${NC}"
    SO_URL="https://github.com/jubairbro/CRACK-VPS/raw/main/sensei_core_64.so"
elif [[ "$arch" == *"armv7"* ]] || [[ "$arch" == *"arm"* ]]; then
    echo -e "${GREEN}[+] 32-bit architecture detected.${NC}"
    SO_URL="https://github.com/jubairbro/CRACK-VPS/raw/main/sensei_core_32.so"
else
    # আনসাপোর্টেড ডিভাইসের জন্য এরর মেসেজ
    echo -e "${RED}[!] Your device not supported this tool plisse Contract Admin.${NC}"
    exit 1
fi

# ২. সিস্টেম আপডেট অপশনাল
echo -e "${CYAN}[?] Do you want to update and upgrade system packages? (y/n): ${NC}"
read -r opt
if [[ "$opt" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo -e "${YELLOW}[*] Updating system...${NC}"
    pkg update -y && pkg upgrade -y
else
    echo -e "${YELLOW}[*] Skipping system update...${NC}"
fi

# ৩. প্রয়োজনীয় প্যাকেজ এবং পাইথন মডিউল ইন্সটল
echo -e "${YELLOW}[*] Checking required tools & modules...${NC}"
pkg install python binutils curl ncurses-utils -y > /dev/null 2>&1
pip install rich requests aiohttp beautifulsoup4 urllib3 --quiet

# ৪. .so ফাইল সুরক্ষিত ফোল্ডারে রাখা
INSTALL_DIR="$PREFIX/share/sensei_vps"
mkdir -p "$INSTALL_DIR"

echo -e "${YELLOW}[*] Downloading core engine from GitHub...${NC}"
curl -Ls "$SO_URL" -o "$INSTALL_DIR/sensei_core.so"

if [ -f "$INSTALL_DIR/sensei_core.so" ]; then
    
    # ৫. লঞ্চার তৈরি করে /usr/bin (Termux এর $PREFIX/bin) এ সেভ করা
    LAUNCHER="$PREFIX/bin/vps"
    cat <<EOF > "$LAUNCHER"
#!/usr/bin/env python3
import sys
sys.path.insert(0, "$INSTALL_DIR")
try:
    import sensei_core
    sensei_core.main()
except ImportError as e:
    print(f"\n[!] Core Engine Error: {e}")
    print("[*] Please contact @JubairSensei")
EOF
    
    # লঞ্চারকে এক্সিকিউটেবল পারমিশন দেওয়া
    chmod +x "$LAUNCHER"

    echo -e "${GREEN}──────────────────────────────────────────────────${NC}"
    echo -e "${GREEN}[+] SUCESSFULLY INSTALLED!${NC}"
    echo -e "${CYAN}[*] Command to run: ${YELLOW}vps${NC}"
    echo -e "${GREEN}──────────────────────────────────────────────────${NC}"
else
    echo -e "${RED}[!] Download failed! Check your internet connection.${NC}"
    exit 1
fi

# ৬. স্ক্রিপ্ট রান হওয়ার পর নিজেকে ডিলিট করে দেওয়া
rm -f "$0"
