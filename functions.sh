#!/usr/bin/bash
#************************start of validation name section************************

# Function to validate the database name
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

#************************end of validation name section************************


