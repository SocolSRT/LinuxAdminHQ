#!/bin/bash

# Main loop
function main_menu {
  clear
  echo "==== Firewall Rule Management ===="
  echo "1. Add Block IP Rule"
  echo "2. Remove Block IP Rule"
  echo "3. View All Rules"
  echo "4. Install CSF Firewall"
  echo "5. Install WAF (Modsecurity - OWASP Rule)"
  echo "6. Exit"
  echo -n "Enter your choice [1-6]: "
  read choice

  case $choice in
    1) add_rule;;
    2) remove_rule;;
    3) view_rules;;
    4) set_l4_rules;;
    5) install_waf;;
    6) exit 0;;
    *) echo "Invalid choice. Try again.";;
  esac
}

# Function to add an iptables rule
function add_rule {
  read -p "Enter the IP address to be blocked: " ip_address
  iptables -A INPUT -s $ip_address -j DROP
  echo "Rule added successfully!"
}

# Function to remove an iptables rule
function remove_rule {
  read -p "Enter the IP address to unblock: " ip_address
  iptables -D INPUT -s $ip_address -j DROP
  echo "Rule removed successfully!"
}

# Function to view iptables rules
function view_rules {
  iptables -L
}

# Function to set standard L4 rules
function set_l4_rules {
  echo "Install CSF Firewall..."
  sudo apt-get install libwww-perl
  sudo perl -e "use Time::HiRes"
  sudo wget https://download.configserver.com/csf.tgz
  sudo tar -xzf csf.tgz
  rm -fv csf.tgz
  cd csf
  sudo sh install.sh
  sudo perl /etc/csf/csftest.pl
  cd
  sudo csf –s
}

# Function to install WAF (Modsecurity Nginx with OWASP Rule Set)
function install_waf {
  echo "Installing Modsecurity Nginx with OWASP Rule Set..."
  sudo apt-get install docker
  docker pull krish512/modsecurity
  echo "Modsecurity Nginx with OWASP Rule Set installed successfully!"
}

main_menu