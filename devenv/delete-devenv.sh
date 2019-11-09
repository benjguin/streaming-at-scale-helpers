#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/incl_init-vars.sh
source $DIR/incl_az-login.sh

echo "please confirm you want to delete resource group $resourceGroupName"
echo "it has the following resources ..."
az resource list -g $resourceGroupName --output table
az group delete --name $resourceGroupName
