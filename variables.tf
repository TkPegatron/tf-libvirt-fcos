#======================================================================================
# General configuration
#======================================================================================

variable "action" {
  type        = string
  description = "Which action has to be done on the cluster (create, upgrade, add_worker, or remove_worker)"
  default     = "create"

  validation {
    condition     = contains(["create", "upgrade", "add_worker", "remove_worker"], var.action)
    error_message = "Variable 'action' is invalid.\nDefault value is \"create\".\nPossible values are: [\"create\", \"upgrade\", \"add_worker\", \"remove_worker\"]."
  }
}

variable "libvirt_provider_uri" {
  type        = string
  description = "Libvirt provider's URI"
  default     = "qemu:///system"
}

variable "libvirt_resource_pool_name" {
  type        = string
  description = "The libvirt resource pool name"
}

variable "libvirt_resource_pool_location" {
  type        = string
  description = "Location where resource pool will be initialized"
  default     = "/var/lib/libvirt/pools/"
}

#======================================================================================
# Global VM configuration
#======================================================================================

variable "fcos_version" {
  type = string
  description = "FCOS image version"
}

variable "vm_tld" {
  type = string
  default = "example.com"
  description = "Top level domain name to assign to the host"
}

#======================================================================================
# Network configuration
#======================================================================================

variable "network_name" {
  type        = string
  description = "Network name"
  default     = "terraform-network"
}

variable "network_mode" {
  type        = string
  description = "Network mode"
  default     = "nat"

  validation {
    condition     = contains(["nat", "route"], var.network_mode)
    error_message = "Variable 'network_mode' is invalid.\nPossible values are: [\"nat\", \"route\"]."
  }
}

variable "network_bridge" {
  type        = string
  description = "Network (virtual) bridge"
  default     = null
}

variable "network_cidr" {
  type        = string
  description = "Network CIDR"
}

#======================================================================================
# Node parameters
#======================================================================================

variable "default_cpu" {
  type        = number
  description = "The default number of vCPU allocated to the master node"
  default     = 1
}

variable "default_ram" {
  type        = number
  description = "The default amount of RAM allocated to the master node"
  default     = 4096
}

variable "default_storage" {
  type        = number
  description = "The default amount of disk (in Bytes) allocated to the master node. Default: 15GB"
  default     = 16106127360
}

variable "coreos_nodes" {
  type = list(object({
    name    = string
    mac     = optional(string)
    ip      = optional(string)
    cpu     = optional(number)
    ram     = optional(number)
    storage = optional(number)
  }))
  description = "Node configurations"

  validation {
    condition = (
      compact(tolist([for node in var.coreos_nodes : node.name])) == distinct(compact(tolist([for node in var.coreos_nodes : node.name])))
      && compact(tolist([for node in var.coreos_nodes : node.mac])) == distinct(compact(tolist([for node in var.coreos_nodes : node.mac])))
      && compact(tolist([for node in var.coreos_nodes : node.ip])) == distinct(compact(tolist([for node in var.coreos_nodes : node.ip])))
    )
    error_message = "Node configuration is incorrect. Make sure that: \n - every ID is unique,\n - every MAC and IP address is unique or null."
  }
}
