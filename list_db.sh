#!/usr/bin/bash

function list_databases() {
  #confirm that only dir returns
  #  -F  appends a character  slash / for directories dir/  file1  shortcut@. grep / filters only the directories.
  #  tr / " " is replace the trailing slashes / with spaces.

  databases=$(ls -F | grep /  | tr / " ")

  if [ -z "$databases" ]; then  #-z returns true if the $databases is empty
    echo "===================================================="
    echo "No DataBases Existing Now ❌! "
  else
    echo "===================================================="
    echo "$databases" | sed 's:/$::' #sed, used to remove the trailing slash (/) from each file name.
  fi
}