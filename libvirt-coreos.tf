# -[Provider]--------------------------------------------------------------
provider "libvirt" {
    uri = "${var.qemu_uri}"
}

# -[Template]--------------------------------------------------------------
data "ct_config" "vm-ignitions" {
  for_each = toset(var.machines)
  content  = data.template_file.vm-configs[each.key].rendered
}

data "template_file" "vm-configs" {
  for_each = toset(var.machines)
  template = try(
    file("${path.module}/ignition-${each.key}.yaml"),
    file("${path.module}/${each.key}.yaml"),
    file("${path.module}/${each.key}.ign.yaml"),
    file("${path.module}/ignition-generic.yaml")
  )

  vars = {
    hostname = "${each.key}.${var.tld}"
  }
}

# -[Resources]-------------------------------------------------------------
resource "libvirt_ignition" "ignition" {
  for_each = toset(var.machines)
  name     = "${each.key}-ignition"
  pool     = "default"
  content  = data.ct_config.vm-ignitions[each.key].rendered
}

resource "libvirt_volume" "base" {
  name   = "fcos-${md5(var.base_image)}.qcow2"
  source = var.base_image
  pool   = "default"
  format = "qcow2"
}

resource "libvirt_volume" "disk0" {
  for_each = toset(var.machines)
  # workaround: depend on libvirt_ignition.ignition[each.key], otherwise the VM will use the old disk when the user-data changes
  name           = "${each.key}-${md5(libvirt_ignition.ignition[each.key].id)}.qcow2"
  base_volume_id = libvirt_volume.base.id
  pool           = "default"
  format         = "qcow2"
}

resource "libvirt_domain" "machine" {
  for_each = toset(var.machines)
  name     = "${each.key}"
  vcpu     = var.virtual_cpus
  memory   = var.virtual_memory

  fw_cfg_name     = "opt/com.coreos/config"
  coreos_ignition = libvirt_ignition.ignition[each.key].id

  disk {
    volume_id = libvirt_volume.disk0[each.key].id
  }

  graphics {
    listen_type = "address"
  }

  # Make tty0 available via `virsh console`
  console {
    type        = "pty"
    target_port = "0"
  }

  # dynamic IP assignment on the bridge, NAT for Internet access
  network_interface {
    network_name   = "default"
    wait_for_lease = true
  }
}
