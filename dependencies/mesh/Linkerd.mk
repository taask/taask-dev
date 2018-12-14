
deps/install/linkerd:
	echo "Using installed linkerd version $(linkerd version)"
	linkerd check --pre
	linkerd install | kubectl apply -f -
	linkerd check

deps/uninstall/linkerd/extras:
	kubectl delete deployment linkerd-grafana -n linkerd