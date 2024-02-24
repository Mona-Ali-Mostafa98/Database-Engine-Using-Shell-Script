#!/usr/bin/bash
source ./functions.sh

create_table() {
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
        sleep 1
        break
    elif [ -e "$table_name" ]; then
        echo "===================================================="
        echo "There's a table with the same name. Please enter another name ❌."
    else
        while true; do
            read -p "#-> Enter the number of columns in this table: " num_columns

            if [[ ! $num_columns =~ ^[1-9][0-9]*$ ]]; then
                echo "Please enter a valid number of columns (greater than 0) ❌."
                continue
            else
                break
            fi
        done

        #strings used to store names, types, and primary key indicators for each column, respectively.
        names=""
        types=""
        keys=""

        for ((i=1; i<=$num_columns; i++)); do
            while true; do
                while true; do
                    read -p "#-> Please, Enter column $i name: " entered_name

                    column_name=$(validate_name "$entered_name")

                    if validate_name "$entered_name"; then  #-n "$column_name"
                        break
                    fi
                done

                if [[ "$names" == *"$column_name"* ]]; then
                    echo "Column name must be unique. Please enter a different name ❌."
                    continue
                else
                    break
                fi
            done

            if [ $i -eq 1 ]; then
                column_is_primary_key="yes"
                echo "#--> By Default Column # 1 is defined as a primary key ✅."
            else
                column_is_primary_key="no"
            fi

            while true; do
                read -p "#-> Enter the type for $column_name (str/int): " column_type

                if [[ "$column_type" != "str" && "$column_type" != "int" ]]; then
                    echo "Please enter 'str' or 'int' for the column type ❌."
                    continue
                else
                    break
                fi
            done

            names+="$column_name"
            types+="$column_type"
            keys+="$column_is_primary_key"

            if [ $i -lt $num_columns ]; then  # not the last column
                names+="|"
                types+="|"
                keys+="|"
            fi
        done

        echo "$names" >> "$table_name" # printed content (echo "$names") to the file $table_name.
        echo "$keys" >> "$table_name"
        echo "$types" >> "$table_name"

        echo "===================================================="
        echo "Table with name '$table_name' created successfully ✅."
    fi
}
