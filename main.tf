# -[Provider]--------------------------------------------------------------
provider "libvirt" {
  uri = var.libvirt_provider_uri
}

# -[Resources]--------------------------------------------------------------
#-[Create resource pool for VM volumes]-#
resource "libvirt_pool" "resource_pool" {
  name = var.libvirt_resource_pool_name
  type = "dir"
  path = "${var.libvirt_resource_pool_location}${var.libvirt_resource_pool_name}"
}

resource "null_resource" "download_extract_coreos_image" {
  count = 1
  provisioner "local-exec" {
    interpreter = ["bash"]
    command     = "${path.module}/scripts/fedora_coreos_image.sh"
    environment = {
      PROJECT_DIR  = path.module
      FCOS_VERSION = var.fcos_version
     }
  }
}
#-[Create base OS image for nodes]-#
resource "libvirt_volume" "base_volume" {
  name       = "fcos-baseimage-${var.fcos_version}.x86_64.qcow2"
  pool       = var.libvirt_resource_pool_name
  source     = pathexpand("${path.module}/.terraform/image_cache/fedora-coreos-${var.fcos_version}-qemu.x86_64.qcow2")
  depends_on = [
    libvirt_pool.resource_pool,
    null_resource.download_extract_coreos_image
  ]
}

# -[Modules]--------------------------------------------------------------
#-[Creates network]-#
module "network_module" {
  source = "./modules/network/"

  network_name   = var.network_name
  network_mode   = var.network_mode
  network_bridge = var.network_bridge
  network_cidr   = var.network_cidr
}
#-[Create VM Domain]-#
module "coreos_module" {
  source = "./modules/fcos_vm"

  for_each = { for node in var.coreos_nodes : node.name => node }

  #-[Variables from general resources]-#
  libvirt_provider_uri = var.libvirt_provider_uri
  resource_pool_name   = libvirt_pool.resource_pool.name
  base_volume_id       = libvirt_volume.base_volume.id
  network_id           = module.network_module.network_id

  #-[Butane Template for Poseidon]-#
  vm_butane = templatefile(
    (
      fileexists("${path.module}/butane/${each.value.name}.yaml")
      ? "${path.module}/butane/${each.value.name}.yaml"
      : "${path.module}/butane/fcos-generic.yaml"
    ),
    { # Template_file variables
      hostname = "${each.value.name}.${var.vm_tld}"
    }
  )

  #-[Master node specific variables]-#
  vm_name            = each.value.name
  vm_mac             = each.value.mac
  vm_ip              = each.value.ip
  vm_cpu             = each.value.cpu != null ? each.value.cpu : var.default_cpu
  vm_ram             = each.value.ram != null ? each.value.ram : var.default_ram
  vm_storage         = each.value.storage != null ? each.value.storage : var.default_storage

  # Dependancy takes care that resource pool is not removed before volumes are #
  # Also network must be created before VM is initialized #
  depends_on = [
    module.network_module,
    libvirt_pool.resource_pool,
    libvirt_volume.base_volume
  ]
}

output "vm_info" {
  value = {
    for node in var.coreos_nodes :
    "${node.name}" => module.coreos_module[node.name].vm_info
  }
}
