#!/usr/bin/bash

function list_tables() {
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
}