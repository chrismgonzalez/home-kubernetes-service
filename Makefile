
CLUSTERNAME:="talos-k8s-proxmox"
CPFIRST := ${shell terraform output -raw controlplane_firstnode 2>/dev/null}
ENDPOINT := ${shell terraform output -raw controlplane_endpoint 2>/dev/null}
ifneq (,$(findstring Warning,${ENDPOINT}))
ENDPOINT := api.cluster.local
endif

help:
	@awk 'BEGIN {FS = ":.*?## "} /^[0-9a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: init
init: ## Initialize terraform
	terraform init -upgrade

create-config: ## Genereate talos configs
	terraform apply -auto-approve -target=local_file.worker_patch
	talosctl gen config --output-dir _cfgs --with-docs=false --with-examples=false --config-patch-worker @templates/worker.patch.yaml ${CLUSTERNAME} https://${ENDPOINT}:6443
	talosctl --talosconfig _cfgs/talosconfig config endpoint ${ENDPOINT}

create-templates:
	@echo 'podSubnets: "10.244.0.0/16"'        >  _cfgs/tfstate.vars
	@echo 'serviceSubnets: "10.96.0.0/12"'     >> _cfgs/tfstate.vars
	@echo 'apiDomain: api.cluster.local'       >> _cfgs/tfstate.vars
	@yq eval '.cluster.network.dnsDomain' _cfgs/controlplane.yaml | awk '{ print "domain: "$$1}'       >> _cfgs/tfstate.vars
	@yq eval '.cluster.clusterName' _cfgs/controlplane.yaml       | awk '{ print "clusterName: "$$1}'  >> _cfgs/tfstate.vars
	@yq eval '.cluster.id' _cfgs/controlplane.yaml                | awk '{ print "clusterID: "$$1}'    >> _cfgs/tfstate.vars
	@yq eval '.cluster.secret' _cfgs/controlplane.yaml            | awk '{ print "clusterSecret: "$$1}'>> _cfgs/tfstate.vars
	@yq eval '.machine.token'  _cfgs/controlplane.yaml            | awk '{ print "tokenMachine: "$$1}' >> _cfgs/tfstate.vars
	@yq eval '.machine.ca.crt' _cfgs/controlplane.yaml            | awk '{ print "caMachine: "$$1}'    >> _cfgs/tfstate.vars
	@yq eval '.cluster.token'  _cfgs/controlplane.yaml            | awk '{ print "token: "$$1}'        >> _cfgs/tfstate.vars
	@yq eval '.cluster.ca.crt' _cfgs/controlplane.yaml            | awk '{ print "ca: "$$1}'           >> _cfgs/tfstate.vars

	@yq eval -o=json '{"kubernetes": .}' _cfgs/tfstate.vars > terraform.tfvars.json

create-controlplane-bootstrap:
	talosctl --talosconfig _cfgs/talosconfig config endpoint ${ENDPOINT}
	talosctl --talosconfig _cfgs/talosconfig --nodes ${CPFIRST} bootstrap

create-controlplane: ## Bootstrap first controlplane node
	terraform apply -auto-approve -target=null_resource.controlplane
	terraform refresh

create-kubeconfig: ## Prepare kubeconfig
	talosctl --talosconfig _cfgs/talosconfig --nodes ${CPFIRST} kubeconfig .
	kubectl --kubeconfig=kubeconfig config set clusters.${CLUSTERNAME}.server https://${ENDPOINT}:6443
	kubectl --kubeconfig=kubeconfig config set-context --current --namespace=kube-system

reset-config: ## delete config director
	rm -rf _cfgs/

get-argocd-secret: # get argocd admin secret
	argocd admin initial-secret -n argocd 