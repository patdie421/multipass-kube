source fns/functions.ksh
source fns/init.ksh

getInterface()
{ 
   getInterfaceBroadcast | grep $1 | while read line
   do
      set $line
      isWifiMacOs $1 > /dev/null 2>&1
      if [ $? -ne 0 ]
      then
         echo "$1 \c"
      fi
  done
  echo
}

GETOPTIONS="python3 ./getoptions.py"
net=`$GETOPTIONS -n`
addrs=`$GETOPTIONS -N $net`
set $addrs

#get first no wifi active interface
int=`getInterface $2`
set $int
echo $1
