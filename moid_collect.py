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

moid_lookup = {}
atexit.register(connect.Disconnect, svc_instance)
content = svc_instance.RetrieveContent()
objview = content.viewManager.CreateContainerView(content.rootFolder, [vim.ClusterComputeResource], True)
clusters = objview.view
objview.Destroy()

for cluster in clusters:
    moid_lookup[cluster.name] = cluster._moId

pprint(moid_lookup)

objview = content.viewManager.CreateContainerView(content.rootFolder, [vim.Datastore], True)
datastores = objview.view

for datastore in datastores:
    moid_lookup[datastore.name] = datastore._GetMoId()

objview = content.viewManager.CreateContainerView(content.rootFolder, [vim.Network], True)
networks = objview.view

for network in networks:
    moid_lookup[network.name] = network._moId

pprint(moid_lookup)