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

mpexec="multipass exec "$name" -- "

$mpexec sudo apt -y install golang

multipass transfer installcri.sub.ksh "$name":

$mpexec chmod +x installcri.sub.ksh
$mpexec ./installcri.sub.ksh
