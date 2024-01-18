variable "kubernetes" {
  type = map(string)
  default = {
    hostname                = ""
    podSubnets              = "10.244.0.0/16"
    serviceSubnets          = "10.96.0.0/12"
    domain                  = "cluster.local"
    apiDomain               = ""
    ipv4_local              = ""
    ipv4_vip                = ""
    talos-version           = ""
    metallb_l2_addressrange = ""
    registry-endpoint       = ""
    identity                = ""
    identitypub             = ""
    knownhosts              = ""
    px_region               = ""
    px_node                 = ""
    sidero-endpoint         = ""
    storageclass            = ""
    storageclass-xfs        = ""
    cluster-0-vip           = ""
  }
}

variable "cluster_name" {
  description = "A name to provide for the Talos cluster"
  type        = string
  default     = "admin"
}

variable "region" {
  description = "A name to provide for the Talos cluster"
  type        = string
  default     = "cluster-1"
}

variable "pool" {
  description = "A name to provide for the Talos cluster"
  type        = string
  default     = "prod"
}

variable "cluster_endpoint" {
  description = "A name to provide for the Talos cluster"
  type        = string
  default     = "https://api.domain.local:6443"
}

variable "talos_version" {
  description = "A name to provide for the Talos cluster"
  type        = string
  default     = "v1.6.0"
}

variable "k8s_version" {
  description = "A name to provide for the Talos cluster"
  type        = string
  default     = "v1.29.0"
}

variable "proxmox_host" {
  description = "Proxmox host"
  type        = string
  # default     = "10.10.10.8"
}

variable "proxmox_image" {
  description = "Proxmox source image name"
  type        = string
  default     = "talos"
}

variable "proxmox_storage1" {
  description = "Proxmox storage name"
  type        = string
}

variable "proxmox_storage2" {
  description = "Proxmox storage name"
  type        = string
}

variable "proxmox_token_id" {
  description = "Proxmox token id"
  type        = string
}

variable "proxmox_token_secret" {
  description = "Proxmox token secret"
  type        = string
}

variable "proxmox_storage_token_secret" {
  description = "Proxmox token secret"
  type        = string
}

variable "proxmox_insecure" {
  description = "Proxmox insecure API auth"
  type = bool
  default = false
}

variable "first_ip" {
  type = string
}
variable "worker_first_ip" {
  type = string
}

variable "vpc_main_cidr" {
  description = "Local proxmox subnet"
  type        = string
  default     = "10.1.1.0/24"
}

variable "gateway" {
  type    = string
  default = "10.1.1.1"
}

variable "target_node_name" {
  description = "Proxmox node name"
  type        = string
}

variable "private_key_file_path" {
  type = string
}

variable "public_key_file_path" {
  type = string
}

variable "known_hosts" {
  type = string
}

variable "cloudflare_token" {
  type        = string
  description = "API token for Cloudflare DNS zone"
  sensitive   = true
}

variable "cloudflare_email" {
  type        = string
  description = "Email used for cloudflare account"
  sensitive   = true
}

variable "cloudflare_domain" {
  type        = string
  description = "domain (DNS zone) used for cloudflare account"
  sensitive   = true
}

variable "github_token" {
  type        = string
  description = "Github personall access token for ArgoCD"
  sensitive   = true
}