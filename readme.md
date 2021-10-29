# Terraform CoreOS KVM

**Intended use case:** Provision Fedora CoreOS virtual machines using libvirt. Further configuring them utilizing Ansible.

## Requirements

- [Terraform](https://www.terraform.io/)
- [Libvirt hypervisor](https://www.linux-kvm.org/)
- [Libvirt provider](https://github.com/dmacvicar/terraform-provider-libvirt)
- Internet connection on machine that will run VMs and on VMs

## Variables

- `fcos_version`: Corresponds to the version in the url.
  - `https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/${FCOS_VERSION}/x86_64/fedora-coreos-${FCOS_VERSION}-qemu.x86_64.qcow2.xz`
  - This file will be downloaded and decompressed on the local machine and uploaded to the target hypervisor if it is not present.

## Butane

This project comes with a [butane configuration file](./butane/fcos-generic.yaml) with the following parameters:

- The ansible user's password is set to `ChangeMe123`. You can generate a new password using `mkpasswd`.
- The timezone is set to `America/Detroit`.
- Installs Python on boot for Ansible.

[main.tf](./main.tf) will look first for a file in the format `${path.module}/butane/${node.name}.yaml`, if it isnt found it will fallback to the generic butane file included in this repository.

The butane yaml will be passed through the terraform `templatefile` function and then handed off the the `fcos_vm` module's `poseidon/ct` resource to convert it to the ignition format.

Documentation for butane is [here](https://coreos.github.io/butane/)

## Borrowed sources

I used the following projects to piece this together as I learn terraform.

- [AmpereComputing/terraform-openstack-images](https://github.com/AmpereComputing/terraform-openstack-images/blob/master/fedora/main.tf)
- [MusicDin/terraform-kvm-kubespray](https://github.com/MusicDin/terraform-kvm-kubespray)

## License

[Apache License 2.0](./LICENSE)
