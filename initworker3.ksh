usage()
{
   echo "usage: $1 <vmname> <ip> <token> <discoverytokencacerthash>"
}

if [ $# -ne 4 ]
then
   usage $0
   exit 1
fi

name="$1"
ip="$2"
token="$3"
discoverytokencacerthash="$4"

source fn/functions.ksh
source fn/init.ksh

vmExist "$name"
if [ $? -ne 0 ]
then
   exit 1
fi

$mpexec sudo kubeadm join $ip:6443 --token $token --discovery-token-ca-cert-hash sha256:$discoverytokencacerthash --cri-socket=unix:///var/run/cri-dockerd.sock
