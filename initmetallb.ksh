usage()
{
   echo "usage: $1 <vmname>"
}

if [ $# -ne 1 ]
then
   usage $0
   exit 1
fi

name="$1"

source fns/functions.ksh
source fns/init.ksh

vmExist "$name"
if [ $? -ne 0 ]
then
   exit 1
fi

$mpexec kubectl get configmap -n kube-system kube-proxy -o yaml > cm_kube-proxy.yaml.$tmpext
cat cm_kube-proxy.yaml.$tmpext | sed -e "s/strictARP: .*/strictARP: true/" > cm_kube-proxy.yaml.$tmpext.2
kubectl apply -f cm_kube-proxy.yaml.$tmpext.2

$mpexec kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml
