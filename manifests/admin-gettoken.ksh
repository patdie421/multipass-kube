kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep kubeadmin | awk '{print $1}')
