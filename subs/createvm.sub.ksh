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

ip="$1"
if [ -z "$ip" ]
then
   ints=''
   for x in $(getMac | cut -d' ' -f2)
   do
      ints=$ints" "$x
   done
   set $ints
   int1=$1
   int2=$2

   cat /etc/netplan/50-cloud-init.yaml

   cat /etc/netplan/50-cloud-init.yaml | sed -e "s/$int1/##INT1##/g;s/$int2/##INT2##/g" | sed -e "s/##INT1##/$int2/g;s/##INT2##/$int1/g" > 50-cloud-init.yaml.tmp
   sudo cp 50-cloud-init.yaml.tmp /etc/netplan/50-cloud-init.yaml

   cat /etc/netplan/50-cloud-init.yaml
   rm 50-cloud-init.yaml.tmp

   sudo netplan apply
else
   ipnn="$1"
   defaultgw="$2"
   cat > 10-staticip.yaml.tmp << EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s2:
     dhcp4: no
     addresses: [$ipnn]
     routes:
       - to: 0.0.0.0/0
         via: $defaultgw
EOF
   sudo cp 10-staticip.yaml.tmp /etc/netplan/10-staticip.yaml
   sudo netplan apply
   rm 10-staticip.yaml.tmp
fi
