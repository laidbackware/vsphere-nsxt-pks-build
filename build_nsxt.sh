#!/bin/bash

set -e # fail fast
set -x # print commands

date

if [ ! -d "ansible-for-nsxt/" ]; 
then 
  git clone https://github.com/laidbackware/ansible-for-nsxt.git
  sed -i 's/time.sleep(5)/time.sleep(0.5)/g' ./ansible-for-nsxt/library/* # Reduce mandatory sleep between commands
fi

#TODO refactor to remove need for script
python moid_collect.py

export ANSIBLE_LIBRARY="${PWD}/ansible-for-nsxt"
export ANSIBLE_MODULE_UTILS="${PWD}/ansible-for-nsxt/module_utils"

ansible-playbook nsxt_deploy_base.yml -vvv 
ansible-playbook nsxt_deploy_switching_routing.yml -vvv
ansible-playbook nsxt_deploy_fragile.yml -vvv
ansible-playbook nsxt_deploy_firewalling.yml -vvv

date
