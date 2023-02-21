usage()
{
   echo "usage: $1 <cfgfile>"
}

if [ $# -ne 1 ]
then
   usage $0
   exit 1
fi

cfgfile="$1"

source fns/functions.ksh
source fns/init.ksh

GETOPTIONS="python3 ./getoptions.py -c $cfgfile"

# get network info
net=`$GETOPTIONS -n`
set $net
_netinfo=`$GETOPTIONS -N $1`
if [ -z "$_netinfo" ]
then
   echo "network ($net) not found in config file"
   exit 1
fi
set $_netinfo

CIDR="$4"
iprange="$5"

# calico
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/tigera-operator.yaml
curl https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/custom-resources.yaml -o custom-resources.yaml.$tmpext
cat custom-resources.yaml.$tmpext | sed -e "s/cidr: .*/cidr: $CIDR/" | tee custom-resources.yaml
kubectl apply -f custom-resources.yaml
rm custom-resources.yaml.$tmpext
rm custom-resources.yaml

# metallb
kubectl get configmap -n kube-system kube-proxy -o yaml | sed -e "s/strictARP: .*/strictARP: true/" | kubectl apply -f -
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml
sleep 60
cat manifests/metallb-ipaddresspool.yaml.template | sed -e "s/##IPRANGE##/$iprange/g" | kubectl apply -f -
kubectl apply -f manifests/metallb-l2advertisment.yaml

# ingress
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.5.1/deploy/static/provider/cloud/deploy.yaml
