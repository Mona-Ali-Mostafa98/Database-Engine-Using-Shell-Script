#!/usr/bin/bash
source ./functions.sh

# Call read_name_and_validate to get the validated name
function create_database() {
    while true;
    do
        # Read the entered name from the user
        read -p "#-> Enter a Database Name: " entered_name
        # Validate the entered name
        database_name=$(validate_name "$entered_name")

#        if [[ $? -eq 0 ]]; then
#            break  # Exit the loop if the entered name is valid
#        fi
        if validate_name "$entered_name"; then
            break
        fi
    done

    # Check if the validated name is empty
    if [[ -z "$database_name" ]]; then
        echo "===================================================="
        echo "Error: Database name is empty."
    elif [ -d "$database_name" ];then
        echo "===================================================="
        echo " OPS !! the directory is already exist ❌."
        #continue
    else
        # Create the directory with the validated name
        mkdir "$database_name"
        echo "===================================================="
        echo "Database '$database_name' Created Successfully ✅."
        #break
    fi
}