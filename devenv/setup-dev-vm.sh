#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/incl_init-vars.sh
source $DIR/incl_az-login.sh

# create the resource group
az group create --name $resourceGroupName --location $location

# create an explicit VNET, for the IoT edge VM. The dev VM will also be put there, in another subnet
echo "Creating VNET, subnets, NSG, ..."
az network vnet create -g $resourceGroupName --name $vnetName --address-prefix 192.168.0.0/16 --subnet-name default --subnet-prefix 192.168.0.0/24
az network nsg create -g $resourceGroupName --name $nsgName
az network nsg rule create -g $resourceGroupName --nsg-name $nsgName --name allow-ssh --description "allow-ssh" --protocol tcp --priority 101 --destination-port-range "22"

# Create a dev VM
echo "creating the dev VM"
az vm image accept-terms --urn $devVmImageUrn
az vm create -g $resourceGroupName --name $devVmName --size Standard_DS3_v2 --image $devVmImageUrn --admin-username "$username" --ssh-key-values "$sshPublicKeyPath" --vnet-name $vnetName --subnet default --public-ip-address-allocation dynamic --public-ip-address-dns-name $devVmName

# dev VM: copy the same config and ssh keys to the VM
copyHomeConfigToVm ${devVmFqdn}
copySshKeysToVm ${devVmFqdn}

# dev VM: update and install tools (NB: git is already installed)
echo "updating the dev VM and installing tools"
cat > /tmp/dev1.sh << 'EOF'
#!/bin/bash
# executed as root
apt-get update -y
apt-get upgrade -y
apt-get install -y x2goserver
apt-get install -y xfce4
apt-get install -y firefox
apt-get install -y zip unzip jq
apt-get install -y openjdk-8-jdk
apt-get install -y maven
snap install intellij-idea-community --classic
apt-get install -y docker.io
apt-get install -y docker-compose
# https://stackoverflow.com/questions/50151833/cannot-login-to-docker-account
apt-get install -y gnupg2 pass
groupadd docker
gpasswd -a $USER docker
#newgrp docker

curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
apt-get install -y apt-transport-https
apt-get update -y
sed -i 's/BIG-REQUESTS/_IG-REQUESTS/' /usr/lib/x86_64-linux-gnu/libxcb.so.1.1.0
sudo apt-get install -y code 

curl -sL https://aka.ms/InstallAzureCLIDeb | bash

popPath=`pwd`

cd /tmp
curl -LO https://git.io/get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl

cd $popPath
EOF

cat > /tmp/dev2.sh << 'EOF'
#!/bin/bash
# executed as user
cd $HOME
mkdir code
mkdir bin

cd $HOME
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install scala 2.12.7
EOF

scp -o StrictHostKeyChecking=no -i $sshPrivateKeyPath /tmp/dev1.sh ${username}@${devVmFqdn}:/tmp 
scp -o StrictHostKeyChecking=no -i $sshPrivateKeyPath /tmp/dev2.sh ${username}@${devVmFqdn}:/tmp 
rm /tmp/dev1.sh
rm /tmp/dev2.sh
ssh -i ${sshPrivateKeyPath} ${username}@${devVmFqdn} sudo -n -u root -s "bash -v /tmp/dev1.sh &> /tmp/dev1.log 2>&1"
ssh -i ${sshPrivateKeyPath} ${username}@${devVmFqdn} "bash -v /tmp/dev2.sh &> /tmp/dev2.log 2>&1"

echo "You can connect to the dev VM with the following command"
echo "ssh -i $sshPrivateKeyPath ${username}@${devVmFqdn}"
