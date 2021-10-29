#=======================================#
#---[ General configuration ]-----------#
#=======================================#

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

#=======================================#
#---[ Network configuration ]-----------#
#=======================================#

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

variable "network_zone" {
  type = string
  default = "terraform.lan"
  description = "DNS Zone name to assign to the host"
}

#=======================================#
#---[ VM parameters ]-------------------#
#=======================================#

variable "fcos_version" {
  type = string
  description = "The version of CoreOS to run"
}

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
  description = "Node configuration objectss"

  validation {
    condition = (
      compact(tolist([for node in var.coreos_nodes : node.name])) == distinct(compact(tolist([for node in var.coreos_nodes : node.name])))
      && compact(tolist([for node in var.coreos_nodes : node.mac if can(node.mac)])) == distinct(compact(tolist([for node in var.coreos_nodes : node.mac if can(node.mac)])))
      && compact(tolist([for node in var.coreos_nodes : node.ip if can(node.ip)])) == distinct(compact(tolist([for node in var.coreos_nodes : node.ip if can(node.ip)])))
    )
    error_message = "Node configuration is incorrect. Make sure that: \n - every ID is unique,\n - every MAC and IP address is unique or null."
  }
}
