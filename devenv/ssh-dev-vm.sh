#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/incl_init-vars.sh
source $DIR/incl_az-login.sh

ssh -i $sshPrivateKeyPath ${username}@${devVmFqdn}
