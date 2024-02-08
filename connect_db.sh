#!/usr/bin/bash

connect_database() {
    # List all databases and select one to connect
    databases=($(ls -F | grep / | tr / " "))
    echo "#-> Select the number of the database you want to connect:"
    select choice in "${databases[@]}";
    do
        if [ -n "$choice" ]; then
            if [ -d "$choice" ]; then
              echo "===================================================="
              cd "$choice"
              echo "You are connected to database '$choice' successfully ✅."
              menu_operations_on_table
              #handle_database_operations "$choice"
            else
                echo "===================================================="
                echo "Database with name '$choice' does not exist ❌."
            fi
        else
            echo "===================================================="
            echo "Invalid choice. Please select a valid number of database ❌."
        fi
    done
}


menu_operations_on_table() {
  while true;
  do
    echo "===================================================="
    echo "                      Tables Menu:                  "
    echo "===================================================="
    echo "1. Create Table"
    echo "2. List Tables"
    echo "3. Drop Table"
    echo "4. Insert Into Table"
    echo "5. Select From Table"
    echo "6. Delete From Table"
    echo "7. Update From Table"
    echo "8. Exit"
    echo "===================================================="
    read -p "#-> Enter your choice: " choice

    case $choice in
      1)
          echo "Creating table"
          #source create_table.sh
          echo "Test"
          ;;
      2)
          echo "Listing tables"
          #source listing_table.sh
          ;;
      3)
          echo "Dropping table"
          #source drop_table.sh
          ;;
      4)
          echo "Inserting in table"
          #source insert_table.sh
          ;;
      5)
          echo "Selecting from table"
          #select_table.sh
          ;;
      6)
          echo "Deleting from table"
          #delete_table.sh
          ;;
      7)
          echo "Updating from table"
          #update_table.sh
          ;;
      *)
          echo "This option is not in the menu. Please try again ❌."
          ;;
  esac
  done
}

