# this script is meant to be executed thru source. e.g. source myscript.sh, rather than ./myscript.sh

function newPassword {
	pwdpart1=`< /dev/urandom tr -dc 'A-Z' | head -c2`
	pwdpart2=`< /dev/urandom tr -dc 'a-z' | head -c4`
	pwdpart3=`< /dev/urandom tr -dc '0-9' | head -c3`
	pwdpart4=`< /dev/urandom tr -dc '_!;@#*&^' | head -c3`
	password="${pwdpart1}${pwdpart2}${pwdpart3}${pwdpart4}"
	echo $password
}

function copyHomeConfigToVm {
	vmFqdn=$1
	scp -r -o StrictHostKeyChecking=no -i $sshPrivateKeyPath $homeConfigFolder ${username}@${vmFqdn}:~/$homeConfigFolder
}

function copySshKeysToVm {
	vmFqdn=$1
	scp -o StrictHostKeyChecking=no -i $sshPrivateKeyPath $sshPublicKeyPath ${username}@${vmFqdn}:~/.ssh
	scp -o StrictHostKeyChecking=no -i $sshPrivateKeyPath $sshPrivateKeyPath ${username}@${vmFqdn}:~/.ssh
	sshPrivateKeyFilename=`basename $sshPrivateKeyPath`
	cat > /tmp/config << EOF
Host *
	IdentityFile ~/.ssh/${sshPrivateKeyFilename}
EOF
	scp -o StrictHostKeyChecking=no -i $sshPrivateKeyPath /tmp/config ${username}@${vmFqdn}:~/.ssh
	rm /tmp/config
}