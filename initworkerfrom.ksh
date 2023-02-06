name=$1
remote=$2
kpath=$3
master=$4

ici=`pwd`
localhost=`hostname`
ssh -t "$remote" "cd \"$kpath\" ; ./initremoteworker.ksh \"$localhost\" \"$ici\" \"$name\" \"$master\""
