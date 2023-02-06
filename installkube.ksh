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

$mpexec sudo apt install gnupg lsb-release

# helm installation
arch=`$mpexec arch`
case $arch in
   "x86_64")
      helm='helm-v3.11.0-linux-amd64.tar.gz'
      helmpath="linux-amd64"
      ;;
   "arm64")
      helm='helm-v3.11.0-linux-arm64.tar.gz'
      helmpath="linux-arm64"
      ;;
esac 
$mpexec wget --inet4-only https://get.helm.sh/"$helm"
$mpexec tar xvzf $helm
$mpexec sudo install $helmpath/helm /usr/local/bin
$mpexec rm $helm
$mpexec rm -r $helmpath

# docker engin installation
$mpexec curl -fsSL https://download.docker.com/linux/ubuntu/gpg | $mpexec sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
arch=`$mpexec dpkg --print-architecture`
lsb_release=`$mpexec lsb_release -cs`
$mpexec echo "deb [arch=$arch signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $lsb_release stable" | $mpexec sudo tee /etc/apt/sources.list.d/docker.list
$mpexec sudo apt update
$mpexec sudo apt install docker-ce docker-ce-cli containerd.io -y
$mpexec sudo mkdir -p /etc/docker
cat <<EOF | $mpexec sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
$mpexec sudo sed -i "s/\"cri\"//g" /etc/containerd/config.toml
$mpexec sudo systemctl restart containerd
$mpexec sudo systemctl start docker
$mpexec sudo systemctl enable docker 

# kubernetes installation
$mpexec sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | $mpexec sudo tee /etc/apt/sources.list.d/kubernetes.list
$mpexec sudo apt update
$mpexec sudo apt install -y kubelet kubeadm kubectl
$mpexec sudo apt-mark hold kubelet kubeadm kubectl
