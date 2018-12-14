include dependencies/Makefile taask-server/Makefile runner-k8s/Makefile

servertag=$(shell cat ./taask-server/.build/tag)
serverpath=./taask-server

build/server: tag/server/dev server/build/docker

install/server: build/server
	helm template $(serverpath)/ops/chart --set Tag=$(servertag) --set HomeDir=$(HOME) | kubectl apply -f - -n taask

logs/server:
	kubectl logs deployment/taask-server -n taask -f

uninstall/server:
	kubectl delete service taask-server -n taask
	kubectl delete service taask-server-ingress -n taask
	kubectl delete deployment taask-server -n taask

tag/server/dev:
	mkdir -p ./taask-server/.build
	date +%s | openssl sha256 | base64 | head -c 12 > ./taask-server/.build/tag

runnertag=$(shell cat ./taask-server/.build/tag)
runnerpath=./runner-k8s
joincode=asdf
count=1

build/runner: tag/runner/dev runner/build/docker

install/runner: build/runner
	helm template $(runnerpath)/ops/chart --set Tag=$(runnertag) --set JoinCode=$(shell cat ~/.taask/server/config/joincode) --set Count=$(count) | kubectl apply -f - -n taask

logs/runner:
	kubectl logs deployment/runner-k8s -n taask -f

uninstall/runner:
	kubectl delete deployment runner-k8s -n taask

tag/runner/dev:
	mkdir -p ./runner-k8s/.build
	date +%s | openssl sha256 | base64 | head -c 12 > ./runner-k8s/.build/tag