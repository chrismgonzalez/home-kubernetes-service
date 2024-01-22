proxmox_host      = "https://10.10.10.8:8006/api2/json"
proxmox_token_id  = "terraform@pve!terraform"
proxmox_storage1  = "VMs"     # proxmox storage lvm 1
proxmox_storage2  = "vm-data" # proxmox storage lvm 2
target_node_name  = "pve-hulk"
region            = "pve-lab-cluster" # proxmox cluster name
pool              = "prod"            # proxmox pool for vms
cache_registry_ip = "10.1.1.151"
