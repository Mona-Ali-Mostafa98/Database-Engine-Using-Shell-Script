#!/usr/bin/bash
source ./functions.sh

create_table() {
    #listing all files (excluding directories) in the current directory , -p dir/ file1  shortcut
    files=$(ls -p | grep -v /)

    #checks if the variable files is empty
    if [ -z "$files" ]; then
      echo "===================================================="
      echo "DataBase Is  Empty, No Tables Exist ❌! "
    else
      echo "===================================================="
      echo "Listing Tables Existing in DataBase ✅: "
      echo "$files" | sed 's:/$::'
    fi

    while true; do
        read -p "#-> Enter the table name (enter 'exit' to quit): " entered_name

        # Validate the entered name
        table_name=$(validate_name "$entered_name")

        if validate_name "$entered_name"; then
            break
        fi
    done


    if [ "$table_name" == "exit" ]; then
        echo "Exiting the script..."
        sleep 1.5
        break
    elif [ -e "$table_name" ]; then
        echo "There's a table with the same name. Please enter another name ❌."
    else
        while true; do
            read -p "Enter the number of columns in this table: " num_columns

            if [[ ! $num_columns =~ ^[1-9][0-9]*$ ]]; then
                echo "Please enter a valid number of columns (greater than 0) ❌."
                continue
            else
                break
            fi
        done

        names=""
        types=""
        keys=""
        primary_key_selected=false

        for ((i=1; i<=$num_columns; i++)); do
            while true; do
                read -p "Please, Enter column $i name: " column_name
                if [[ "$names" == *"$column_name"* ]]; then
                    echo "Column name must be unique. Please enter a different name ❌."
                    continue
                else
                    break
                fi
            done

            while true; do
                read -p "Is '$column_name' column a primary key? (yes/no): " column_is_primary_key

                if [[ "$column_is_primary_key" != "yes" && "$column_is_primary_key" != "no" ]]; then
                    echo "Please enter 'yes' or 'no' for the primary key."
                    continue
                else
                    break
                fi
            done

            if [ "$column_is_primary_key" == "yes" ]; then
                if [ "$primary_key_selected" == true ]; then
                    echo "Only one primary key allowed."
                    ((i--)) # Decrease the loop counter to prompt for the same column again
                    continue
                else
                    primary_key_selected=true
                fi
            fi

            while true; do
                read -p "Enter the type for $column_name (string/integer): " column_type

                if [[ "$column_type" != "string" && "$column_type" != "integer" ]]; then
                    echo "Please enter 'string' or 'integer' for the column type ❌."
                    continue
                else
                    break
                fi
            done

            names+="$column_name"
            types+="$column_type"
            keys+="$column_is_primary_key"

            if [ $i -lt $num_columns ]; then
                names+="|"
                types+="|"
                keys+="|"
            fi
        done

        if [ "$primary_key_selected" == false ]; then
            echo "At least one primary key is required. Please define a column as a primary key ❌."
            continue
        fi

        echo "$names" >> "$table_name"
        echo "$keys" >> "$table_name"
        echo "$types" >> "$table_name"

        echo "Table with name '$table_name' created successfully ✅."
        break
    fi
}
