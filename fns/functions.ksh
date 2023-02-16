#getMacAddr()
#{
#   networksetup -getmacaddress en1 | sed "s/Ethernet Address: //g" | sed "s/ \(.*\)//g"
#}

getInterfaceIP()
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

getInterfaceBroadcast()
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
            echo $_INT $2 $6
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

isWifiMacOs()
{
   int=$1
#   cat networksetup.txt | while read line
   networksetup -listallhardwareports | while read line
   do
      a=`expr "$line" : '\(.*\):.*' | tr '[:upper:]' '[:lower:]'`
      b=`expr "$line" : '.*: *\(.*\)' | tr '[:upper:]' '[:lower:]'`
      if [ "$a" == "hardware port" ]
      then
         port=$b
      else
         if [ "$a" == "device" ]
         then
            if [ "$port" == "wi-fi" ]
            then
               if [ "$b" == "$int" ]
               then
                  return 1
               fi
            fi
         fi
      fi
   done
   if [ $? -eq 1 ]
   then
      echo "true"
      return 0
   else
      echo "false"
      return 1
   fi
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

