#!/bin/bash

set -e # fail fast
set -x # print commands

git clone https://github.com/laidbackware/vsphere-lab-deploy.git

rm ./vsphere-lab-deploy/*yml

cp vsphere-answerfile.yml ./vsphere-lab-deploy/answerfile.yml
cp vsphere-deploy.yml ./vsphere-lab-deploy/

cd vsphere-lab-deploy
sudo ansible-playbook vsphere-deploy.yml -vvv

cd ..
