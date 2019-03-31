#!/bin/bash

set -e # fail fast
set -x # print commands

git clone https://github.com/laidbackware/ansible-for-nsxt.git

python moid_collect.py

cp ./ansible-for-nsxt/nsxt_route_advertise.py .

cd ansible-for-nsxt
git checkout v1.0.0

cd ..

cp nsxt_route_advertise.py ./ansible-for-nsxt/

rm ./ansible-for-nsxt/*yml

cp nsxt_answerfile*.yml ./ansible-for-nsxt/
cp nsxt_deploy*.yml ./ansible-for-nsxt/

cd ansible-for-nsxt


#sudo ansible-playbook nsxt_deploy_base-2.3.yml -vvv
## Break point. You must configure the transport node on the hosts.
#sudo ansible-playbook nsxt_deploy_switching_routing.yml -vvv
#sudo ansible-playbook nsxt_deploy_fragile.yml -vvv