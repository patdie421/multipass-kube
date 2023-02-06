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

int1=`getMac | grep enp0s3 | cut -d' ' -f2`
int2=`getMac | grep enp0s8 | cut -d' ' -f2`

cat /etc/netplan/50-cloud-init.yaml

cat /etc/netplan/50-cloud-init.yaml | sed -e "s/$int1/##INT1##/g;s/$int2/##INT2##/g" | sed -e "s/##INT1##/$int2/g;s/##INT2##/$int1/g" > 50-cloud-init.yaml.tmp
sudo cp 50-cloud-init.yaml.tmp /etc/netplan/50-cloud-init.yaml

cat /etc/netplan/50-cloud-init.yaml
rm 50-cloud-init.yaml.tmp

sudo netplan apply
