#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/incl_initvars.sh

echo "configuration is in folder $localConfigFolderPath"
ls -als $localConfigFolderPath

echo "$localConfigFolderPath/config:" 
cat $localConfigFolderPath/config
