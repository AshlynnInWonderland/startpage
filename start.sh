#!/bin/bash

PWD="`pwd`"
DIR=$(dirname $0)

cd "$DIR"
detach /usr/bin/python3 -m http.server > /dev/null
cd "$PWD"
