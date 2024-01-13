variable "proxmox_ssh_password" {
  description = "ssh password"
  type = string
  sensitive = true
}

variable "proxmox_domain" {
  description = "Proxmox host"
  type        = string
  default     = "gonzonet.live"
}

variable "proxmox_host" {
  description = "Proxmox host"
  type        = string
  default     = "pve-hulk.gonzonet.live"
}

variable "proxmox_nodename" {
  description = "Proxmox node name"
  type        = string
  default = "pve-hulk"
}

variable "proxmox_image" {
  description = "Proxmox source image name"
  type        = string
  default     = "talos"
}

variable "proxmox_storage" {
  description = "Proxmox storage name"
  type        = string
  default = "tank-1"
}

variable "proxmox_token_id" {
  description = "Proxmox token id"
  type        = string
}

variable "proxmox_token_secret" {
  description = "Proxmox token secret"
  type        = string
}

variable "region" {
  description = "Proxmox Cluster Name"
  type        = string
  default     = "cluster-1"
}

variable "kubernetes" {
  type = map(string)
  default = {
    podSubnets     = "10.244.0.0/16"
    serviceSubnets = "10.96.0.0/12"
    domain         = "cluster.local"
    apiDomain      = "api.cluster.local"
    clusterName    = "talos-1"
    tokenMachine   = ""
    caMachine      = ""
    token          = ""
    ca             = ""
  }
  sensitive = true
}

variable "network_shift" {
  description = "Network number shift"
  type        = number
  default     = 6
}

variable "vpc_main_cidr" {
  description = "Local proxmox subnet"
  type        = string
  default     = "10.10.10.0/24"
}

variable "controlplane" {
  description = "Property of controlplane"
  type        = map(any)
  default = {
    "pve-hulk" = {
      id    = 500
      count = 2,
      cpu   = 2,
      mem   = 4096,
      # ip0   = "ip6=1:2::3/64,gw6=1:2::1"
    },
    "node2" = {
      id    = 510
      count = 0,
      cpu   = 2,
      mem   = 4096,
      # ip0   = "ip6=dhcp",
    }
  }
}

variable "instances" {
  description = "Map of VMs launched on proxmox hosts"
  type        = map(any)
  default = {
    "all" = {
      version = "v1.27.0"
    },
    "pve-hulk" = {
      web_id       = 1000
      web_count    = 0,
      web_cpu      = 2,
      web_mem      = 4096,
      web_ip0      = "", # ip=dhcp,ip6=dhcp
      worker_id    = 1050
      worker_count = 0,
      worker_cpu   = 2,
      worker_mem   = 4096,
      worker_ip0   = "", # ip=dhcp,ip6=dhcp
    },
    "node2" = {
      web_id       = 2000
      web_count    = 0,
      web_cpu      = 2,
      web_mem      = 4096,
      worker_id    = 2050
      worker_count = 0,
      worker_cpu   = 2,
      worker_mem   = 4096,
    }
    "node3" = {
      web_id       = 3000
      web_count    = 0,
      web_cpu      = 2,
      web_mem      = 4096,
      worker_id    = 3050
      worker_count = 0,
      worker_cpu   = 2,
      worker_mem   = 4096,
    }
  }
}