relpath = dependencies

include $(relpath)/monitoring/grafana/Grafana.mk $(relpath)/monitoring/prometheus/Prometheus.mk $(relpath)/mesh/Linkerd.mk

all: deps/local deps/cluster

##############################################
# Install local tools needed for development #
##############################################

deps/install/local: deps/install/local/linkerd deps/install/local/helm deps/local/directories

deps/install/local/linkerd:
	curl -sL https://run.linkerd.io/install | sh

deps/fix/local/linkerd:
	# this is stupid and linkerd should feel bad
	# add this to your .bash_profile or whatever you use to make linkerd work
	# export PATH=$PATH:$HOME/.linkerd2/bin

deps/install/local/helm:
	brew install kubernetes-helm

deps/local/directories:
	mkdir -p ~/.taask/prometheus/data
	mkdir -p ~/.taask/grafana/data
	mkdir -p ~/.taask/server/config
	mkdir -p ~/.taask/runner/config
	mkdir -p ~/.taask/runner/data


###################################################
# Install dependencies to your active k8s cluster #
###################################################

deps/install: deps/install/namespaces deps/install/linkerd deps/install/prometheus deps/install/grafana

deps/install/namespaces:
	kubectl create ns taask
	kubectl create ns metrics