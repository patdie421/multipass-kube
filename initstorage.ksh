source fns/functions.ksh
source fns/init.ksh

# https://github.com/kubernetes-csi

curl -skSL https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/v4.1.0/deploy/install-driver.sh | bash -s v4.1.0 --
kubectl apply -f manifests/nfscsi-storageclass.yaml
