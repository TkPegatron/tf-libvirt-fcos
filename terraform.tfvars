#=======================================#
#---[ General configuration ]-----------#
#=======================================#

#-[Provider's URI]-#
libvirt_provider_uri = "qemu:///system"

#-[Resource pool name]-#
libvirt_resource_pool_name = "example-resource-pool"

#-[Location where resource pool will be initialized (Path must contain "/" at the end)]-#
libvirt_resource_pool_location = "/var/lib/libvirt/pools/"

#=======================================#
#---[ Network configuration ]-----------#
#=======================================#

#-[Network name]-#
network_name = "terraform"

#-[Network mode (nat, route)]-#
network_mode = "nat"

#-[Network (virtual) bridge]-#
network_bridge = "virbr1"

#-[Network CIDR (example: 192.168.113.0/24)]-#
network_cidr = "192.168.113.0/24"

#-[Network DNS Zone]-#
network_zone = "terraform.lan"

#=======================================#
#---[ VM parameters ]-------------------#
#=======================================#

#-[The version of CoreOS to run]-#
fcos_version = "34.20211004.3.1"

#-[The default number of vCPU allocated to the VM]-#
default_cpu = 2

#-[The default amount of RAM allocated to the VM (in Megabytes - MB)]-#
default_ram = 2048

#-[The default amount of disk allocated to the VM (in Bytes - B)]-#
default_storage = 16106127360

#-[Nodes configuration]-#
coreos_nodes = [
  {
    name = "example-node"
    ip   = "192.168.113.5"
  }
]
