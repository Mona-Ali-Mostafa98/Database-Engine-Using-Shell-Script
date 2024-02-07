#!/usr/bin/bash

function list_databases() {
  #confirm that only dir returns #transate / by space
  ls -F | grep /  | tr / " "
}