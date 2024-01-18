# home-kubernetes-service

My attempt at automating a complete Kubernetes cluster similar to managed cloud services like EKS, AKS, or GKE.  I'm leveraging my home cloud, which is essentially 1U Supermicro server, repurposed Mac Mini's, and a handful (literally) of Lenovo m900 TinyPC's.

* Talos Linux
* ArgoCD
* the rest is history

static route configs using netplan

In order to access the proxmox private network you'll need to add static routes to your workstation machines

Using an Ubuntu workstation, you can use [Netplan](https://netplan.readthedocs.io/en/stable/)
```yaml
network:
  ethernets:
    enp1s0f0: #your interface
      dhcp4: true
      link-local: []
      addresses: 
        - 10.10.10.5/24 #origin machine IP
      routes:
        - to: 10.1.1.0/24 #where you want to go (our VM subnet in proxmox)
          via: 10.10.10.8 #how we get there (that static IP of the proxmox host)
          metric: 100
  version: 2
```

or in your shell

```sh
DESTINATION_NET="10.1.1.0/24"
DESTINATION_HOST=<proxmox_host_ip>
NIC=enp1s0f0
ip route add $DESTINATION_NET via DESTINATION_HOST dev $NIC
```

check the route:
```sh
ip route
10.1.1.0/24 via 10.10.10.8 dev enp1s0f0 proto static metric 100


```

# harbor

The initial `terraform apply` may fail when creating harbor registries, simply run the apply again and it should work.

# Troubleshoot internal networking

Running the below command will start a pod in the cluster network that will allow you to run networking commands such as `ping`, `tcpdump`, `dig`

```
$ kubectl run tmp-shell --rm -i --tty --image nicolaka/netshoot
```