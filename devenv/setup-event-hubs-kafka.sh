#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/incl_init-vars.sh
source $DIR/incl_az-login.sh

az eventhubs namespace create -g $resourceGroupName \
    --name $ehknsName \
    --sku Standard --capacity 2 \
    --enable-kafka true \
    --enable-auto-inflate false

source $DIR/incl_create-event-hubs-topics.sh
