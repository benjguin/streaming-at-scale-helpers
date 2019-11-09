#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/incl_init-vars.sh
source $DIR/incl_az-login.sh

cd $HOME/code

# please make sure the ssh key has access to GitHub
git clone git@github.com:$githubOrg/streaming-at-scale.git
cd streaming-at-scale
git remote add sas git@github.com:Azure-Samples/streaming-at-scale.git
git checkout eh-flink
ls -als
git status
git remote -v
