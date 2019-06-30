# vsphere-nsxt-pks-build
Automated build of nest vSphere, NSX-T and PKS

# Goals
Build a lab in 1 shot, with all modifyable configuration stored in yaml.
Build vCenter and a single node ESXi to avoid having to do stared storage.
Build out NSX-T with a static route to another router in a repeatible way.

# Instructions
 - Update answer files to contain customization
 - Run build_vsphere.sh to build out infra
 - Run build_nsxt.sh to build out nsxt

 Known issues and todo items are listed in the bottom of the deployment YAMLs.

 
# TODO
- Generate principal ID
- Extract IDs for PKS Tile
- Test setup of resource pools
- Fix why ESXi wasn't auto deploying

- Replace machine cert in playbook