remotehost="$1"
kpath="$2"
name="$3"
master="$4"
token=`cat .$master.token`
discoverytokencacerthash=`cat .$master.discoverytokencacerthash`
ip=`cat .$master.ip`
ssh -t $1 "cd \"$kpath\" ; ./initworker3.ksh $name $ip $token $discoverytokencacerthash"
