#!/usr/bin/bash

function insert_into_table() {
  while true; do
      # List available tables and prompt user for input
      echo "===================================================="
      echo "                   Available tables                 "
      echo "===================================================="

      tables=($(ls -p | grep -v / | tr / " "))
      # Check if no tables exist
      if [ -z "$tables" ]; then
          echo "No tables available to drop. Returning to Menu...❌."
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

      # Get column names, primary keys, and types from the file
      IFS='|' read -r -a column_names < <(head -n 1 "$table")
      IFS='|' read -r -a column_keys < <(head -n 2 "$table" | tail -n 1)
      IFS='|' read -r -a column_types < <(head -n 3 "$table" | tail -n 1)

      # Find the index of the primary key column
      primary_key_index=-1
      for ((i=0; i<${#column_keys[@]}; i++)); do
          if [ "${column_keys[i]}" == "yes" ]; then
              primary_key_index=$i
              break
          fi
      done

      # Load existing primary key values into an array
      primary_key_values=()
      while read -r line; do
          IFS='|' read -ra values <<< "$line"
          primary_key_values+=("${values[$primary_key_index]}")
      done < <(tail -n +4 "$table")

      # Prompt user for values
      values=()
      for ((i=0; i<${#column_names[@]}; i++)); do
          while true; do
              read -p "#-> Enter value for ${column_names[i]} (${column_types[i]}): " value

              case "${column_types[i]}" in
                  "int")
                      if [[ "$value" =~ ^[0-9]+$ ]]; then
                          break
                      else
                          echo "Invalid input. Please enter an integer ❌."
                      fi
                      ;;
                  "str")
                      if [[ "$value" =~ ^[a-zA-Z_]+$ && ${#value} -ge 2 ]]; then
                          break
                      else
                          if [ -z "$value" ]; then
                              echo "Invalid input. Please enter a non-empty string ❌."
                          elif [[ "$value" =~ ^[0-9]+$ ]]; then
                              echo "Invalid input. Numbers not accepted, Please enter a non-empty string ❌."
                          elif [ ${#value} -lt 2 ]; then
                              echo "Invalid input. Please enter a string with a minimum length of two characters ❌."
                          else
                              echo "Invalid input. Please enter a string without special characters or numbers ❌."
                          fi
                      fi
                      ;;
                  *)
                      echo "Unknown column type: ${column_types[i]} ❌."
                      ;;
              esac
          done


          if [ $i -eq $primary_key_index ]; then
              while true; do
                  if [[ " ${primary_key_values[@]} " =~ " $value " ]] || { [ "${column_types[i]}" == "int" ] && ! [[ "$value" =~ ^[0-9]+$ ]]; } || { [ "${column_types[i]}" == "str" ] && ! [[ "$value" =~ ^[a-zA-Z_]+$ ]]; }; then
                      if [[ " ${primary_key_values[@]} " =~ " $value " ]]; then
                          echo "Error: Primary key value '$value' is already in use. Please enter a unique value ❌."
                      elif [ "${column_types[i]}" == "int" ]; then
                          echo "Invalid input. Please enter an integer for ${column_names[i]} ❌."
                      elif [ "${column_types[i]}" == "str" ]; then
                          echo "Invalid input. Please enter a string without special characters for ${column_names[i]} ❌."
                      else
                          echo "Unknown column type: ${column_types[i]} ❌"

                      fi

                      read -p "#-> Enter value for ${column_names[i]} (${column_types[i]}): " value
                  else
                      break
                  fi
              done
          fi

          values+=("$value|")
      done

      # Append values to the file
      echo "${values[*]}" >> "$table"

      echo "===================================================="
      echo "Data inserted successfully into table $table ✅."
      break
  done
}