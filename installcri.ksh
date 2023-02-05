name="$1"
mem="4"
cpus="2"
tmpext="tmp"

mpexec="multipass exec "$name" -- "

$mpexec sudo apt -y install golang

multipass transfer installcri.sub.ksh "$name":

$mpexec chmod +x installcri.sub.ksh
$mpexec ./installcri.sub.ksh
