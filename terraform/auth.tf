
provider "proxmox" {
  pm_api_url          = var.proxmox_host
  pm_api_token_id     = "terraform@pve!terraform"
  pm_api_token_secret = var.proxmox_token_secret
  pm_tls_insecure     = true
  pm_debug            = true
  pm_log_file         = "terraform-plugin-proxmox.log"
  pm_log_enable       = false
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}