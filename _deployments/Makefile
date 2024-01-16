
help:
	@awk 'BEGIN {FS = ":.*?## "} /^[0-9a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

helm-repos: ## add helm repos
	helm repo add cilium               https://helm.cilium.io/
	helm repo add metrics-server       https://kubernetes-sigs.github.io/metrics-server/
	helm repo add ingress-nginx        https://kubernetes.github.io/ingress-nginx
    helm repo add fluxcd-community     https://fluxcd-community.github.io/helm-charts
	helm repo update

create-deployments: ## create templates
	# helm template cilium \
    # cilium/cilium \
    # --version 1.14.5 \
    # --namespace cilium \
    # --set ipam.mode=kubernetes \
    # --set tunnel=disabled \
    # --set bpf.masquerade=true \
    # --set endpointRoutes.enabled=true \
    # --set kubeProxyReplacement=strict \
    # --set autoDirectNodeRoutes=true \
    # --set localRedirectPolicy=true \
    # --set operator.rollOutPods=true \
    # --set rollOutCiliumPods=true \
    # --set ipv4NativeRoutingCIDR="10.244.0.0/16" \
    # --set hubble.relay.enabled=true \
    # --set hubble.ui.enabled=true \
    # --set securityContext.capabilities.ciliumAgent="{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}" \
    # --set=securityContext.capabilities.cleanCiliumState="{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}" \
    # --set=cgroup.autoMount.enabled=false \
    # --set=cgroup.hostRoot=/sys/fs/cgroup \
    # --set=k8sServiceHost="api.cluster.local" \
    # --set=k8sServicePort="6443" > vars/cilium-result.yaml
		
    helm template flux2 fluxcd-community/flux2 \
    --version 2.12.2 \
    --namespace flux-system > vars/fluxcdv2.yaml

	# helm template --namespace=kube-system  --version=1.14.5 -f vars/cilium.yaml cilium \
	# 	cilium/cilium > vars/cilium-result.yaml

	# helm template --namespace=kube-system -f vars/metrics-server.yaml metrics-server \
	# 	metrics-server/metrics-server > vars/metrics-server-result.yaml

	# helm template --namespace=ingress-nginx --version=4.7.0 -f vars/ingress.yaml ingress-nginx \
	# 	ingress-nginx/ingress-nginx > vars/ingress-result.yaml
