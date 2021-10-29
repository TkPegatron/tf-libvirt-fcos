# Terraform CoreOS KVM

Provision Fedora CoreOS virtual machines using libvirt.

## Requirements

- [Terraform](https://www.terraform.io/) >= v1.0.0
- [Libvirt hypervisor](https://www.linux-kvm.org/)
- [Libvirt provider](https://github.com/dmacvicar/terraform-provider-libvirt)
- Internet connection on machine that will run VMs and on VMs

## Butane

This project comes with a [butane configuration file](./butane/fcos-generic.yaml) with the following parameters:

- The ansible user's password is set to `ChangeMe123`. You can generate a new password using `mkpasswd`.
- The timezone is set to `America/Detroit`.
- Installs Python on boot for Ansible.

[main.tf](./main.tf) will look first for a file in the format `${path.module}/butane/${each.value.name}.yaml`, if it isnt found it will fallback to the generic butane file included in this repository.

Documentation for butane is [here](https://coreos.github.io/butane/)

## Borrowed sources

I used the following projects to piece this together as I learn terraform.

- [AmpereComputing/terraform-openstack-images](https://github.com/AmpereComputing/terraform-openstack-images/blob/master/fedora/main.tf)
- [MusicDin/terraform-kvm-kubespray](https://github.com/MusicDin/terraform-kvm-kubespray)

## License

[Apache License 2.0](./LICENSE)
