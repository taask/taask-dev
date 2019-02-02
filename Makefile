include dependencies/Makefile taask-server/Makefile runner-k8s/Makefile runner-docker/Makefile

##################################################################
# imports install, build, tag, etc tools from server and runners #
##################################################################

## Ex: install/server 				: installs the server
##	   install/runner/docker 		: installs the docker runner
##	   uninstall/runner/k8s 		: uninstalls the k8s runner
##	   logs/runner/docker streams 	: logs from the docker runner

serverpath=./taask-server

runnerk8spath=./runner-k8s
runnerdockerpath=./runner-docker


################################
# some helpful debugging tools #
################################

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
	