source fns/functions.ksh
source fns/init.ksh

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

kubectl apply -f manifests/dashboard-se-lb.yaml
