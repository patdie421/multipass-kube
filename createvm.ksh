usage()
{
   echo "usage: $1 <cfgfile> <vmname>"
}

if [ $# -ne 2 ]
then
   usage $0
   exit 1
fi

name="$2"
source fns/functions.ksh
source fns/init.ksh

GETOPTIONS="python3 ./getoptions.py -c $1"

_vm=$GETOPTIONS -V "$name"
# get interface

net=`$GETOPTIONS -n`
_addrs=`$GETOPTIONS -N $net`
set $_addrs

#get first no wifi active interface
_int=`getWiredActiveInterfaces $2`
if [ -z "$_int" ]
then
   #get first wifi active interface
   _int=`getWirelessActiveInterfaces $2`
   if [ -z "$_int" ]
   then
      echo "no interface available"
      exit 1
   else
      set $_int
      int=$1
      echo "wireless interface:" $int
   fi
else
   set $_int
   int=$1
   echo "wired interface:" $int
fi


mem="4"
cpus="2"
disk="10"
ubuntu='22.04'


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
