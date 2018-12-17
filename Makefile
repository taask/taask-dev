include dependencies/Makefile taask-server/Makefile runner-k8s/Makefile

servertag=$(shell cat ./taask-server/.build/tag)
serverpath=./taask-server

build/server: tag/server/dev server/build/docker

install/server: build/server
	helm template $(serverpath)/ops/chart \
	--set Tag=$(servertag) --set HomeDir=$(HOME) \
	| linkerd inject --proxy-bind-timeout 30s - \
	| kubectl apply -f - -n taask

logs/server:
	kubectl logs deployment/taask-server taask-server -n taask -f

logs/server/search:
	kubectl logs deployment/taask-server taask-server -n taask -f | grep $(search)

uninstall/server:
	kubectl delete service taask-server -n taask
	kubectl delete service taask-server-ingress -n taask
	kubectl delete deployment taask-server -n taask

tag/server/dev:
	mkdir -p ./taask-server/.build
	date +%s | openssl sha256 | base64 | head -c 12 > ./taask-server/.build/tag

runnertag=$(shell cat ./runner-k8s/.build/tag)
runnerpath=./runner-k8s
joincode=asdf
count=1

build/runner: tag/runner/dev runner/build/docker

install/runner: build/runner
	helm template $(runnerpath)/ops/chart \
	--set Tag=$(runnertag) --set JoinCode=$(shell cat ~/.taask/server/config/joincode) --set Count=$(count) \
	| linkerd inject --proxy-bind-timeout 30s - \
	| kubectl apply -f - -n taask

## this is essentially the same as install, without a build beforehand
scale/runner:
	helm template $(runnerpath)/ops/chart \
	--set Tag=$(runnertag) --set JoinCode=$(shell cat ~/.taask/server/config/joincode) --set Count=$(count) \
	| linkerd inject --proxy-bind-timeout 30s - \
	| kubectl apply -f - -n taask

logs/runner:
	kubectl logs deployment/runner-k8s runner-k8s -n taask -f

logs/runner/search:
	kubectl logs deployment/runner-k8s runner-k8s -n taask -f | grep $(search)

uninstall/runner:
	kubectl delete deployment runner-k8s -n taask

tag/runner/dev:
	mkdir -p ./runner-k8s/.build
	date +%s | openssl sha256 | base64 | head -c 12 > ./runner-k8s/.build/tag


### some helpful debugging tools

debug/tasks/incomplete:
	cat serverout | grep -e "> waiting" \
	| sed 's/ status updated ( -> waiting)//g' \
	| sort \
	> alltasks

	cat serverout | grep -e "> complete" \
	| sed 's/ status updated (running -> complete)//g' \
	| sort \
	> completetasks

	diff completetasks alltasks

debug/tasks/logs:
	cat serverout | grep $(uuid) | code -
	