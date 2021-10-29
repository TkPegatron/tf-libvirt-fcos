terraform {
  required_version = "1.0.10"
  experiments = [module_variable_optional_attrs]
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.11"
    }
  }
}
