#!/usr/bin/bash
validate_name() {
    local entered_name="$1"

    # Check if the entered name is empty
    if [[ -z "$entered_name" ]]; then
        echo "Error: Name cannot be empty."
        return 1
    fi

    # Check if the entered name starts with a number
    if [[ "$entered_name" =~ ^[0-9] ]]; then
        # Check if the entered name contains only numbers
        if [[ "$entered_name" =~ ^[0-9]+$ ]]; then
            echo "Error: Name cannot consist only of numbers."
            return 1
        else
            echo "Error: Name cannot start with a number."
            return 1
        fi
    fi

    # Replace spaces in the middle with underscores
    entered_name=${entered_name// /_}

    # Remove leading and trailing spaces
    entered_name="${entered_name#"${entered_name%%[![:space:]]*}"}"
    entered_name="${entered_name%"${entered_name##*[![:space:]]}"}"

    # Convert entered name to lowercase
    entered_name=$(tr '[:upper:]' '[:lower:]' <<< "$entered_name")

    # Check if the entered name contains at least one lowercase letter
    if [[ "$entered_name" != *[[:lower:]]* ]]; then
        echo "Error: Name must contain at least one lowercase letter."
        return 1
    fi

    # Check if the entered name contains special characters
    if [[ ! "$entered_name" =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo "Error: Name can only contain alphanumeric characters and underscores."
        return 1
    fi

    # Output the final entered name
    echo "$entered_name"
    return 0
}
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
        echo " OPS !! the directory is already exist "
        #continue
    else
        # Create the directory with the validated name
        mkdir "$database_name"
        echo "===================================================="
        echo "$database_name Created Successfully"
        #break
    fi
}