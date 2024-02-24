#!/usr/bin/bash
function delete_from_table() {
    tables=($(ls -p | grep -v / | tr / " "))

    if [ -z "$tables" ]; then  # Check if no tables exist
        echo "===================================================="
        echo "No tables available to drop. Returning to Menu...❌."
    else
        echo "#-> Select the number of the table you want to drop: "

        select table in "${tables[@]}" "exit"; do #expands to all elements in the array (tables).
            if [ "$table" == "exit" ]; then
                echo "Exiting the script..."
                sleep 1
                break 2
            elif [ -n "$table" ]; then      # [ -n "$table" ]: checks if the variable $table is not an empty string
                if [ -e "$table" ]; then    # [ -e "$table" ] checks if a file or directory with the name specified in the variable $table exists
                    if [ "$(awk 'NR >= 4 { print NR - 3 }' "$table" | wc -l)" -eq 0 ]; then
                        echo "===================================================="
                        echo "The file $table has no data. Cannot perform deletion ⚠️."
                        break
                    else
                        # Prompt user for deletion choice
                        # PS3="Select an choice #->"
                        select choice in "Delete Specified Row From Table" "Delete All Rows From Table" "Exit"; do
                            case $choice in
                                "Delete Specified Row From Table")
                                    echo "===================================================="
                                    echo "Existing rows in $table:"
                                    awk 'NR >= 4 { print NR - 3 ": " $0 }' "$table"

                                    max_row_number=$(awk 'END {print NR - 3}' "$table")
                                    valid_row=false

                                    while [ "$valid_row" = false ]; do
                                        read -p "#-> Enter the row number to delete (max:$max_row_number): " row_number

                                        if [[ $row_number =~ ^[1-9][0-9]*$ && $row_number -le $max_row_number ]]; then
                                            valid_row=true
                                        else
                                            echo "Please enter a valid row number (1 to $max_row_number)."
                                        fi
                                    done

                                    while true; do
                                        read -p "Are you sure you want to delete row? (yes(y) / no(n))? " confirm

                                        case $confirm in
                                            yes|y)
                                                if [ -f "$table" ]; then
                                                    line_number=$((row_number + 3))
                                                    sed -i "${line_number}d" "$table"
                                                    echo "===================================================="
                                                    echo "Row $row_number deleted successfully from $table ✅."
                                                else
                                                    echo "===================================================="
                                                    echo "Row $row_number does not exist in $table ❌."
                                                fi
                                                break
                                                ;;
                                            no|n)
                                                echo "===================================================="
                                                echo "Deleting Row $row_number From table canceled ⚠️."
                                                break
                                                ;;
                                            *)
                                                echo "===================================================="
                                                echo "Invalid input. Please enter 'yes' or 'no'❌."
                                                ;;
                                        esac
                                    done
                                    break
                                    ;;
                                "Delete All Rows From Table")
                                    read -p "Are you sure you want to delete all data (yes(y) / no(n))?  " confirm
                                    case $confirm in
                                        yes|y)
                                            if [ -f "$table" ]; then
                                                sed -i '4,$d' "$table"
                                                echo "===================================================="
                                                echo "All data deleted successfully from $table ✅."
                                            else
                                                echo "===================================================="
                                                echo "Row $row_number does not exist in $table ❌."
                                            fi
                                            break
                                            ;;
                                        no|n)
                                            echo "===================================================="
                                            echo "Operation canceled. No data was deleted ⚠️."
                                            break
                                            ;;
                                        *)
                                            echo "===================================================="
                                            echo "Invalid input. Please enter 'yes' or 'no'❌."
                                            ;;
                                    esac
                                    break
                                    ;;
                                "Exit")
                                    echo "===================================================="
                                    echo "Exiting ⚠️."
                                    break 2
                                    ;;
                                *)
                                    echo "===================================================="
                                    echo "Invalid choice. Please select a valid option ❌."
                                    ;;
                            esac
                        done
                    fi
                else
                    echo "===================================================="
                    echo "Table '$table' does not exist ❌."
                fi
            else
                echo "===================================================="
                echo "Invalid choice. Please select a valid number of table ❌."
            fi

            read -p "Do you want to drop another table? (yes(y) / no(n))? " drop_another
            case $drop_another in
                yes|y) ;;
                no|n)
                    echo "===================================================="
                    echo "Returning to Main Menu..."
                    sleep 1
                    break
                    ;;
                *)
                    echo "===================================================="
                    echo "Invalid input. Please enter 'yes' or 'no' ❌."
                    ;;
            esac
        done
    fi
}

