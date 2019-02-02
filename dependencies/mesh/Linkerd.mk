
deps/install/linkerd:
	echo "Using installed linkerd version $(linkerd version)"
	linkerd check --pre
	linkerd install | kubectl apply -f -
	linkerd check