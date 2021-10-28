terraform {
  required_version = ">= 1.0.0"
  experiments = [module_variable_optional_attrs]
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.11"
    }
    template = {
      source = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }
}
