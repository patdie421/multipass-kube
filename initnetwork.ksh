source fns/functions.ksh
source fns/init.ksh

CIDR="172.16.0.0\/16"

# calico
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/tigera-operator.yaml
curl https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/custom-resources.yaml -o custom-resources.yaml.$tmpext
cat custom-resources.yaml.$tmpext | sed -e "s/cidr: .*/cidr: $CIDR/" | tee custom-resources.yaml
kubectl apply -f custom-resources.yaml
rm custom-resources.yaml.$tmpext
rm custom-resources.yaml

# metallb
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml
kubectl apply -f manifests/metallb-ipaddresspool.yaml
kubectl apply -f manifests/metallb-l2advertisment.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.5.1/deploy/static/provider/cloud/deploy.yaml
