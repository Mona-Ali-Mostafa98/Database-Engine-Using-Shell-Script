#!/usr/bin/bash
source ./create_db.sh
source ./list_db.sh
source ./drop_db.sh
source ./connect_db.sh

#************************start of menu************************
echo "===================================================="
echo "          ✅ Hello From my Database System ✅        "
echo "===================================================="

database_dir="Databases"

if [ -d "$database_dir" ]; then
    sudo chmod 777 "./$database_dir"
    cd "$database_dir" || exit 1
    echo "Switched to Databases directory ✅."
else
    sudo mkdir ./$database_dir
    sudo chmod 777 "./$database_dir"
    cd "$database_dir" || exit 1
    echo "Created databases directory and Switched to it ✅."
fi

while true;
do
    echo "===================================================="
    echo "                      Menu:                          "
    echo "===================================================="
    echo "1. Create Database"
    echo "2. List Databases"
    echo "3. Drop Database"
    echo "4. Connect Database"
    echo "5. Exit"
    echo "===================================================="
    read -p "#-> Enter your choice: " choice
    case $choice in
        1)
            echo "--------># Creating database"
            create_database
            ;;
        2)
            echo "--------># Listing all databases"
            list_databases
            ;;
        3)
            echo "--------># Dropping database"
            drop_database
            ;;
        4)
            echo  "--------># Connecting to a database"
            connect_database
            echo "===================================================="
            ;;
        5)
            echo "--------># Bye, Exiting program."
            echo "===================================================="
            exit 0
            ;;
        *)
            echo "❌ Invalid choice. Please enter 1, 2, 3, or 4 ❌."
            ;;
    esac
done
