set -e

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
tmpext="tmp"

source fn/init.ksh
source fn/functions.ksh

vmExist $1
if [ $? -ne 0 ]
then
   exit 1
fi

multipass -p delete "$name"

trap - DEBUG
trap - EXIT
