#======================================================================================
# General configuration
#======================================================================================

# Provider's URI #
libvirt_provider_uri = "qemu:///system"

# Resource pool name #
libvirt_resource_pool_name = "k8s-resource-pool"

# Location where resource pool will be initialized (Path must contain "/" at the end) #
libvirt_resource_pool_location = "/var/lib/libvirt/pools/"


#======================================================================================
# Global VM configuration
#======================================================================================

fcos_version = "34.20211004.3.1"


#======================================================================================
# Network configuration
#======================================================================================

# Network name #
network_name = "k8s-network"

# Network FQDN #

# Network mode (nat, route) #
network_mode = "nat"

# Network (virtual) bridge #
network_bridge = "virbr1"

# Network CIDR (example: 192.168.113.0/24) #
network_cidr = "192.168.113.0/24"

#======================================================================================
# Node VM parameters
#======================================================================================

# The default number of vCPU allocated to the VM #
default_cpu = 2

# The default amount of RAM allocated to the VM (in Megabytes - MB) #
default_ram = 2048

# The default amount of disk allocated to the VM (in Bytes - B) #
default_storage = 16106127360

# Nodes configuration #
coreos_nodes = [
  {
    name  = "x86-server-a"
    ip  = "192.168.113.10"
  },
  {
    name  = "x86-worker-0"
    ip  = "192.168.113.11"
  },
  {
    name  = "x86-worker-1"
    ip  = "192.168.113.12"
  },
  {
    name  = "x86-worker-2"
    ip  = "192.168.113.13"
  }
]
