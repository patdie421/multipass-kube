usage()
{
   echo "usage: $1 <vmname> <remoteserver> <kpath> <mastername>"
}

if [ $# -ne 4 ]
then
   usage $0
   exit 1
fi

name=$1
remote=$2
kpath=$3
master=$4

source fns/functions.ksh
source fns/init.ksh

vmExist "$name"
if [ $? -ne 0 ]
then
   exit 1
fi

kici=`pwd`
localhost=`hostname`
ssh -t "$remote" "cd \"$kpath\" ; ./initremoteworker.ksh \"$localhost\" \"$kici\" \"$name\" \"$master\""
