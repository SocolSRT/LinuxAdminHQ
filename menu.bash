#!/bin/bash
clear
echo "#########################################
# Nginx Web Server Management Menu #
#########################################

1. Install Nginx
2. Install PHP
3. Add a Domain
4. Remove a Domain
5. Add Reverse Proxy
6. Remove Reverse Proxy
7. Add SSL certificate
8. Connecting SSL
9. Exit

"
while true; do
  read -p "Enter your choice [1-9]: " choice
  case $choice in
    1)
      # Install Nginx
      echo "Available Nginx versions: 1.18.0, 1.19.5, 1.20.2"
      read -p "Enter the Nginx version you want to install (e.g. 1.20.2): " nginx_version
      echo "Installing Nginx $nginx_version..."
      sudo apt-get update
      sudo apt-get install nginx=$nginx_version-*
      echo "Nginx $nginx_version has been installed."
      ;;
    2)
      # Install PHP
      echo "Available PHP versions: 7.2, 7.4, 8.0"
      read -p "Enter the PHP version you want to install (e.g. 7.4): " php_version
      echo "Installing PHP $php_version..."
      sudo apt-get install php$php_version-fpm php$php_version-mysql php$php_version-gd php$php_version-curl php$php_version-json php$php_version-mbstring php$php_version-xml
      echo "PHP $php_version has been installed."
      ;;
    3)
      # Add a Domain
      read -p "Enter the domain name: " domain
      # Create a folder for the domain
      sudo mkdir -p /var/www/$domain
      echo "Folder for $domain has been created. (/var/www/$domain)"
      sudo rm /etc/nginx/sites-enabled/$domain
      echo -n "server {
    listen 80;
    server_name $domain;
    root /var/www/$domain;
    # logging
    access_log /var/log/nginx/$domain.access.log;
    error_log /var/log/nginx/$domain.error.log warn;
    # index
    index index.php index.html index.htm default.php default.htm default.html;
    # handle .php
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php-fpm.sock;
    }
}" | sudo tee -a /etc/nginx/sites-enabled/$domain
sudo service nginx restart
      ;;
    4)
      # Remove a Domain
      read -p "Enter the domain name: " domain
      # Remove the folder for the domain
      echo "Removing the folder for $domain..."
      sudo rm -rf /var/www/$domain
	  sudo rm /etc/nginx/sites-enabled/$domain
	  sudo rm /var/log/nginx/$domain.access.log;
	  sudo rm /var/log/nginx/$domain.error.log;
	  sudo rm /etc/nginx/ssl/$domain.crt;
	  sudo rm /etc/nginx/ssl/$domain.key;
      echo "Folder for $domain has been removed."
      ;;
    5)
      # Add Reverse Proxy
      read -p "Enter the domain name: " domain
      read -p "Enter the IP: " IPdomain
      echo "Adding reverse proxy for $domain..."
      # Add the following code to the Nginx configuration:
	  sudo rm /etc/nginx/sites-enabled/$domain
      echo -n "server {
    listen 80;
    server_name $domain;
    location / {
        proxy_pass         http://$IPdomain:80;
    }
}" | sudo tee -a /etc/nginx/sites-enabled/$domain
      # Save and exit the configuration file
      # Restart Nginx to apply changes
      sudo service nginx restart
      echo "Reverse proxy has been added for $domain."
      ;;
    6)
      # Remove Reverse Proxy
      read -p "Enter the domain name: " domain
	  sudo rm /etc/nginx/sites-enabled/$domain
      # Save and exit the configuration file
      # Restart Nginx to apply changes
      sudo service nginx restart
      echo "Reverse proxy has been removed for $domain."
      ;;
    7)
      # Create SSL certificate
      read -p "Enter the domain name for the SSL certificate: " domain
      echo "Creating SSL certificate for $domain..."
	  sudo mkdir -p /etc/nginx/ssl/
      sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/$domain.key -out /etc/nginx/ssl/$domain.crt
      echo "SSL certificate for $domain has been created."
      ;;
    8)
      # Connect SSL certificate
      read -p "Enter the domain name to connect the SSL certificate to: " domain
      sudo rm /etc/nginx/sites-enabled/$domain
      echo "Connecting SSL certificate to $domain..."
      echo -n "server {
    listen 80;
    listen 443 ssl;
    server_name $domain;
    root /var/www/$domain;
    ssl_certificate /etc/nginx/ssl/$domain.crt;
    ssl_certificate_key /etc/nginx/ssl/$domain.key;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers HIGH:!aNULL:!MD5;
    # logging
    access_log /var/log/nginx/$domain.access.log;
    error_log /var/log/nginx/$domain.error.log warn;
    # index
    index index.php index.html index.htm default.php default.htm default.html;
    # handle .php
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php-fpm.sock;
    }
}" | sudo tee -a /etc/nginx/sites-enabled/$domain
      sudo systemctl reload nginx
      echo "SSL certificate has been connected to $domain."
      ;;
    9)
      # Exit
      break
      ;;
    *)
      echo "Invalid choice. Please enter a number between 1 and 9."
      ;;
  esac
done
