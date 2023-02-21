usage()
{
   echo "usage: $1 <cfgfile>"
}
 
 
if [ $# -ne 1 ]
then
   usage $0
   exit 1
fi
 
cfgfile="$1"
 
source fns/functions.ksh
source fns/init.ksh
 
mpexec="echo $mpexec"
GETOPTIONS="python3 getoptions.py -c $cfgfile"
masters=`$GETOPTIONS -m`
set $masters
master=$1
for i in $masters
do
   m=`$GETOPTIONS -M $i`
   if [ -z "$m" ]
   then
      echo "config file error"
      exit 1
   fi
   set $m
   ./createvm.ksh "$cfgfile" "$i" "$6"
   ./installkube.ksh "$i"
   ./installcri.ksh "$i"
   if [ "$master" == "$i" ]
   then
      # ./initmaster.ksh "$i" "$cfgfile"
      ./initmaster.ksh "$i"
   else
      echo "multi-master not implemented"
   fi
done
 
workers=`$GETOPTIONS -w`
token=`cat .$master.token`
discoverytokencacerthash=`cat .$master.discoverytokencacerthash`
ip=`cat .$master.ip`
for i in $workers
do
   w=`$GETOPTIONS -W $i`
   if [ -z "$w" ]
   then
      echo "config file error"
      exit 1
   fi
   set $w
   if [ "None" == "$5" ]
   then
      ./createvm.ksh "$cfgfile" "$i"
      ./installkube.ksh "$i"
      ./installcri.ksh "$i"
      ./initworker3.ksh "$i" "$ip" "$token" "$discoverytokencacerthash"
   else
      whost=`echo $5 | cut -d':' -f1`
      wpath=`echo $5 | cut -d':' -f2`
      cmd="cd $wpath ; ./createvm.ksh $cfgfile $i"
      ssh $whost "$cmd"
      cmd="cd $wpath ; ./installkube.ksh $i"
      ssh $whost "$cmd"
      cmd="cd $wpath ; ./installcri.ksh $i"
      ssh $whost "$cmd"
      cmd="cd $wpath ; ./initworker3 $i $i $ip $token $discoverytokencacerthash"
      ssh $whost "$cmd"
   fi
done
 
./initnetwork.ksh $cfgfile
./initstorage.ksh
./initdashboard.ksh

