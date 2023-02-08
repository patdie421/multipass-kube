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

_ip=`$mpexec ifconfig -a enp0s2 | grep "inet "`
set $_ip
ip=$2

#$mpexec sudo kubeadm init --apiserver-advertise-address=$ip --apiserver-cert-extra-sans=$ip --pod-network-cidr=10.244.0.0/16 --node-name kmaster
$mpexec sudo kubeadm init --apiserver-advertise-address=$ip --apiserver-cert-extra-sans=$ip --pod-network-cidr=172.16.0.0/16 --cri-socket=unix:///var/run/cri-dockerd.sock

# copy kubeconfig
$mpexec mkdir -p .kube
$mpexec sudo cp -i /etc/kubernetes/admin.conf .kube/config
# $mpexec sudo chown $(id -u):$(id -g) .kube/config
$mpexec sudo chown ubuntu:ubuntu .kube/config

#get kubeconfig
multipass transfer $name:.kube/config ./config.tmp
mkdir -p $HOME/.kube
cp ./config.tmp $HOME/.kube/config
rm ./config.tmp

$mpexec kubectl get nodes

token=`$mpexec kubeadm token list | tail -1 | cut -d' ' -f1`
$mpexec sudo openssl x509 -in /etc/kubernetes/pki/ca.crt -noout -pubkey |  openssl rsa -pubin -outform DER 2>/dev/null > .initworker."$tmpext"
discoverytokencacerthash=`cat .initworker."$tmpext" | $mpexec sha256sum | cut -d' ' -f1`
ip=`$mpexec cat .kube/config | grep server | cut -d':' -f3 | cut -d'/' -f3`
rm .initworker."$tmpext"
echo $token > .$name.token
echo $discoverytokencacerthash > .$name.discoverytokencacerthash
echo $ip > .$name.ip
