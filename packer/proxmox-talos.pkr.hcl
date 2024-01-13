packer {
  required_plugins {
    proxmox = {
      version = ">= 1.1.3"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox" "talos" {
  proxmox_url              = var.proxmox_url
  username                 = var.proxmox_username
  token                    = var.proxmox_token
  node                     = var.proxmox_nodename
  insecure_skip_tls_verify = true

   iso_file = "local:iso/archlinux-2024.01.01-x86_64.iso"
  # iso_url          = "https://ord.mirror.rackspace.com/archlinux/iso/2024.01.01/archlinux-2024.01.01-x86_64.iso"
  # iso_checksum     = "sha1:8c44fb93f76309f20ad6a0a025c079c3d4c99bb2"
  # iso_storage_pool = "local"
  unmount_iso = true

  scsi_controller = "virtio-scsi-pci"
  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
    firewall = false
  }
  disks {
    type              = "scsi"
    storage_pool      = var.proxmox_storage
    storage_pool_type = var.proxmox_storage_type
    format            = "raw"
    disk_size         = "1500M"
    cache_mode        = "writethrough"
  }

  memory       = 2048
  ssh_username = "root"
  ssh_password = "packer"
  ssh_timeout  = "15m"
  qemu_agent   = true

  template_name        = "talos"
  template_description = "Talos system disk, version ${var.talos_version}"

  boot_wait = "10s"
  boot_command = [
    "<enter><wait1m>",
    "passwd<enter><wait>packer<enter><wait>packer<enter>",
    "ip address add ${var.static_ip} broadcast + dev ens18<enter><wait>",
    "ip route add 0.0.0.0/0 via ${var.gateway} dev ens18<enter><wait>"
  ]
}

build {
  name    = "release"
  sources = ["source.proxmox.talos"]

  provisioner "shell" {
    inline = [
      "curl -L ${local.image} -o /tmp/talos.raw.xz",
      "xz -d -c /tmp/talos.raw.xz | dd of=/dev/sda && sync",
    ]
  }
}

build {
  name    = "develop"
  sources = ["source.proxmox.talos"]

  provisioner "file" {
    source      = "../../../talos/_out/nocloud-amd64.raw.xz"
    destination = "/tmp/talos.raw.xz"
  }
  provisioner "shell" {
    inline = [
      "xz -d -c /tmp/talos.raw.xz | dd of=/dev/sda && sync",
    ]
  }
}