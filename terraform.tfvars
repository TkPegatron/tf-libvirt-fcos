#base_image_source = "https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/34.20210919.3.0/x86_64/fedora-coreos-34.20210919.3.0-qemu.x86_64.qcow2.xz"
base_image = "/var/lib/libvirt/images/fedora-coreos-34.20210919.3.0-qemu.x86_64.qcow2"
machines   = ["x86-master-a","x86-node-0","x86-node-1"]
