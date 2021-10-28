terraform {
  required_version = ">= 1.0.0"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.11"
    }
    ct = {
      source = "poseidon/ct"
      version = "~> 0.9.1"
    }
  }
}
