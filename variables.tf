variable "qemu_uri" {
  type = string
  default = "qemu:///system"
  description = "The qemu/libvirt uri for the hypervisor"
}
variable "machines" {
  type        = list(string)
  description = "Machine names, corresponding to machine-NAME.yaml files"
}

variable "base_image" {
  type        = string
  description = "Path to Linux base image"
}

variable "virtual_memory" {
  type        = number
  default     = 2048
  description = "Virtual RAM in MB"
}

variable "virtual_cpus" {
  type        = number
  default     = 1
  description = "Number of virtual CPUs"
}

variable "tld" {
  type = string
  default = "example.com"
  description = "Top level domain name to assign to the host"
}
