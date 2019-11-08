#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/incl_initvars.sh
source $DIR/incl_azlogin.sh

pathToPop="`pwd`"

cd ~/code/streaming-at-scale/eventhubskafka-flink-eventhubskafka \
    || (echo "you first need to clone the repo and checkout the right branch" && exit 1)

option=$1

if [[ -z "$option" ]]
then
    option="1"
fi

if [[ ! -f $HOME/.ssh/id_rsa  ]] && [[ ! -f $HOME/.ssh/id_rsa.pub ]] && \
    [[ -n ${sshPrivateKeyPath:-} ]] && [[ -n ${sshPublicKeyPath:-} ]]
then
    echo "copy current keys to default keys so that az aks does not create a new key pair"
    cp $sshPrivateKeyPath $HOME/.ssh/id_rsa
    cp $sshPublicKeyPath $HOME/.ssh/id_rsa.pub
fi


echo "running with option $option"

if [[ "$option" == "1" ]]
then
    ./create-solution.sh \
        -d $sasprefix \
        -s CIPTM \
        -t 1 \
        -p aks \
        -a "simple-relay" \
        -l $location
elif [[ "$option" == "2" ]]
then
    ./create-solution.sh \
        -d $sasprefix \
        -s CIPTM \
        -t 1 \
        -p aks \
        -a "stateful" \
        -l $location
elif [[ "$option" == "3" ]]
then
    ./create-solution.sh \
        -d $sasprefix \
        -s CIPTM \
        -t 1 \
        -p aks \
        -a "complex-processing" \
        -l $location
else
    echo unknown option $option
fi

cd $pathToPop
