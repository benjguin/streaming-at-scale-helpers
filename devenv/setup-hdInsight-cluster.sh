#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/incl_init-vars.sh
source $DIR/incl_az-login.sh
source $DIR/incl_get-credentials.sh

existingVnet=`(az network vnet show -g $resourceGroupName --name $vnetName --query "name" --output tsv 2> /dev/null) || echo "not found"`
echo $existingVnet
if [[ "$existingVnet" == "not found" ]]
then
    echo "VNet $vnetName in resource group $resourceGroupName must exist before running this script"
    echo "please run a script like setupDevVm.sh to create them"
    exit 1
fi

subnetExists=`az network vnet subnet list -g $resourceGroupName --vnet-name $vnetName --output table | grep hdinsight | wc -l`
if [[ "$subnetExists" == "0" ]]
then
    echo "creating hdinsight subnet"
    az network vnet subnet create -g $resourceGroupName \
        --vnet-name $vnetName --name "hdinsight" \
        --address-prefixes 192.168.1.0/24
fi

# create storage account if it does not exist yet
if [[ "$storageKey" == "" ]]
then
    az storage account create -g $resourceGroupName \
        --name $storageName \
        --location $location \
        --kind StorageV2 \
        --hierarchical-namespace false \
        --https-only true \
        --sku Standard_LRS
    storageKey="`az storage account keys list -g $resourceGroupName --account-name $storageName --output tsv --query '[0].value' 2> /dev/null`"
fi

subnetId=`az network vnet subnet list -g $resourceGroupName --vnet-name $vnetName --output jsonc --query "[?name=='hdinsight'].id" --output tsv`
pubkey="`cat $sshPublicKeyPath`"

az hdinsight create -t hadoop -g $resourceGroupName --name $hdiName \
    --storage-container $hdiName \
    --version "4.0" \
    --http-user "$username" \
    --http-password "$password" \
    --ssh-user "$username" \
    --ssh-public-key "$pubkey" \
    --storage-account "$storageName" \
    --storage-account-key "$storageKey" \
    --subnet $subnetId \
    --workernode-count 3 \
    --workernode-size Standard_D12_v2 \
    --headnode-size Standard_D12_v2 \
    --zookeepernode-size Standard_D12_v2

copySshKeysToVm $hdiSshEndpoint
