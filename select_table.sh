#!/usr/bin/bash
function select_from_table() {
    while true; do
        echo "===================================================="
        echo "                Available tables                    "
        echo "===================================================="

        tables=($(ls -p | grep -v / | tr / " "))
        # Check if no tables exist
        if [ -z "$tables" ]; then
            echo "No tables available to drop. Returning to Menu...❌."
            #sleep 1
            #exit
        else
            echo "#-> Select the number of the table you want to connect:"
        fi

        # Check if no tables exist
        select table in "${tables[@]}" "exit"; do
            if [ "$table" == "exit" ]; then
                echo "Exiting the script..."
                sleep 1
                break 2
            elif [[ ! -z "$table" && -e "$table" ]]; then #checks whether the variable $table is not empty and whether a file with the name stored in $table exists.
                break
            else
                echo "Invalid choice. Please enter a valid number or 'exit' ❌."
            fi
        done

        IFS='|' read -r -a column_names < <(head -n 1 "$table")
        IFS='|' read -r -a column_keys < <(head -n 2 "$table" | tail -n 1)
        IFS='|' read -r -a column_types < <(head -n 3 "$table" | tail -n 1)

#        select_all
#
#        select_by_primary_key
#
#        select_by_column

        options=("Select All Rows" "Select Row by Primary Key" "Select by Column" "Quit")

        select choice in "${options[@]}"; do
            case $choice in
                "Select All Rows")
                    select_all
                    break
                    ;;
                "Select Row by Primary Key")
                    select_by_primary_key
                    break
                    ;;
                "Select by Column")
                    select_by_column
                    break
                    ;;
                "Quit")
                    echo "Quitting..."
                    break 2
                    ;;
                *)
                    echo "Invalid option"
                    ;;
            esac
        done
    done
}
select_all() {
    echo "Executing: SELECT * FROM $table;"
    echo "===================================================="
    echo "Columns: ${column_names[@]}"
    echo "===================================================="

    awk -F'|' '
        BEGIN {
            print "Processing file"
        }

        NR == 1 {
            # Print the first row with column names
            print "Columns:", $0
        }

        NR > 3 {
            # Main block, executed for each line after the third row
            print "Values :", $0
        }

        END {
            print "Processing complete."
        }
    ' "$table"
}

select_by_column() {
    read -p "#-> Enter the column names (comma-separated): " column_names_input
    IFS=',' read -r -a selected_columns <<< "$column_names_input"

    for col in "${selected_columns[@]}"; do
        if ! awk -v col="$col" 'NR==1 {gsub(/\|/, " "); for (i=1; i<=NF; i++) if ($i == col) exit 0; exit 1}' "$table"; then
            echo "Column '$col' does not exist. Please enter valid column names ❌."
            return
        fi
    done

    for col in "${selected_columns[@]}"; do
        printf "%s|" "$col"
    done
    echo ""

    indices=()
    for col in "${selected_columns[@]}"; do
        indices+=( $(awk -F'|' -v col="$col" 'NR==1 {for (i=1; i<=NF; i++) if ($i == col) print i}' "$table") )
    done

    awk -F'|' -v OFS='|' -v indices="${indices[*]}" '
        BEGIN {
            split(indices, cols, " ");
        }
        NR > 3 {
            for (i in cols) {
                printf "%s%s", $cols[i], (i == length(cols)) ? "" : OFS
            }
            print ""
        }
    ' "$table"
}

select_by_primary_key() {
    primary_key_column_index=$(awk -F'|' 'NR==2 {for (i=1; i<=NF; i++) if ($i == "yes") print i}' "$table")

    if [ -z "$primary_key_column_index" ]; then
        echo "No primary key column found in the table ❌."
        return
    fi

    read -p "#-> Enter the primary key value: " primary_key
    echo "Executing: SELECT * FROM $table WHERE ${column_names[$((primary_key_column_index-1))]} = $primary_key;"
    echo "===================================================="
    echo "Columns: ${column_names[@]}"
    echo "===================================================="

    awk -F'|' -v val="$primary_key" -v key_col="$primary_key_column_index" -v OFS=' | ' '
        BEGIN {
            print "Processing file"
        }

        NR == 1 {
            # Print the first row with column names
            print "Columns:", $0
        }

        {
            # Main block, executed for each line
            if ($key_col == val) {
                print "Values :", $0
                matched=1
            }
        }

        END {
            if (matched != 1) {
                print "No match found."
            }
            print "Processing complete."
        }
    ' matched=0 "$table"
}
