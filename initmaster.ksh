name="$1"
tmpext="tmp"

mpexec="multipass exec $name -- "

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
