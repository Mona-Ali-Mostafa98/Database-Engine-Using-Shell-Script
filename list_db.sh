#!/usr/bin/bash

function list_databases() {
  #confirm that only dir returns #transate / by space -F dir/  file1  shortcut@
  databases=$(ls -F | grep /  | tr / " ")
  #databases=$(find . -maxdepth 1 -type d ! -name '.' | sed 's/^\.\///')

  if [ -z "$databases" ]; then
    echo "===================================================="
    echo "No DataBases Existing Now ❌! "
  else
    echo "===================================================="
    echo "$databases" | sed 's:/$::' #sed, used to remove the trailing slash (/) from each file name.
  fi
}