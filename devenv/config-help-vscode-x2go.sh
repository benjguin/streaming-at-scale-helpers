#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/incl_init-vars.sh

if [[ -z "$windowsFolderForSshKeyPair" ]]
then
    docSshPrivateKeyOnWindows="windowsFolderForSshKeyPair is empty in config so you have to copy and find correct config for X2Go the key yourself"
else
    if ! [[ -f ${windowsFolderForSshKeyPair}/sash_ssh.private ]]
    then
        cp $sshPrivateKeyPath ${windowsFolderForSshKeyPair}/sash_ssh.private
        echo "copied $sshPrivateKeyPath to ${windowsFolderForSshKeyPair}/sash_ssh.private"
    fi
    if ! [[ -f ${windowsFolderForSshKeyPair}/sash_ssh.public ]]
    then
        cp $sshPublicKeyPath ${windowsFolderForSshKeyPair}/sash_ssh.public
        echo "copied $sshPublicKeyPath to ${windowsFolderForSshKeyPair}/sash_ssh.public"
    fi
    docSshPrivateKeyOnWindows="use RSA/DSA key for ssh connection: browse and find file corresponding to ${windowsFolderForSshKeyPair}/sash_ssh.private"
fi

Echo please execute the following Powershell code after changing path in Windows format:
cat << EOF
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

Install-Module -Force OpenSSHUtils -Scope AllUsers
Repair-UserKeyPermission -FilePath <equivalent of ${windowsFolderForSshKeyPair}/sash_ssh.public> @psBoundParameters
Repair-UserKeyPermission -FilePath <equivalent of ${windowsFolderForSshKeyPair}/sash_ssh.private> @psBoundParameters
EOF


echo ""
echo "here are the parameters for the Visual Studio Code ssh config file"
echo "Host $devVmFqdn"
echo "    HostName $devVmFqdn"
echo "    IdentityFile <equivalent in Windows syntax to ${windowsFolderForSshKeyPair}/sash_ssh.private>"
echo "    User $username"
echo ""
echo "here are the parameters for X2Go:"
echo "Session name: $devVmName"
echo "Host: $devVmFqdn"
echo "Login: $username"
echo $docSshPrivateKeyOnWindows
echo "Session Type: XFCE"
