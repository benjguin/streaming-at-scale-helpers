#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/incl_init-vars.sh

echo "configuration is in folder $HOME/$homeConfigFolder"
ls -als $HOME/$homeConfigFolder

echo "$HOME/$homeConfigFolder/config:" 
cat $HOME/$homeConfigFolder/config
