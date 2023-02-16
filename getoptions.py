import sys
import json
import argparse
import ipaddress
import re
 
def getArgs(api_description, api_epilog):
   parser=argparse.ArgumentParser(description=description, epilog=epilog, formatter_class=argparse.RawDescriptionHelpFormatter)
   parser.add_argument("-c", "--cfgfile", dest="cfgfile", metavar="FILE", help="", default="config.json")
   parser.add_argument("-V", "--getvm", dest="vmname", metavar="STRING", help="", default=False)
   parser.add_argument("-W", "--getworker", dest="workername", metavar="STRING", help="", default=False)
   parser.add_argument("-M", "--getmaster", dest="mastername", metavar="STRING", help="", default=False)
   parser.add_argument("-N", "--getnetwork", dest="networkname", metavar="STRING", help="", default=False)
   parser.add_argument("-v", "--listvms", action="store_true", dest="vms", help="", default=False)
   parser.add_argument("-m", "--listmasters", action="store_true", dest="masters", help="", default=False)
   parser.add_argument("-w", "--listworkers", action="store_true", dest="workers", help="", default=False)
   parser.add_argument("-n", "--listnetwors", action="store_true", dest="networks", help="", default=False)
   args,_args=parser.parse_known_args()
   return parser, args, _args
 
 
description='''
'''
epilog='''
'''
 
args_parser, args, _args = getArgs(description, epilog)
_m=args.masters
_w=args.workers
_n=args.networks
_v=args.vms
_W=bool(args.workername)
_M=bool(args.mastername)
_N=bool(args.networkname)
_V=bool(args.vmname)
if (_w + _m + _W + _M +_n + _N + _v + _V) > 1:
   raise TypeError('-v, -m, -w, -n, -V, -M, -W and -N are incompatible')
 
f = open(args.cfgfile)
data=json.load(f)
f.close()
 
index={}
masters=[]
workers=[]
nfsservers=[]
networks=[]
 
for i in data:
   if not i["name"] in index:
      index[i["name"]]=i
   else:
      raise TypeError('duplicated name: "'+ i["name"].lower()+'"')
   if i["function"].lower()=="master":
      masters.append(i["name"])
   elif i["function"].lower()=="worker":
      workers.append(i["name"])
   elif i["function"].lower()=="nfsserver":
      nfsservers.append(i["name"])
   elif i["function"].lower()=="network":
      networks.append(i["name"])
   else:
      raise TypeError('unknown function: "'+ i["function"].lower()+'"')
 
if args.masters == True:
   _masters=""
   for i in masters:
      _masters=_masters+" "+i
   print(_masters.strip())
   sys.exit(0)
 
if args.workers == True:
   _workers=""
   for i in workers:
      _workers=_workers+" "+i
   print(_workers.strip())
   sys.exit(0)
 
if args.networks == True:
   _networks=""
   for i in networks:
      _networks=_networks+" "+i
   print(_networks.strip())
   sys.exit(0)
 
if args.workername != False:
   if args.workername in workers:
      _worker=index[args.workername]["name"]+" "+str(index[args.workername]["cpus"])+" "+str(index[args.workername]["memory"])+" "+str(index[args.workername]["disk"])+" "+str(index[args.workername]["host"])
      print(_worker)
      sys.exit(0)
   else:
     raise TypeError('worker not found: "'+args.workername+'"')
 
if args.mastername != False:
   if args.mastername in masters:
      _master=index[args.mastername]["name"]+" "+str(index[args.mastername]["cpus"])+" "+str(index[args.mastername]["memory"])+" "+str(index[args.mastername]["disk"])+" "+str(index[args.mastername]["host"])
      print(_master)
      sys.exit(0)
   else:
      raise TypeError('master not found: "'+args.mastername+'"')
 
if args.networkname != False:
   if args.networkname in networks:
      net=ipaddress.ip_network(index[args.networkname]["servers_network"])
      _network=index[args.networkname]["servers_network"]+" "+str(net.broadcast_address)+" "+index[args.networkname]["CIDR"]+" "+re.escape(index[args.networkname]["CIDR"])+" "+index[args.networkname]["lbrange"]
      print(_network)
