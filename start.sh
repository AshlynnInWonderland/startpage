#!/bin/bash

PWD="`pwd`"
DIR=$(dirname $0)

if [[ "$1" -eq "1" ]]
then
  cd "$DIR"
  /usr/bin/python3 -m http.server
  cd "$PWD"
else
  nohup "./$0" 1 0<&- &>/dev/null &
fi
