#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/incl_init-vars.sh

if [[ -z "$windowsFolderForSshKeyPair" ]]
then
    docSshPrivateKeyOnWindows="windowsFolderForSshKeyPair is empty in config so you have to copy and find correct config for X2Go the key yourself"
else
    if ! [[ -f ${windowsFolderForSshKeyPair}/ApacheFlinkOnAzure_ssh.private ]]
    then
        cp $sshPrivateKeyPath ${windowsFolderForSshKeyPair}/ApacheFlinkOnAzure_ssh.private
        echo "copied $sshPrivateKeyPath to ${windowsFolderForSshKeyPair}/ApacheFlinkOnAzure_ssh.private"
    fi
    if ! [[ -f ${windowsFolderForSshKeyPair}/ApacheFlinkOnAzure_ssh.public ]]
    then
        cp $sshPublicKeyPath ${windowsFolderForSshKeyPair}/ApacheFlinkOnAzure_ssh.public
        echo "copied $sshPublicKeyPath to ${windowsFolderForSshKeyPair}/ApacheFlinkOnAzure_ssh.public"
    fi
    docSshPrivateKeyOnWindows="use RSA/DSA key for ssh connection: browse and find file corresponding to ${windowsFolderForSshKeyPair}/ApacheFlinkOnAzure_ssh.private"
fi

echo "here are the parameters for X2Go:"
echo "Session name: $devVmName"
echo "Host: $devVmFqdn"
echo "Login: $username"
echo $docSshPrivateKeyOnWindows
echo "Session Type: XFCE"
