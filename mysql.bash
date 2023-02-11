#!/bin/bash

clear
# Define the main menu options
main_menu_options=(
    "Install MySQL"
    "Install phpMyAdmin"
    "Create database and user"
    "Delete database and user"
    "Exit"
)

# Function to display the main menu and handle user input
function show_main_menu {
    echo "Please choose an option:"
    for ((i = 0; i < ${#main_menu_options[@]}; i++)); do
        echo "$((i + 1)). ${main_menu_options[$i]}"
    done

    # Read user input
    read -p "Enter your choice (1, 2, 3, 4 or 5): " main_menu_choice

    # Validate user input
    if [[ $main_menu_choice -lt 1 || $main_menu_choice -gt 5 ]]; then
        echo "Invalid option, please try again."
        show_main_menu
    else
        # Call the corresponding function based on user input
        case $main_menu_choice in
            1) install_mysql ;;
            2) install_phpmyadmin ;;
            3) create_database_and_user ;;
            4) delete_database_and_user ;;
            5) exit 0 ;;
        esac
    fi
}

# Function to install MySQL
function install_mysql {
    # Install MySQL server
    sudo apt-get update
    echo -n "Enter MariaDB (MySQL) Version (e.g. 10.5): "
    read mdbv
    sudo apt-get install mariadb-server-$mdbv mariadb-server-core-$mdbv

    # Start the MySQL service
    sudo systemctl start mysql

    # Check the status of the MySQL service
    mysql_status=$(systemctl is-active mysql)
    if [ "$mysql_status" == "active" ]; then
        echo "MySQL server has been installed and started successfully."
    else
        echo "Failed to start MySQL server."
    fi

    # Return to the main menu
    show_main_menu
}

# Function to install phpMyAdmin
function install_phpmyadmin {
    # Install phpMyAdmin
    sudo apt-get update
    sudo apt-get install phpmyadmin

    # Check if phpMyAdmin was installed successfully
    if [ -f "/usr/share/phpmyadmin/index.php" ]; then
        echo "phpMyAdmin has been installed successfully."
    else
        echo "Failed to install phpMyAdmin."
    fi

    # Return to the main menu
    show_main_menu
}

# Function to create a database and user
function create_database_and_user {
    # Read the database name and user credentials
    read -p "Enter the database name: " database_name
    read -p "Enter the database user name: " database_user
    read -p "Enter the database user password: " database_password

    # Create the database and user
    echo "CREATE DATABASE $database_name;" | mysql -u root
    echo "CREATE USER '$database_user'@'localhost' IDENTIFIED BY '$database_password';" | mysql -u root
    echo "GRANT ALL PRIVILEGES ON $database_name.* TO '$database_user'@'localhost';" | mysql -u root
    echo "FLUSH PRIVILEGES;" | mysql -u root

# Check if the database and user were created successfully
database_exists=$(mysql -u root -e "SHOW DATABASES LIKE '$database_name'" | grep "$database_name")
if [ "$database_exists" == "$database_name" ]; then
    echo "The database and user were created successfully."
else
    echo "Failed to create the database and user."
fi

# Return to the main menu
show_main_menu
}

function delete_database_and_user {
# Read the database name and user credentials
read -p "Enter the database name to delete: " database_name
read -p "Enter the database user name to delete: " database_user
# Delete the database and user
echo "DROP DATABASE $database_name;" | mysql -u root
echo "DROP USER '$database_user'@'localhost';" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root

# Check if the database and user were deleted successfully
database_exists=$(mysql -u root -e "SHOW DATABASES LIKE '$database_name'" | grep "$database_name")
if [ -z "$database_exists" ]; then
    echo "The database and user were deleted successfully."
else
    echo "Failed to delete the database and user."
fi

# Return to the main menu
show_main_menu
}

show_main_menu