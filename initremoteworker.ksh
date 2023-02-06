remotehost="$1"
name="$2"
master="$3"
token=`cat .$master.token`
discoverytokencacerthash=`cat .$master.discoverytokencacerthash`
ip=`cat .$master.ip`

ssh $1 ./initworker3.ksh $name $ip $token $discoverytokencacerthash
