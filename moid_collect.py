from pyVim import connect
from pyVmomi import vim
import sys, ssl, atexit, yaml
from pprint import pprint

with open("vsphere-answerfile.yml", 'r') as f:
    vsphere_data = yaml.load(f)
 
vc_fqdn = vsphere_data['vcenter']['ip']
vc_user = vsphere_data['vcenter']['user']
vc_pass = vsphere_data['vcenter']['password']
debug = False

if debug: print('Start VC collect')
vc_ds_dict = {}

ssl_context = ssl.SSLContext(ssl.PROTOCOL_SSLv23)
ssl_context.verify_mode = ssl.CERT_NONE
try:
    svc_instance = connect.SmartConnect(host=vc_fqdn, user=vc_user, pwd=vc_pass, port=443,
                                        sslContext=ssl_context)
    print('vCenter Login Success!')
except Exception as e:
    print(e)

cluster_moid_lookup = {}
datastore_moid_lookup = {}
network_moid_lookup = {}

atexit.register(connect.Disconnect, svc_instance)
content = svc_instance.RetrieveContent()
objview = content.viewManager.CreateContainerView(content.rootFolder, [vim.ClusterComputeResource], True)
clusters = objview.view
objview.Destroy()

for cluster in clusters:
    cluster_moid_lookup[cluster.name] = cluster._moId

pprint(cluster_moid_lookup)

objview = content.viewManager.CreateContainerView(content.rootFolder, [vim.Datastore], True)
datastores = objview.view

for datastore in datastores:
    datastore_moid_lookup[datastore.name] = datastore._GetMoId()

pprint(datastore_moid_lookup)

objview = content.viewManager.CreateContainerView(content.rootFolder, [vim.Network], True)
networks = objview.view

for network in networks:
    network_moid_lookup[network.name] = network._moId

pprint(network_moid_lookup)

with open("nsxt_answerfile_base.yml", 'r') as f:
    nsxt_data = yaml.load(f)



#print(network_moid_lookup['Net1'])
moids = {}
moids['network_management_id'] = network_moid_lookup[nsxt_data['network_management_name']]
moids['network_tep_id'] = network_moid_lookup[nsxt_data['network_tep_name']]
moids['datastore_id'] = datastore_moid_lookup[nsxt_data['datastore_name']]
moids['cluster_id'] = cluster_moid_lookup[nsxt_data['cluster_name']]

import sys
import fileinput

for line in fileinput.input(["nsxt_answerfile_base.yml"], inplace=True):
    for key, value in moids.items():
        if line.strip().startswith(key):
            line = '%s: "%s"\n' % (key, value)
    sys.stdout.write(line)

# with open("nsxt_answerfile_base-t.yml", 'w') as f:
#     yaml.dump(nsxt_data, f, default_flow_style=False)
