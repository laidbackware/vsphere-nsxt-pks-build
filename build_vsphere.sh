#!/bin/bash

set -e # fail fast
set -x # print commands

# Check if running as sudo
if [[ $EUID > 0 ]]; then
  echo "Please run as sudo/root"
  exit 1
fi

date

git clone https://github.com/laidbackware/vsphere-lab-deploy.git --branch=optimize_build

cd vsphere-lab-deploy

rm ./*yml

cp ../vsphere-answerfile.yml ./answerfile.yml
cp ../vsphere-deploy.yml .
ansible-playbook vsphere-deploy.yml

date
