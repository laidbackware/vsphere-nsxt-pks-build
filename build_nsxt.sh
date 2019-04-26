#!/bin/bash

set -e # fail fast
set -x # print commands

#git clone https://github.com/laidbackware/ansible-for-nsxt.git

python moid_collect.py

rm ./ansible-for-nsxt/*yml

cp nsxt_answerfile*.yml ./ansible-for-nsxt/
cp nsxt_deploy*.yml ./ansible-for-nsxt/

cd ansible-for-nsxt
#sudo ansible-playbook nsxt_deploy_base.yml -vvv
#sudo ansible-playbook nsxt_deploy_switching_routing.yml -vvv
#sudo ansible-playbook nsxt_deploy_fragile.yml -vvv