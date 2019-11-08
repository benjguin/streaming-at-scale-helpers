#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/incl_initvars.sh
source $DIR/incl_azlogin.sh

az vm deallocate -g $resourceGroupName --name $devVmName
