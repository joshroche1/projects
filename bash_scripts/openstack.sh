#!/bin/bash

### OPENSTACK 2024.2
# Tested on Raspberry Pi 5B 8GB

admin-openrc:
export OS_USERNAME=admin
export OS_PASSWORD=openstack
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://192.168.2.220:5000/v3
export OS_IDENTITY_API_VERSION=3
...
###
# INSTALLATION STEPS
###
apt install chrony
/etc/chrony/chrony.conf:
server 0.de.pool.ntp.org
server 1.de.pool.ntp.org
server 2.de.pool.ntp.org
server 3.de.pool.ntp.org
allow 192.168.2.0/24
...
apt install python3-openstackclient
apt install mariadb-server python3-pymysql
/etc/mysql/mariadb.conf.d/99-openstack.cnf:
[mysqld]
bind-address = $MGMT_IPADDR
#
default-storage-engine = innodb
innodb_file_per_table = on
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
...
service mysql restart
mysql_secure_installation
apt install rabbitmq-server
rabbitmqctl add_user openstack $RABBIT_PASS
rabbitmqctl set_permissions openstack ".*" ".*" ".*"
apt install memcached python3-memcache
/etc/memcached.conf:
-l 192.168.2.220
...
service memcached restart
apt install etcd-server
/etc/default/etcd:
ETCD_NAME="controller"
ETCD_DATA_DIR="/var/lib/etcd"
ETCD_INITIAL_CLUSTER_STATE="new"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster-01"
ETCD_INITIAL_CLUSTER="controller=http://192.168.2.220:2380"
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://192.168.2.220:2380"
ETCD_ADVERTISE_CLIENT_URLS="http://192.168.2.220:2379"
ETCD_LISTEN_PEER_URLS="http://0.0.0.0:2380"
ETCD_LISTEN_CLIENT_URLS="http://192.168.2.220:2379"
...
systemctl enable etcd
systemctl restart etcd
#
mysql
CREATE DATABASE keystone; nova nova_api nova_cell0 glance neutron placement
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'keystone';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'keystone';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'nova';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'nova';
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY 'nova';
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY 'nova';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' IDENTIFIED BY 'nova';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' IDENTIFIED BY 'nova';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'glance';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'glance';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'neutron';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'neutron';
GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'localhost' IDENTIFIED BY 'placement';
GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'%' IDENTIFIED BY 'placement';
#
apt install keystone
/etc/keystone/keystone.conf:
[database]
connection = mysql+pymysql://keystone:KEYSTONE_DBPASS@controller/keystone
...
[token]
provider = fernet
...
su -s /bin/sh -c "keystone-manage db_sync" keystone
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
keystone-manage bootstrap --bootstrap-password $ADMIN_PASS \
  --bootstrap-admin-url http://controller:5000/v3/ \
  --bootstrap-internal-url http://controller:5000/v3/ \
  --bootstrap-public-url http://controller:5000/v3/ \
  --bootstrap-region-id RegionOne
/etc/apache2/apache2.conf:
ServerName controller
service apache2 restart
#
. admin-openrc
openstack project create --domain default --description "Service Project" service
openstack project create --domain default --description "Demo Project" myproject
openstack user create --domain default --password-prompt myuser
openstack role create myrole
openstack role add --project myproject --user myuser myrole
demo-openrc:
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=myproject
export OS_USERNAME=myuser
export OS_PASSWORD=openstack
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
...
openstack token issue
# glance
openstack user create --domain default --password-prompt glance
openstack role add --project service --user glance admin
openstack service create --name glance --description "OpenStack Image" image
openstack endpoint create --region RegionOne image public http://controller:9292
openstack endpoint create --region RegionOne image internal http://controller:9292
openstack endpoint create --region RegionOne image admin http://controller:9292
openstack --os-cloud devstack-system-admin registered limit create --service glance --default-limit 1000 --region RegionOne image_size_total
openstack --os-cloud devstack-system-admin registered limit create --service glance --default-limit 1000 --region RegionOne image_stage_total
openstack --os-cloud devstack-system-admin registered limit create --service glance --default-limit 100 --region RegionOne image_count_total
openstack --os-cloud devstack-system-admin registered limit create --service glance --default-limit 100 --region RegionOne image_count_uploading
#
apt install glance
/etc/glance/glance-api.conf:
[database]
connection = mysql+pymysql://glance:glance@controller/glance
[keystone_authtoken]
www_authenticate_uri  = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = glance
password = glance
[paste_deploy]
flavor = keystone
[DEFAULT]
enabled_backends=fs:file
[glance_store]
default_backend = fs
[fs]
filesystem_store_datadir = /var/lib/glance/images/
[oslo_limit]
auth_url = http://controller:5000
auth_type = password
user_domain_id = default
username = glance
system_scope = all
password = glance
endpoint_id = 03894d94be0d4c5291aad21d619b4ba7
region_name = RegionOne
...
openstack endpoint list --service glance --region RegionOne # to get ENDPOINT_ID
openstack role add --user glance --user-domain Default --system all reader
su -s /bin/sh -c "glance-manage db_sync" glance
service glance-api restart
# verify
wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img
glance image-create --name "cirros" --file cirros-0.4.0-x86_64-disk.img --disk-format qcow2 --container-format bare --visibility=public
glance image-list
# placement
openstack user create --domain default --password-prompt placement
openstack role add --project service --user placement admin
openstack service create --name placement --description "Placement API" placement
openstack endpoint create --region RegionOne placement public http://controller:8778
openstack endpoint create --region RegionOne placement internal http://controller:8778
openstack endpoint create --region RegionOne placement admin http://controller:8778
#
apt install placement-api
/etc/placement/placement.conf:
[placement_database]
# ...
connection = mysql+pymysql://placement:placement@controller/placement
[api]
# ...
auth_strategy = keystone
# ...
[keystone_authtoken]
# ...
auth_url = http://controller:5000/v3
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = placement
password = placement
#
su -s /bin/sh -c "placement-manage db sync" placement
service apache2 restart
#
placement-status upgrade check
# nova
openstack user create --domain default --password-prompt nova
openstack role add --project service --user nova admin
openstack service create --name nova --description "OpenStack Compute" compute
openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1
#
apt install nova-api nova-conductor nova-novncproxy nova-scheduler
/etc/nova/nova.conf:
[api_database]
# ...
connection = mysql+pymysql://nova:nova@controller/nova_api

[database]
# ...
connection = mysql+pymysql://nova:nova@controller/nova
[DEFAULT]
# ...
transport_url = rabbit://openstack:openstack@controller:5672/
[api]
# ...
auth_strategy = keystone

[keystone_authtoken]
# ...
www_authenticate_uri = http://controller:5000/
auth_url = http://controller:5000/
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = nova
password = nova

[service_user]
send_service_user_token = true
auth_url = https://controller/identity
auth_strategy = keystone
auth_type = password
project_domain_name = Default
project_name = service
user_domain_name = Default
username = nova
password = nova
[DEFAULT]
# ...
my_ip = 10.0.0.11
[vnc]
enabled = true
# ...
server_listen = $my_ip
server_proxyclient_address = $my_ip
[glance]
# ...
api_servers = http://controller:9292
[oslo_concurrency]
# ...
lock_path = /var/lib/nova/tmp
[placement]
# ...
region_name = RegionOne
project_domain_name = Default
project_name = service
auth_type = password
user_domain_name = Default
auth_url = http://controller:5000/v3
username = placement
password = placement
...
su -s /bin/sh -c "nova-manage api_db sync" nova
su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova
su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova
su -s /bin/sh -c "nova-manage db sync" nova
su -s /bin/sh -c "nova-manage cell_v2 list_cells" nova
service nova-api restart
service nova-scheduler restart
service nova-conductor restart
service nova-novncproxy restart
# compute node
apt install nova-compute
/etc/nova/nova.conf:
[DEFAULT]
# ...
transport_url = rabbit://openstack:RABBIT_PASS@controller
[api]
# ...
auth_strategy = keystone

[keystone_authtoken]
# ...
www_authenticate_uri = http://controller:5000/
auth_url = http://controller:5000/
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = nova
password = NOVA_PASS

[service_user]
send_service_user_token = true
auth_url = https://controller/identity
auth_strategy = keystone
auth_type = password
project_domain_name = Default
project_name = service
user_domain_name = Default
username = nova
password = NOVA_PASS
[DEFAULT]
# ...
my_ip = MANAGEMENT_INTERFACE_IP_ADDRESS
[vnc]
# ...
enabled = true
server_listen = 0.0.0.0
server_proxyclient_address = $my_ip
novncproxy_base_url = http://controller:6080/vnc_auto.html
[glance]
# ...
api_servers = http://controller:9292
[oslo_concurrency]
# ...
lock_path = /var/lib/nova/tmp
[placement]
# ...
region_name = RegionOne
project_domain_name = Default
project_name = service
auth_type = password
user_domain_name = Default
auth_url = http://controller:5000/v3
username = placement
password = PLACEMENT_PASS
...
egrep -c '(vmx|svm)' /proc/cpuinfo # IF 0, EDIT BELOW:
/etc/nova/nova-compute.conf:
[libvirt]
# ...
virt_type = qemu
...
service nova-compute restart
# ON CONTROLLER:
openstack compute service list --service nova-compute
su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova
# verify
openstack compute service list
openstack catalog list
openstack image list
nova-status upgrade check
# neutron
openstack user create --domain default --password-prompt neutron
openstack role add --project service --user neutron admin
openstack service create --name neutron --description "OpenStack Networking" network
openstack endpoint create --region RegionOne network public http://controller:9696
openstack endpoint create --region RegionOne network internal http://controller:9696
openstack endpoint create --region RegionOne network admin http://controller:9696
#
apt install neutron-server neutron-plugin-ml2 neutron-openvswitch-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent
/etc/neutron/neutron.conf:
[database]
# ...
connection = mysql+pymysql://neutron:neutron@controller/neutron
[DEFAULT]
# ...
core_plugin = ml2
service_plugins = router
[DEFAULT]
# ...
transport_url = rabbit://openstack:openstack@controller
[DEFAULT]
# ...
auth_strategy = keystone

[keystone_authtoken]
# ...
www_authenticate_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = neutron
password = neutron
[DEFAULT]
# ...
notify_nova_on_port_status_changes = true
notify_nova_on_port_data_changes = true

[nova]
# ...
auth_url = http://controller:5000
auth_type = password
project_domain_name = Default
user_domain_name = Default
region_name = RegionOne
project_name = service
username = nova
password = nova
[oslo_concurrency]
# ...
lock_path = /var/lib/neutron/tmp
...
/etc/neutron/plugins/ml2/ml2_conf.ini:
[ml2]
# ...
type_drivers = flat,vlan,vxlan
[ml2]
# ...
tenant_network_types = vxlan
[ml2]
# ...
mechanism_drivers = openvswitch,l2population
[ml2]
# ...
extension_drivers = port_security
[ml2_type_flat]
# ...
flat_networks = provider
[ml2_type_vxlan]
# ...
vni_ranges = 1:1000
...
/etc/neutron/plugins/ml2/openvswitch_agent.ini:
[ovs]
bridge_mappings = provider:extnet
local_ip = 192.168.2.220
# ovs-vsctl add-br $PROVIDER_BRIDGE_NAME
# ovs-vsctl add-port $PROVIDER_BRIDGE_NAME $PROVIDER_INTERFACE_NAME
[agent]
tunnel_types = vxlan
l2_population = true
[securitygroup]
# ...
enable_security_group = true
firewall_driver = openvswitch
#firewall_driver = iptables_hybrid
/etc/neutron/l3_agent.ini:
[DEFAULT]
# ...
interface_driver = openvswitch
...
/etc/neutron/dhcp_agent.ini:
[DEFAULT]
# ...
interface_driver = openvswitch
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
enable_isolated_metadata = true
...
/etc/neutron/metadata_agent.ini
[DEFAULT]
# ...
nova_metadata_host = controller
metadata_proxy_shared_secret = METADATA_SECRET
...
/etc/nova/nova.conf:
[neutron]
# ...
auth_url = http://controller:5000
auth_type = password
project_domain_name = Default
user_domain_name = Default
region_name = RegionOne
project_name = service
username = neutron
password = NEUTRON_PASS
service_metadata_proxy = true
metadata_proxy_shared_secret = METADATA_SECRET
...
su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
service nova-api restart
service neutron-server restart
service neutron-openvswitch-agent restart
service neutron-dhcp-agent restart
service neutron-metadata-agent restart
service neutron-l3-agent restart
#
neutron net-create external_network --provider:network_type flat --provider:physical_network extnet  --router:external
neutron subnet-create --name public_subnet --enable_dhcp=False --allocation-pool=start=192.168.2.50,end=192.168.2.99 --gateway=192.168.2.1 external_network 192.168.2.0/24
neutron router-create homelab_router
neutron router-gateway-set homelab_router external_network
neutron net-create homelab_network
neutron subnet-create --name homelab_subnet --gateway 192.168.100.1 --dns-nameserver 192.168.1.254 --dns-nameserver 8.8.8.8 --dns-nameserver 4.4.4.4  homelab_network 192.168.100.0/24
neutron router-interface-add homelab_router homelab_subnet

# COMPUTE NODE
apt install neutron-openvswitch-agent
/etc/neutron/neutron.conf:
[DEFAULT]
# ...
transport_url = rabbit://openstack:RABBIT_PASS@controller
[oslo_concurrency]
# ...
lock_path = /var/lib/neutron/tmp
...
/etc/neutron/plugins/ml2/openvswitch_agent.ini:
[ovs]
bridge_mappings = provider:PROVIDER_BRIDGE_NAME
local_ip = OVERLAY_INTERFACE_IP_ADDRESS
...
# ovs-vsctl add-br $PROVIDER_BRIDGE_NAME
# ovs-vsctl add-port $PROVIDER_BRIDGE_NAME $PROVIDER_INTERFACE_NAME
[agent]
tunnel_types = vxlan
l2_population = true
[securitygroup]
# ...
enable_security_group = true
firewall_driver = openvswitch
#firewall_driver = iptables_hybrid
/etc/nova/nova.conf:
[neutron]
# ...
auth_url = http://controller:5000
auth_type = password
project_domain_name = Default
user_domain_name = Default
region_name = RegionOne
project_name = service
username = neutron
password = NEUTRON_PASS
...
service nova-compute restart
service neutron-openvswitch-agent restart
# horizon
apt install openstack-dashboard
/etc/openstack-dashboard/local_settings.py:
OPENSTACK_HOST = "controller"
ALLOWED_HOSTS = ['one.example.com', 'two.example.com']
SESSION_ENGINE = 'django.contrib.sessions.backends.cache'

CACHES = {
    'default': {
         'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
         'LOCATION': 'controller:11211',
    }
}
OPENSTACK_KEYSTONE_URL = "http://%s/identity/v3" % OPENSTACK_HOST
OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True
OPENSTACK_API_VERSIONS = {
    "identity": 3,
    "image": 2,
    "volume": 3,
}
OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = "Default"
OPENSTACK_KEYSTONE_DEFAULT_ROLE = "user"
# provider networking option:
OPENSTACK_NEUTRON_NETWORK = {
    ...
    'enable_router': False,
    'enable_quotas': False,
    'enable_ipv6': False,
    'enable_distributed_router': False,
    'enable_ha_router': False,
    'enable_fip_topology_check': False,
}
#
/etc/apache2/conf-available/openstack-dashboard.conf:
WSGIApplicationGroup %{GLOBAL}
...
systemctl reload apache2.service
http://192.168.2.220/horizon/