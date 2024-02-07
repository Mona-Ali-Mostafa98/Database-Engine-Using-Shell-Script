#!/usr/bin/bash

# Function to drop database
function drop_database() {
    # List all databases and select one to drop
    databases=($(ls -F | grep / | tr / " "))
    #echo "${databases[@]}"
    echo "#-> Select the number of the database you want to drop:"
    select choice in "${databases[@]}";
    do
        if [ -n "$choice" ]; then
            read -p "Are you sure you want to drop '$choice'? (yes/no)" confirm

            case $confirm in
                yes|y)
                    if [ -d "$choice" ]; then
                        rm -r "$choice"
                        echo "===================================================="
                        echo "Database with name '$choice' deleted successfully."
                    else
                        echo "===================================================="
                        echo "Database with name '$choice' does not exist."
                    fi
                    break
                    ;;
                no|n)
                    echo "===================================================="
                    echo "Dropping database with name '$choice' canceled."
                    break
                    ;;
                *)
                    echo "===================================================="
                    echo "Invalid input. Please enter 'yes' or 'no'."
                    ;;
            esac
        else
            echo "===================================================="
            echo "Invalid choice. Please select a valid number of database."
        fi
    done
}


#
#source ./functions.sh
#
#read -p "Enter Database Name: " database_name
#
## Check if the database directory exists
#if [ -d "$database_name" ]; then
#    rm -r "$database_name"
#    echo "'$database_name' Database deleted Successfully."
#else
#    echo "'$database_name' does not exist, enter right database name."
#fi
