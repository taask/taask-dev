prompath = dependencies/monitoring/prometheus

deps/install/prometheus:
	docker build $(prompath) -t taask/prometheus:dev

	helm template $(prompath)/chart \
	--set HomeDir=$(HOME) \
	| linkerd inject - \
	| kubectl apply -f - -n metrics

deps/uninstall/prometheus:
	kubectl delete deployment prometheus -n metrics
	kubectl delete service prometheus -n metrics
