usage()
{
   echo "usage: $1 <remotehost> <kpath> <name> <master>"
}

if [ $# -ne 4 ]
then
   usage $0
   exit 1
fi

remotehost="$1"
kpath="$2"
name="$3"
master="$4"

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
ssh -t $1 "cd \"$kpath\" ; ./initworker3.ksh $name $ip $token $discoverytokencacerthash"
