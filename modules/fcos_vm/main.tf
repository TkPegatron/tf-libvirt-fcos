# -[Resources]-------------------------------------------------------------
data "ct_config" "vm_ignition" {
  content  = var.vm_butane
}
resource "libvirt_ignition" "ignition" {
  name     = "${var.vm_name}.ign"
  pool     = var.resource_pool_name
  content  = data.ct_config.vm_ignition.rendered
}

# -[Create Volume]--------------------
resource "libvirt_volume" "vm_volume" {
  name           = "${var.vm_name}.ign-${md5(libvirt_ignition.ignition.id)}.qcow2"
  pool           = var.resource_pool_name
  base_volume_id = var.base_volume_id
  size           = var.vm_storage
  format         = "qcow2"
}
# -[Create Libvirt Domain]-----------
resource "libvirt_domain" "vm_domain" {
  #-[General configuration]-#
  name      = var.vm_name
  vcpu      = var.vm_cpu
  memory    = var.vm_ram
  autostart = true
  #-[CoreOS Ignition]-#
  fw_cfg_name     = "opt/com.coreos/config"
  coreos_ignition = libvirt_ignition.ignition.id
  #-[Storage configuration]-#
  disk {
    volume_id = libvirt_volume.vm_volume.id
  }
  #-[Network configuration]-#
  network_interface {
    network_id     = var.network_id
    mac            = var.vm_mac
    addresses      = var.vm_ip == null ? null : [var.vm_ip]
    wait_for_lease = true
  }
  #-[Human Interfaces]-#
    console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }
  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }
  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}
# -[Resource Destruction]-------------------------------------------------------------
#-[Remove static IP address from network after destruction]-#
resource "null_resource" "remove_static_ip" {

  triggers = {
    libvirt_provider_uri = var.libvirt_provider_uri
    network_id           = libvirt_domain.vm_domain.network_interface.0.network_id
    vm_mac               = libvirt_domain.vm_domain.network_interface.0.mac
    vm_ip                = libvirt_domain.vm_domain.network_interface.0.addresses.0
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOF
              virsh \
              --connect $URI \
              net-update $NETWORK_ID \
              delete ip-dhcp-host "<host mac='$VM_MAC' ip='$VM_IP'/>" \
              --live \
              --config \
              --parent-index 0
              EOF

    environment = {
      URI        = self.triggers.libvirt_provider_uri
      NETWORK_ID = self.triggers.network_id
      VM_MAC     = self.triggers.vm_mac
      VM_IP      = self.triggers.vm_ip
    }

    on_failure = continue
  }
}
