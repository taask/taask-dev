grafpath = dependencies/monitoring/grafana

deps/install/grafana:
	docker build $(grafpath) -t taask/grafana:dev

	helm template $(grafpath)/chart \
	--set HomeDir=$(HOME) \
	| linkerd inject - \
	| kubectl apply -f - -n metrics

deps/uninstall/grafana:
	kubectl delete deployment grafana -n metrics
	kubectl delete service grafana -n metrics
