default: init release

clean:
	rm -f nocloud-*.qcow2.xz
	rm -f nocloud-*.qcow2

init:
	packer init -upgrade .

release:
	PACKER_LOG=1 packer build -only=release.proxmox.talos -var-file="vars/local.pkrvars.hcl" -var proxmox_username="${PROXMOX_TOKEN_ID}" \
	-var proxmox_token="${PROXMOX_TOKEN_SECRET}" -var proxmox_nodename="${PROXMOX_NODE_NAME}" -var proxmox_url="${PROXMOX_HOST}" .

harbor:
	PACKER_LOG=1 packer build -only=release.proxmox-iso.harbor-ubuntu-jammy -var-file="vars/local.pkrvars.hcl" -var proxmox_username="${PROXMOX_TOKEN_ID}" \
	-var proxmox_token="${PROXMOX_TOKEN_SECRET}" -var proxmox_nodename="${PROXMOX_NODE_NAME}" -var proxmox_url="${PROXMOX_HOST}" .