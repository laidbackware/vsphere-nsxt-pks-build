#!/bin/bash

set -e # fail fast
set -x # print commands

git clone https://github.com/laidbackware/vsphere-lab-deploy.git

cd vsphere-lab-deploy
git checkout optimize_build

rm ./*yml

cp ../vsphere-answerfile.yml ./answerfile.yml
cp ../vsphere-deploy.yml .
ansible-playbook vsphere-deploy.yml

cd ..
