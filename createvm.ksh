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
mem="4"
cpus="2"
disk="10"
network='192.168.0'
ubuntu='22.04'
tmpext="tmp"

source fns/functions.ksh
source fns/init.ksh

vmExist "$name"
if [ $? -eq 0 ]
then
   exit 1
fi
 
_int=`getInterface | grep $network | head -1` ; set $_int ; int=$1

# create vm
multipass launch "$ubuntu" --name "$name" --memory "$mem"G --disk "$disk"G --cpus "$cpus" --network "$int"

# install package
$mpexec sudo apt update
$mpexec sudo apt install -y net-tools apt-transport-https ca-certificates curl cifs-utils nfs-common

# install ssh key
multipass transfer "$name":.ssh/authorized_keys authorized_keys."$tmpext"
if [ -f "$HOME/.ssh/id_rsa.pub" ]
then
   cat $HOME/.ssh/id_rsa.pub >> authorized_keys."$tmpext"
   multipass transfer authorized_keys."$tmpext" "$name":.ssh/authorized_keys
   rm authorized_keys."$tmpext"
fi

$mpexec ifconfig -a ; multipass networks
multipass transfer subs/createvm.sub.ksh "$name":
$mpexec ./createvm.sub.ksh
$mpexec rm createvm.sub.ksh
