#! /bin/bash
set -euo -pipefail
apt-get update -y && apt-get upgrade -y
apt-get install apt-transport-https
curl -fsSL https://get.docker.com | bash
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > \
/etc/apt/sources.list.d/kubernetes.list
apt-get update -y && apt-get install kubelet kubeadm kubectl
docker info | grep -i cgroup
sed -i "s/cgroup-drive=systemd/cgroup-driver=cgroupfs/g" \
/etc/systemd/system/kubelet.service.d/10-kubeadm.conf
systemctl daemon-reload
systemctl restart kubelet
swapoff -a
sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab
