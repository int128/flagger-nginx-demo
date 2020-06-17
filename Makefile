CLUSTER_NAME := flaggerdemo
OUTPUT_DIR := output
KUBECONFIG := $(OUTPUT_DIR)/kubeconfig.yaml
export KUBECONFIG

.PHONY: all
all: cluster

.PHONY: check
check:
	docker version
	kind version
	kubectl version --client
	helmfile --version

.PHONY: cluster
cluster:
	kind create cluster --name $(CLUSTER_NAME) --config cluster.yaml
	helmfile sync
	kubectl wait -l app=nginx-ingress --for=condition=Ready pod

.PHONY: logs-flagger
logs-flagger:
	kubectl logs -f -l app.kubernetes.io/name=flagger

.PHONY: delete-cluster
delete-cluster:
	kind delete cluster --name $(CLUSTER_NAME)
	-rm $(KUBECONFIG)
