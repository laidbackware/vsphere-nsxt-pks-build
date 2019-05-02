#!/bin/bash

set -e # fail fast
set -x # print commands

# Check if running as sudo
if [[ $EUID > 0 ]]; then 
  echo "Please run as sudo/root"
  exit 1
fi

date

if [ -d "ansible-for-nsxt/" ]; then rm -rf ansible-for-nsxt/; fi

git clone https://github.com/laidbackware/ansible-for-nsxt.git --branch stable-2.4

python moid_collect.py

rm ./ansible-for-nsxt/*yml

cp nsxt_answerfile*.yml ./ansible-for-nsxt/
cp nsxt_deploy*.yml ./ansible-for-nsxt/

cd ansible-for-nsxt
sed -i 's/time.sleep(5)/time.sleep(0.5)/g' ./library/* # Reduce mandatory sleep between commands
ansible-playbook nsxt_deploy_base.yml 
ansible-playbook nsxt_deploy_switching_routing.yml
ansible-playbook nsxt_deploy_fragile.yml

date
