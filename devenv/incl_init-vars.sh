# this script is meant to be executed thru source. e.g. source myscript.sh, rather than ./myscript.sh

# Folder where user specific config is saved/read
localConfigFolderPath="$HOME/.ApacheFlinkOnAzure"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/incl_helpers.sh

# Get default values from config if it exists
if [[ -f ${localConfigFolderPath}/config ]]
then
    source ${localConfigFolderPath}/config
    echo "Configuration is in ${localConfigFolderPath} folder. Feel free to update or remove it (remove to reset to default value and new ssh keys)."
fi

# ssh key pair
if [[ -z "$sshPublicKeyPath" ]] || [[ -z "$sshPrivateKeyPath" ]]
then
    if [[ -f ${localConfigFolderPath}/sshkey ]] && [[ -f ${localConfigFolderPath}/sshkey.pub ]]
    then
        echo "using ssh keys (${localConfigFolderPath}/sshkey and ${localConfigFolderPath}/sshkey.pub)"
    else
        echo "generating ssh keypair (${localConfigFolderPath}/sshkey)"
        mkdir -p ${localConfigFolderPath}
        ssh-keygen -q -N "" -t rsa -f ${localConfigFolderPath}/sshkey
    fi
    # set ssh private and public key path variables
    sshPublicKeyPath=${localConfigFolderPath}/sshkey.pub
    sshPrivateKeyPath=${localConfigFolderPath}/sshkey
else
    echo "using private and public key paths $sshPrivateKeyPath and $sshPublicKeyPath"
fi

# folder where ssh keypair will be copied in the Windows File system so that X2Go can access it
if [[ -z "$windowsFolderForSshKeyPair" ]]
then
    echo "ssh key pair will not be copied to the Windows file system"
else
    echo "using windowsFolderForSshKeyPair '$windowsFolderForSshKeyPair'"
fi


# azureSubscription is the Azure subscription where deployment will happen. If it's empty, the default one will be used.
if [[ -z "$azureSubscription" ]]
then
    echo "will use the default Azure Subscription from az cli"
else
    echo "using azureSubscription '$azureSubscription'"
fi

# location is the Azure region where deployment will happen
if [[ -z "$location" ]]
then
    location="westus"
    echo "using default location '$location'"
else
    echo "using location '$location'"
fi

# username
if [[ -z "$username" ]]
then
    username="azureuser"
    echo "using default username '$username'"
else
    echo "using username '$username'"
fi

# password
if [[ -z "$password" ]]
then
    password="`newPassword`"
    echo "generated a password"
else
    echo "using existing password"
fi

# GitHub Organization
if [[ -z "$githubOrg" ]]
then
    githubOrg="Azure-Samples"
    echo "initializing GitHub Organization with '$githubOrg'"
else
    echo "using GitHub Organization '$githubOrg'"
fi


# uniqueString helps having DNS names and other names unique across several installations
if [[ -z "$uniqueString" ]]
then
    uniqueString=`< /dev/urandom tr -dc 'a-z0-9' | head -c5`
    echo "using uniqueString '$uniqueString'"
else
    echo "using uniqueString '$uniqueString'"
fi

# resourceGroupName is the resource group name where deployment will happen
if [[ -z "$resourceGroupName" ]]
then
    resourceGroupName="rg${uniqueString}"
    echo "using resourceGroupName '$resourceGroupName'"
else
    echo "using resourceGroupName '$resourceGroupName'"
fi

if [[ -z "$skipAzLogin" ]]
then
    skipAzLogin="false"
fi
echo "skipAzLogin=$skipAzLogin"

# Save configuration
mkdir -p ${localConfigFolderPath}
mv ${localConfigFolderPath}/config ${localConfigFolderPath}/config.old 2> /dev/null || true
cat > ${localConfigFolderPath}/config << EOF
azureSubscription="$azureSubscription"
location="$location"
username="$username"
password="$password"
githubOrg="$githubOrg"
uniqueString="$uniqueString"
resourceGroupName="$resourceGroupName"
sshPublicKeyPath="$sshPublicKeyPath"
sshPrivateKeyPath="$sshPrivateKeyPath"
skipAzLogin=$skipAzLogin
windowsFolderForSshKeyPair=$windowsFolderForSshKeyPair
EOF

# Set other variables
## nsg=Network Security Group, hdi=HDInsight, ehk=Event Hubs Kafka, ns=namespace, sas=streaming-at-scale
vnetName="vnet$uniqueString"
nsgName="${vnetName}-nsg"
devVmName=devvm$uniqueString
devVmFqdn="${devVmName}.${location}.cloudapp.azure.com"
hdiName="hdi$uniqueString"
hdiSshEndpoint="${hdiName}-ssh.azurehdinsight.net"
storageName="sto$uniqueString"
ehknsName="ehkns$uniqueString"
ehkTopicsOfTypeA="afinput afoutput"
sasprefix="sas$uniqueString"

# Find the right image with the following commands:
## az vm image list-publishers --location westeurope --output table
## az vm image list --publisher microsoft-dsvm --location westeurope --all
#devVmImageUrn="microsoft-dsvm:linux-data-science-vm-ubuntu:linuxdsvmubuntu:latest"
#devVmImageUrn="microsoft-dsvm:linux-data-science-vm-ubuntu:linuxdsvmubuntu:19.08.23"
devVmImageUrn="Canonical:UbuntuServer:18.04-LTS:latest"
## check it exists with: az vm image show --urn $devVmImageUrn --location westeurope
