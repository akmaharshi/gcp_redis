
Steps to install sysdig in kubernetes 

Copy 3 YAML files to local and follow below steps.

kubectl create ns sysdig-agent

kubectl create secret generic sysdig-agent --from-literal=access-key=d6243d26-89ce-419b-98cc-255c1f033c83 -n sysdig-agent

kubectl create -f https://raw.githubusercontent.com/draios/sysdig-cloud-scripts/master/agent_deploy/kubernetes/sysdig-agent-clusterrole.yaml -n sysdig-agent

kubectl create clusterrolebinding sysdig-agent --clusterrole=sysdig-agent --serviceaccount=sysdig-agent:sysdig-agent 

kubectl apply -f sysdig-agent-clusterrole.yaml -n sysdig-agent

kubectl create serviceaccount sysdig-agent -n sysdig-agent

kubectl create -f configmap.yml -n sysdig-agent

kubectl create -f sysdig-agent-daemonset-v2.yaml -n sysdig-agent

kubectl get pods -n sysdig-agent

kubectl logs podname -n sysdig-agent

REFERENCE LINK:

https://sysdigdocs.atlassian.net/wiki/spaces/Platform/pages/256475257/GKE+Agent+Installation+Steps
