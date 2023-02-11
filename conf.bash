#!/bin/bash
function main_menu {
    clear
    echo "##### Main Menu #####"
    echo "1. Nginx Configuration"
    echo "2. PHP Configuration"
    echo "3. Exit"
    echo
    echo -n "Enter your choice [1-3]: "
    read choice
    case $choice in
        1) nginx_menu;;
        2) php_menu;;
        3) exit 0;;
        *) echo -e "\nInvalid option. Try again."; sleep 2; main_menu;;
    esac
}
function nginx_menu {
    clear
    echo "##### Nginx Configuration #####"
    echo "1. View current Nginx configuration"
    echo "2. Edit Nginx configuration"
    echo "3. Edit existing domain"
    echo "4. Restart Nginx service"
    echo "5. Back to Main Menu"
    echo
    echo -n "Enter your choice [1-5]: "
    read choice
    case $choice in
        1) view_nginx_config;;
        2) edit_nginx_config;;
        3) edit_domain;;
        4) restart_nginx;;
        5) main_menu;;
        *) echo -e "\nInvalid option. Try again."; sleep 2; nginx_menu;;
    esac
}
function php_menu {
    clear
    echo "##### PHP Configuration #####"
    echo "1. View current PHP configuration"
    echo "2. Edit PHP configuration"
    echo "3. Restart PHP service"
    echo "4. Back to Main Menu"
    echo
    echo -n "Enter your choice [1-4]: "
    read choice
    case $choice in
        1) view_php_config;;
        2) edit_php_config;;
        3) restart_php;;
        4) main_menu;;
        *) echo -e "\nInvalid option. Try again."; sleep 2; php_menu;;
    esac
}
function view_nginx_config {
    clear
    echo "##### Nginx Configuration #####"
    echo
    cat /etc/nginx/nginx.conf
    echo
    echo -n "Press any key to continue..."
    read
    nginx_menu
}
function edit_nginx_config {
    clear
    echo "##### Nginx Configuration #####"
    echo
    nano /etc/nginx/nginx.conf
    nginx_menu
}
function restart_nginx {
    clear
    echo "##### Nginx Configuration #####"
    echo
    sudo service nginx restart
    echo
    echo "Nginx service has been restarted."
    echo -n "Press any key to continue..."
    read
    nginx_menu
}
function edit_domain {
    clear
    echo "##### Edit Domain Configuration #####"
    echo
    echo -n "Enter the domain name: "
    read domain_name
    sudo nano /etc/nginx/sites-enabled/$domain_name
    nginx_menu
}
function view_php_config {
    clear
    echo "##### PHP Configuration #####"
    echo
    php --ini
    echo
    echo -n "Press any key to continue..."
    read
    php_menu
}
function edit_php_config {
    clear
    echo "##### PHP Configuration #####"
    echo
    nano $(php --ini | grep "Loaded Configuration File" | awk '{print $4}')
    php_menu
}
function restart_php {
    clear
    echo "##### PHP Configuration #####"
    echo
    echo -n "Enter PHP Version: "
    read phpv
    sudo service php$phpv-fpm restart
    echo
    echo "PHP service has been restarted."
    echo -n "Press any key to continue..."
    read
    php_menu
}
main_menu
