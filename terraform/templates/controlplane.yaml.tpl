machine:
  nodeLabels:
    node.cloudprovider.kubernetes.io/platform: proxmox
    topology.kubernetes.io/region: ${px_region}
    topology.kubernetes.io/zone: ${px_node}
  certSANs:
    - ${apiDomain}
    - ${ipv4_vip}
    - ${ipv4_local}
  kubelet:
    extraMounts:
      - destination: /var/lib/longhorn
        type: bind
        source: /var/lib/longhorn
        options:
          - bind
          - rshared
          - rw
    defaultRuntimeSeccompProfileEnabled: true # Enable container runtime default Seccomp profile.
    disableManifestsDirectory: true # The `disableManifestsDirectory` field configures the kubelet to get static pod manifests from the /etc/kubernetes/manifests directory.
    extraArgs:
      rotate-server-certificates: true
    clusterDNS:
      - 169.254.2.53
      - ${cidrhost(split(",",serviceSubnets)[0], 10)}
  network:
    hostname: "${hostname}"
    interfaces:
      - interface: eth0
        addresses:
          - ${ipv4_local}/24
        vip:
          ip: ${ipv4_vip}    
      - interface: dummy0
        addresses:
          - 169.254.2.53/32
    extraHostEntries:
      - ip: 127.0.0.1
        aliases:
          - ${apiDomain} 
    nameservers:
      - 1.1.1.1
      - 8.8.8.8
    kubespan:
      enabled: false
  install:
    disk: /dev/sda
    image: ghcr.io/siderolabs/installer:${talos-version}
    bootloader: true
    wipe: false
  sysctls:
    net.core.somaxconn: 65535
    net.core.netdev_max_backlog: 4096
  systemDiskEncryption:
    state:
      provider: luks2
      options:
        - no_read_workqueue
        - no_write_workqueue
      keys:
        - nodeID: {}
          slot: 0
    ephemeral:
      provider: luks2
      options:
        - no_read_workqueue
        - no_write_workqueue
      keys:
        - nodeID: {}
          slot: 0
  time:
    servers:
      - time.cloudflare.com
  # Features describe individual Talos features that can be switched on or off.
  features:
    rbac: true # Enable role-based access control (RBAC).
    stableHostname: true # Enable stable default hostname.
    apidCheckExtKeyUsage: true # Enable checks for extended key usage of client certificates in apid.
    kubernetesTalosAPIAccess:
      enabled: true
      allowedRoles:
        - os:reader
      allowedKubernetesNamespaces:
        - kube-system
  kernel:
    modules:
      - name: br_netfilter
        parameters:
          - nf_conntrack_max=131072
  # registries:
  #   mirrors:
  #     docker.io:
  #       endpoints:
  #         - http://${registry-endpoint}/v2/proxy-docker.io
  #       overridePath: true
  #     ghcr.io:
  #       endpoints:
  #         - http://${registry-endpoint}/v2/proxy-ghcr.io
  #       overridePath: true
  #     gcr.io:
  #       endpoints:
  #         - http://${registry-endpoint}/v2/proxy-gcr.io
  #       overridePath: true
  #     registry.k8s.io:
  #       endpoints:
  #         - http://${registry-endpoint}/v2/proxy-registry.k8s.io
  #       overridePath: true
  #     quay.io:
  #       endpoints:
  #         - http://${registry-endpoint}/v2/proxy-quay.io
  #       overridePath: true
cluster:
  controlPlane:
    endpoint: https://${apiDomain}:6443
  network:
    dnsDomain: ${domain}
    podSubnets: ${format("%#v",split(",",podSubnets))}
    serviceSubnets: ${format("%#v",split(",",serviceSubnets))}
    cni:
      name: custom
      urls:
        - https://raw.githubusercontent.com/chrismgonzalez/home-kubernetes-service/main/manifests/talos/cilium-result.yaml
  proxy:
    disabled: true
  etcd:
    extraArgs:
      listen-metrics-urls: http://0.0.0.0:2381
  inlineManifests:
  - name: argocd
    contents: |-
      apiVersion: v1
      kind: Namespace
      metadata:
          name: argocd
  - name: longhorn-system
    contents: |- 
      apiVersion: v1
      kind: Namespace
      metadata:
          name: longhorn-system
          labels:
            pod-security.kubernetes.io/enforce: "privileged"
            pod-security.kubernetes.io/audit: "privileged"
            pod-security.kubernetes.io/warn: "privileged"
  - name: cilium
    contents: |- 
      apiVersion: v1
      kind: Namespace
      metadata:
          name: cilium
          labels:
            pod-security.kubernetes.io/enforce: "privileged"
  # - name: external-dns
  #   contents: |- 
  #     apiVersion: v1
  #     kind: Namespace
  #     metadata:
  #         name: external-dns
  - name: cert-manager
    contents: |- 
      apiVersion: v1
      kind: Namespace
      metadata:
          name: cert-manager
  - name: ingress-nginx
    contents: |- 
      apiVersion: v1
      kind: Namespace
      metadata:
          name: ingress-nginx
  - name: cloudflare-api-token-secret
    contents: |-
      apiVersion: v1
      kind: Secret
      metadata:
        name: cloudflare-api-token-secret
        namespace: cert-manager
      type: Opaque
      stringData:
        api-token: ${cf_token}
  - name: metallb-addresspool
    contents: |- 
      apiVersion: metallb.io/v1beta1
      kind: IPAddressPool
      metadata:
        name: first-pool
        namespace: metallb-system
      spec:
        addresses:
        - ${metallb_l2_addressrange}
  - name: metallb-l2
    contents: |- 
      apiVersion: metallb.io/v1beta1
      kind: L2Advertisement
      metadata:
        name: layer2
        namespace: metallb-system
      spec:
        ipAddressPools:
        - first-pool
  - name: argocd-repo-credentials
    contents: |-
      apiVersion: v1
      kind: Secret
      metadata:
        name: argocd-repo-credentials
        namespace: argocd
        labels:
          argocd.argoproj.io/secret-type: repository
      type: Opaque
      stringData:
        type: git
        url: https://github.com/chrismgonzalez/home-kubernetes-service
        password: ${github_token}
        username: not-used
  - name: cloudflare-issuer-staging
    contents: |-
      apiVersion: cert-manager.io/v1
      kind: ClusterIssuer
      metadata:
        name: letsencrypt-staging
      spec:
        acme:
          server: https://acme-staging-v02.api.letsencrypt.org/directory
          email: ${cf_email}
          privateKeySecretRef:
            name: letsencrypt-staging
          solvers:
            - dns01:
                cloudflare:
                  email: ${cf_email}
                  apiTokenSecretRef:
                    name: cloudflare-api-token-secret
                    key: api-token
              selector:
                dnsZones:
                  - ${cf_domain}
  - name: cloudflare-issuer-prod
    contents: |-
      apiVersion: cert-manager.io/v1
      kind: ClusterIssuer
      metadata:
        name: letsencrypt-staging
      spec:
        acme:
          server: https://acme-v02.api.letsencrypt.org/directory
          email: ${cf_email}
          privateKeySecretRef:
            name: letsencrypt-issuer
          solvers:
            - dns01:
                cloudflare:
                  email: ${cf_email}
                  apiTokenSecretRef:
                    name: cloudflare-api-token-secret
                    key: api-token
              selector:
                dnsZones:
                  - ${cf_domain}
  externalCloudProvider:
    enabled: true
    manifests:
    - https://raw.githubusercontent.com/chrismgonzalez/home-kubernetes-service/main/manifests/talos/coredns-local.yaml
    - https://raw.githubusercontent.com/alex1989hu/kubelet-serving-cert-approver/v0.7.4/deploy/standalone-install.yaml
    - https://raw.githubusercontent.com/chrismgonzalez/home-kubernetes-service/main/manifests/talos/metallb-native.yaml
    - https://raw.githubusercontent.com/chrismgonzalez/home-kubernetes-service/main/manifests/talos/metrics-server.yaml
    - https://raw.githubusercontent.com/chrismgonzalez/home-kubernetes-service/argocd/manifests/talos/argocd-result.yaml
    - https://raw.githubusercontent.com/chrismgonzalez/home-kubernetes-service/argocd/manifests/talos/argocd-install.yaml
    - https://github.com/cert-manager/cert-manager/releases/download/v1.13.3/cert-manager.crds.yaml
    - https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.64.1/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagerconfigs.yaml
    - https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.64.1/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml
    - https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.64.1/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml
    - https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.64.1/example/prometheus-operator-crd/monitoring.coreos.com_probes.yaml
    - https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.64.1/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml
    - https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.64.1/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml
    - https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.64.1/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml
    - https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.64.1/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml