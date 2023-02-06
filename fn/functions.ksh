getInterface()
{
   INT=''
   ifconfig | grep '[a-z0-9]*:.*UP\|\ *inet ' | while read line
   do
      set $line
      if [ "$1" == 'inet' ]
      then
         if [ "$INT" != 'lo0:' ]
         then
            _INT=`echo $INT | cut -d ':' -f1`
            echo $_INT $2
         fi
         INT=''
      else
         INT=$1
      fi
   done
}

getMac()
{
   INT=''
   ifconfig | grep '[a-z0-9]*:.*UP\|\ *ether ' | while read line
   do
      set $line
      if [ "$1" == 'ether' ]
      then
         if [ "$INT" != 'lo0:' ]
         then
            _INT=`echo $INT | cut -d ':' -f1`
            echo $_INT $2
         fi
         INT=''
      else
         INT=$1
      fi
   done
}

vmExist()
{
   name="$1"
   for x in $(multipass list | tail -n +2 | grep "^[a-zA-Z0-9]" | cut -d' ' -f1)
   do
      if [ "$x" == "$name" ]
      then
#         echo "exist"
         return 0
      fi
   done

#   echo "not found"
   return 1
}

