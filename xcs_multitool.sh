#!/bin/bash
# ==============================================
# X Cyber Squad Multifunction Cyber Toolkit
# Author: Neerav Patel (Cyber Expert & Investigator)
# Version: 2.0 - CLI Mode (Terminal Only)
# ==============================================

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Banner
function banner() {
  echo -e "${GREEN}"
  echo "==============================="
  echo "  X Cyber Squad CLI Toolkit"
  echo "  Author: Neerav Patel"
  echo "  Version: 2.0"
  echo "==============================="
  echo -e "${NC}"
}

# 1. Website Scanner
function website_scanner() {
  echo -n "Enter domain (example.com): "; read domain

  echo -e "${YELLOW}--- WHOIS Info ---${NC}"
  whois "$domain"

  echo -e "${YELLOW}--- DNS Info ---${NC}"
  dig "$domain"

  echo -e "${YELLOW}--- Real IP ---${NC}"
  dig +short "$domain"

  echo -e "${YELLOW}--- Nmap Scan ---${NC}"
  nmap -Pn -sV "$domain"

  echo -e "${YELLOW}--- Subdomain Scan ---${NC}"
  curl -s https://api.hackertarget.com/hostsearch/?q=$domain

  echo -e "${YELLOW}--- Vulnerability Check ---${NC}"
  nmap --script vuln "$domain"

  echo -e "${YELLOW}--- Exploit Check (SearchSploit) ---${NC}"
  searchsploit "$domain"
}

# 2. QR Code Analyzer
function qr_scanner() {
  echo -n "Enter full path to QR image: "; read file
  if [[ -f "$file" ]]; then
    data=$(zbarimg --raw "$file" 2>/dev/null)
    echo -e "${YELLOW}QR Data: $data${NC}"

    if echo "$data" | grep -qi "upi"; then
      echo "✅ Real Payment QR Found"
      upi_id=$(echo "$data" | grep -oP '(?<=upi:\/\/pay\?pa=)[^&]*')
      echo "UPI ID: $upi_id"
    elif echo "$data" | grep -qi ".apk"; then
      echo "⚠️ Malicious APK QR Detected"
    else
      echo "❓ Unknown or Fake QR"
    fi
  else
    echo -e "${RED}QR file not found.${NC}"
  fi
}

# 3. IP and MAC Tracer
function ip_mac_tracer() {
  echo -n "Enter IP or MAC: "; read input
  if [[ "$input" == *.* || "$input" == *:* ]]; then
    curl -s ipinfo.io/$input/json | jq
  else
    curl -s https://api.macvendors.com/$input
  fi
}

# 4. Username Social Mapper
function username_mapper() {
  echo -n "Enter username: "; read uname
  platforms=(facebook instagram twitter github reddit tiktok)
  for site in "${platforms[@]}"; do
    url="https://www.$site.com/$uname"
    status=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    if [[ "$status" == "200" ]]; then
      echo -e "${GREEN}[FOUND] $url${NC}"
    else
      echo -e "[--] Not found on $site"
    fi
  done
}

# 5. Phone Number OSINT (PhoneInfoga CLI required)
function phone_osint() {
  echo -n "Enter phone number with country code: "; read phone
  phoneinfoga scan -n "$phone"
}

# 6. Phishing Link Detector
function phishing_detector() {
  echo -n "Enter URL: "; read url
  echo "Checking safety..."
  curl -s -L --max-time 5 "$url" -o /dev/null
  dig +short $(echo "$url" | awk -F/ '{print $3}')
  echo "Check using: https://www.virustotal.com/gui/url"
}

# 7. Data Breach Checker (email/phone)
function data_breach_checker() {
  echo -n "Enter email or phone: "; read input
  echo "Checking breach..."
  curl -s "https://haveibeenpwned.com/unifiedsearch/$input"
}

# 8. HackRadar (Live Attack Map Link)
function hack_radar() {
  echo "Opening Live Map..."
  echo "Visit: https://cybermap.kaspersky.com"
}

# Main Menu
function main_menu() {
  banner
  echo "1. Website Scanner"
  echo "2. QR Code Analyzer"
  echo "3. IP & MAC Tracer"
  echo "4. Username Social Mapper"
  echo "5. Phone Number OSINT"
  echo "6. Phishing Link Detector"
  echo "7. Data Breach Checker"
  echo "8. Hack Radar (Live Attacks)"
  echo "9. Exit"
  echo "-----------------------------"
  echo -n "Choose option: "; read opt

  case $opt in
    1) website_scanner;;
    2) qr_scanner;;
    3) ip_mac_tracer;;
    4) username_mapper;;
    5) phone_osint;;
    6) phishing_detector;;
    7) data_breach_checker;;
    8) hack_radar;;
    9) exit 0;;
    *) echo -e "${RED}Invalid choice.${NC}";;
  esac
}

# Loop
while true; do
  main_menu
  echo -n "Press Enter to continue..."; read
  clear
done
