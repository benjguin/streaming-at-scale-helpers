#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/incl_initvars.sh
source $DIR/incl_azlogin.sh

echo "please confirm you want to delete resource group $sasprefix"
echo "it has the following resources ..."
az resource list -g $sasprefix --output table
az group delete --name $sasprefix
