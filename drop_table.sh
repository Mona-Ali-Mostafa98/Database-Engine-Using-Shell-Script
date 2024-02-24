#!/usr/bin/bash
function drop_table() {
    # List available tables and prompt user for input
    tables=($(ls -p | grep -v / | tr / " "))
    # Check if no tables exist
    if [ -z "$tables" ]; then
        echo "===================================================="
        echo "No tables available to drop.Returning to Menu ❌."
        sleep 1
        exit

    else
        echo "#-> Select the number of the table you want to connect:"

        select table in "${tables[@]}";do #expands to all elements in the array (tables).
            if [ -n "$table" ]; then
                while true; do
                    read -p "Are you sure you want to drop '$table'? (yes(y) / no(n))?" confirm

                    case $confirm in
                        yes|y)
                            if [ -f "$table" ]; then
                                rm "$table"
                                echo "===================================================="
                                echo "Table with name '$table' deleted successfully ✅."
                            else
                                echo "===================================================="
                                echo "Table with name '$table' does not exist ❌."
                            fi
                            break
                            ;;
                        no|n)
                            echo "===================================================="
                            echo "Dropping table with name '$table' canceled ⚠️."
                            break
                            ;;
                        *)
                            echo "===================================================="
                            echo "Invalid input. Please enter 'yes' or 'no'❌."
                            ;;
                    esac
                done
            else
                echo "===================================================="
                echo "Invalid choice. Please select a valid number of table ❌."
            fi
        done
    fi
}

