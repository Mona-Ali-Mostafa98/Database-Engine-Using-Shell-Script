#!/usr/bin/bash
function update_table() {

   while true; do
       # List available tables and prompt user for input
       echo "===================================================="
       echo "                   ✅Available tables ✅                "
       echo "===================================================="

       tables=($(ls -p | grep -v / | tr / " "))
       # Check if no tables exist
       if [ -z "$tables" ]; then
           echo "No tables available to drop. Returning to Menu...❌."
           sleep 1
           #exit
       else
           echo "#-> Select the number of the table you want to connect:"
       fi

       # Check if no tables exist
       select table in "${tables[@]}" "exit"; do #expands to all elements in the array.
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


       primary_key_index=-1
       for ((i=0; i<${#column_keys[@]}; i++)); do #expands to all elements in the array.
           if [ "${column_keys[i]}" == "yes" ]; then
               primary_key_index=$i
               break
           fi
       done


       primary_key_values=()
       while read -r line; do
           IFS='|' read -ra values <<< "$line"
           primary_key_values+=("${values[$primary_key_index]}")
       done < <(tail -n +4 "$table")


       if [ ${#primary_key_values[@]} -eq 0 ]; then #expands to all elements in the array.
           echo "File $table is empty."
           continue
       fi


       while true; do
           echo "===================================================="
           echo "Existing rows in $table:"
           #prints lines from the file specified by the variable $table starting from the fourth line
           awk 'NR >= 4 { print NR - 3 ": " $0 }' "$table"

           read -p "#-> Enter the primary key value to update a record: " update_primary_key_value

           if [[ ! " ${primary_key_values[@]} " =~ " $update_primary_key_value " ]]; then
               echo "Error: Primary key value '$update_primary_key_value' not found. Please enter a valid primary key value ❌."
           else
               break
           fi
       done


       update_record_index=-1
       while IFS='|' read -ra values; do
           ((update_record_index++))
           if [ "${values[$primary_key_index]}" == "$update_primary_key_value" ]; then
               break
           fi
       done < <(tail -n +4 "$table")


       while true; do
           echo "#->Choose a column to update:"
           for ((i=0; i<${#column_names[@]}; i++)); do
               echo "$((i+1)). ${column_names[i]} (${column_types[i]})"
           done

           read -p "#->Enter the number of the column to update: " update_column_number

           if [[ ! "$update_column_number" =~ ^[1-9][0-9]*$ || $update_column_number -gt ${#column_names[@]} ]]; then
               echo "Invalid input. Please enter a valid column number ❌."
           else
               break
           fi
       done


       while true; do
          read -p "#-> Enter updated value for ${column_names[update_column_number-1]} (${column_types[update_column_number-1]}): " updated_value

          if [[ ! " ${primary_key_values[@]} " =~ " $updated_value " ]]; then
              # Primary key check passed, now validate based on column type
               case "${column_types[update_column_number-1]}" in
                   "int")
                       if [[ "$updated_value" =~ ^[0-9]+$ ]]; then
                           break
                       else
                           echo "Invalid input. Please enter an integer ❌."
                       fi
                       ;;
                   "str")
                       if [[ "$updated_value" =~ ^[a-zA-Z_]+$ && ${#updated_value} -ge 2 ]]; then
                           break
                       else
                           if [ -z "$updated_value" ]; then
                               echo "Invalid input. Please enter a non-empty string ❌."
                           elif [[ "$updated_value" =~ ^[0-9]+$ ]]; then
                               echo "Invalid input. Numbers not accepted, Please enter a non-empty string ❌."
                           elif [ ${#updated_value} -lt 2 ]; then
                               echo "Invalid input. Please enter a string with a minimum length of two characters ❌."
                           else
                               echo "Invalid input. Please enter a string without special characters or numbers ❌."
                           fi
                       fi
                       ;;
                   *)
                       echo "Unknown column type: ${column_types[update_column_number-1]} ❌."
                       ;;
               esac
          else
              echo "Error: Primary key value '$updated_value' already exists. Please enter a unique primary key value ❌."
          fi
       done

        awk -v update_record_index="$update_record_index" -v update_column_number="$update_column_number" -v updated_value="$updated_value" 'NR == update_record_index + 4 { split(updated_value, new_values, "|"); $update_column_number = updated_value } 1' FS="|" OFS="|" "$table" > temp_file && mv temp_file "$table"

       echo "===================================================="
       echo "Record updated successfully in table $table ✅."
       break
   done
}