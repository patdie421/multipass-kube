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

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

name="$1"

for x in $(multipass list | tail -n +2 | grep "^[a-zA-Z0-9]" | cut -d' ' -f1)
do
   if [ "$x" == "$name" ]
   then
      echo "exist"
      trap - EXIT ; exit 0
   fi
done

echo "not found"
trap - EXIT ; exit 1
