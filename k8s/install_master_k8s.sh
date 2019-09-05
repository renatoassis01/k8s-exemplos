#! /bin/bash
kubeadm config images pull
kubeadm init --apiserver-advertise-address "$(hostname -i)"
mkdir -p "$HOME/.kube"
cp -i /etc/kubernetes/admin.conf "$HOME/.kube/config"
chown "$(id -u):$(id -g)" "$HOME/.kube/config"
modprobe br_filter ip_vs_rr ip_vs_wrr ip_vs_sh nf_contrack_ipv4 ip_vs
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"