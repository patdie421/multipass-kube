name="$1"
tmpext="tmp"

mpexec="multipass exec $name -- "

$mpexec helm repo add projectcalico https://projectcalico.docs.tigera.io/charts
$mpexec kubectl create namespace tigera-operator
$mpexec helm install calico projectcalico/tigera-operator --version v3.25.0 --namespace tigera-operator
$mpexec watch kubectl get pods --all-namespaces
