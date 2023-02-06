name="$1"
master="$2"
token=`cat .$master.token`
discoverytokencacerthash=`cat .$master.discoverytokencacerthash`
ip=`cat .$master.ip`

./initworker3.ksh $name $ip $token $discoverytokencacerthash
