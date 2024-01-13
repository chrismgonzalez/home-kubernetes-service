proxmox_storage      = "VMs" # the name of your node storage
proxmox_storage_type = "VMs" # its type (lvm, lvm-thin, zfs, directory, etc)
talos_version        = "v1.6.0"
static_ip            = "10.1.1.30/24" # static ip for vm to ssh
gateway              = "10.1.1.1" # gateway for vm to ssh