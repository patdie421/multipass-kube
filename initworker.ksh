name="$1"
tmpext="tmp"
master="$2"

mpexec="multipass exec "$name" -- "
mpexecmaster="multipass exec "$master" -- "

_ip=`$mpexecmaster ifconfig -a enp0s2 | grep "inet "`
set $_ip
ip=$2
echo $ip

token=`multipass exec $master -- kubeadm token list | tail -1 | cut -d' ' -f1`
echo $token

$mpexecmaster sudo openssl x509 -in /etc/kubernetes/pki/ca.crt -noout -pubkey |  openssl rsa -pubin -outform DER 2>/dev/null > .initworker."$tmpext"
discoverytokencacerthash=`cat .initworker."$tmpext" | $mpexecmaster sha256sum | cut -d' ' -f1`
rm initworker."$tmpext"
echo $discoverytokencacerthash

$mpexec sudo kubeadm join $ip:6443 --token $token --discovery-token-ca-cert-hash sha256:$discoverytokencacerthash --cri-socket=unix:///var/run/cri-dockerd.sock
