#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/incl_initvars.sh
source $DIR/incl_azlogin.sh

az eventhubs namespace create -g $resourceGroupName \
    --name $ehknsName \
    --sku Standard --capacity 2 \
    --enable-kafka true \
    --enable-auto-inflate false

source $DIR/incl_createEHKTopics.sh
