#!/usr/bin/bash

# Function to drop database
function drop_database() {
    databases=($(ls -F | grep / | tr / " ")) # List all databases and select one to drop

    while true; do
        echo "#-> Select the number of the database you want to drop: "

        select database in "${databases[@]}";
        do
            if [ -n "$database" ]; then
                while true; do
                    read -p "Are you sure you want to drop '$database'? (yes(y) / no(n))?   " confirm

                    case $confirm in
                        yes|y)
                            if [ -d "$database" ]; then
                                rm -r "$database"
                                echo "===================================================="
                                echo "Database with name '$database' deleted successfully ✅."
                            else
                                echo "===================================================="
                                echo "Database with name '$database' does not exist ❌."
                            fi
                            return
                            ;;
                        no|n)
                            echo "===================================================="
                            echo "Dropping database with name '$database' canceled ️⚠️."
                            return
                            ;;
                        *)
                            echo "===================================================="
                            echo "Invalid input. Please enter 'yes' or 'no'❌."
                            ;;
                    esac
                done
            else
                clear
                echo "===================================================="
                echo "Invalid choice. Please select a valid number of database ❌."
            fi
        done
    done
}
