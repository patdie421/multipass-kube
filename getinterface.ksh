INT=''
ifconfig | grep '[a-z0-9]*:.*UP\|\ *inet ' | while read line
do
   set $line
   if [ $1 == 'inet' ]
   then
      if [ $INT != 'lo0:' ]
      then
         _INT=`echo $INT | cut -d ':' -f1`
         echo $_INT $2
      fi
      INT=''
   else
      INT=$1
   fi
done
