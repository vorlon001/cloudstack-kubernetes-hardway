#!/usr/bin/bash

#wget https://storage.googleapis.com/kubernetes-release/release/v1.28.2/kubernetes-server-linux-amd64.tar.gz
export kube_version="v1.30.3"
export kube_version2="1.30.3"
export crictl_version="v1.30.1"
export containerd_version="1.7.20"
export image_arch="amd64"
export runc_version="1.1.13"
export cni_version="1.5.1"
export k8s_regestry="harbor.iblog.pro/registry.k8s.io"
export etcd_version="3.5.15"

cp /root/IMAGES/kubernetes-server-linux-amd64.${kube_version2}.tar.gz /root
tar -xf kubernetes-server-linux-amd64.${kube_version2}.tar.gz  --strip-components=3 -C /usr/local/bin kubernetes/server/bin/kube{let,ctl,-apiserver,-controller-manager,-scheduler,-proxy}

