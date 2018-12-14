relpath = dependencies

include $(relpath)/monitoring/grafana/Grafana.mk $(relpath)/monitoring/prometheus/Prometheus.mk

all: deps/local deps/cluster

##############################################
# Install local tools needed for development #
##############################################

deps/install/local: deps/install/local/linkerd deps/install/local/helm deps/local/directories

deps/install/local/linkerd:
	curl -sL https://run.linkerd.io/install | sh

deps/install/local/helm:
	brew install kubernetes-helm

deps/local/directories:
	mkdir -p ~/.taask/prometheus/data
	mkdir -p ~/.taask/grafana/data
	mkdir -p ~/.taask/server/config


###################################################
# Install dependencies to your active k8s cluster #
###################################################

deps/install: deps/install/namespaces deps/install/linkerd deps/install/prometheus deps/install/grafana

deps/install/linkerd:
	echo "Using installed linkerd version $(linkerd version)"
	linkerd check --pre

deps/install/namespaces:
	kubectl create ns taask
	kubectl create ns metrics