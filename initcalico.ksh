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

source fn/functions.ksh
source fn/init.ksh

vmExist "$name"
if [ $? -ne 0 ]
then
   exit 1
fi


$mpexec helm repo add projectcalico https://projectcalico.docs.tigera.io/charts
$mpexec kubectl create namespace tigera-operator
$mpexec helm install calico projectcalico/tigera-operator --version v3.25.0 --namespace tigera-operator
$mpexec watch kubectl get pods --all-namespaces
