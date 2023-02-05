name="$1"
tmpext="tmp"
master="$2"
ip="$3"
token="$4"
discoverytokencacerthash="$5"

mpexec="multipass exec "$name" -- "

echo $myip

$mpexec sudo kubeadm join $ip:6443 --token $token --discovery-token-ca-cert-hash sha256:$discoverytokencacerthash --cri-socket=unix:///var/run/cri-dockerd.sock 
