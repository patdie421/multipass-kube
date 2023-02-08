usage()
{
   echo "usage: $1 <vmname> <master>"
}

if [ $# -ne 2 ]
then
   usage $0
   exit 1
fi

name="$1"
master="$2"

source fns/functions.ksh
source fns/init.ksh

vmExist "$name"
if [ $? -ne 0 ]
then
   exit 1
fi

token=`cat .$master.token`
discoverytokencacerthash=`cat .$master.discoverytokencacerthash`
ip=`cat .$master.ip`

./initworker3.ksh $name $ip $token $discoverytokencacerthash
