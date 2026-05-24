#!/bin/sh

set -x
# ./kubeadm.amd64.v1.25.0 config images list
#https://storage.googleapis.com/kubernetes-release/release/v1.26.0-rc.0/bin/linux/amd64/kubelet

export kube_version="v1.36.1"
export kube_version2="1.36.1"
export crictl_version="v1.36.0"
export containerd_version="2.3.0"
export image_arch="amd64"
export runc_version="1.4.2"
export cni_version="1.9.1"
export k8s_regestry="harbor.iblog.pro/registry.k8s.io"
export etcd_version="3.6.11"
export kata_version="3.28.0"

wget -config=.wgetrc -q --show-progress --https-only --timestamping https://github.com/containerd/containerd/releases/download/v${containerd_version}/containerd-${containerd_version}-linux-amd64.tar.gz
wget -config=.wgetrc -q --show-progress --https-only --timestamping https://github.com/opencontainers/runc/releases/download/v${runc_version}/runc.${image_arch}
wget -config=.wgetrc -q --show-progress --https-only --timestamping https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
wget -config=.wgetrc -q --show-progress --https-only --timestamping https://github.com/containernetworking/plugins/releases/download/v${cni_version}/cni-plugins-linux-${image_arch}-v${cni_version}.tgz

#curl -o kubelet.${image_arch}.${kube_version} https://storage.googleapis.com/kubernetes-release/release/${kube_version}/bin/linux/${image_arch}/kubelet
#curl -o kubectl.${image_arch}.${kube_version} https://storage.googleapis.com/kubernetes-release/release/${kube_version}/bin/linux/${image_arch}/kubectl
#curl -o kubeadm.${image_arch}.${kube_version} https://storage.googleapis.com/kubernetes-release/release/${kube_version}/bin/linux/${image_arch}/kubeadm

wget -config=.wgetrc -q --show-progress --https-only --timestamping -O kubelet.${image_arch}.${kube_version} https://dl.k8s.io/${kube_version}/bin/linux/${image_arch}/kubelet
wget -config=.wgetrc -q --show-progress --https-only --timestamping -O kubectl.${image_arch}.${kube_version} https://dl.k8s.io/${kube_version}/bin/linux/${image_arch}/kubectl
wget -config=.wgetrc -q --show-progress --https-only --timestamping -O kubeadm.${image_arch}.${kube_version} https://dl.k8s.io/${kube_version}/bin/linux/${image_arch}/kubeadm

#https://dl.k8s.io/${kube_version}/bin/linux/${image_arch}/apiextensions-apiserver
#https://dl.k8s.io/${kube_version}/bin/linux/${image_arch}/kube-aggregator
#https://dl.k8s.io/${kube_version}/bin/linux/${image_arch}/kube-apiserver
#https://dl.k8s.io/${kube_version}/bin/linux/${image_arch}/kube-controller-manager
#https://dl.k8s.io/${kube_version}/bin/linux/${image_arch}/kube-log-runner
#https://dl.k8s.io/${kube_version}/bin/linux/${image_arch}/kube-proxy
#https://dl.k8s.io/${kube_version}/bin/linux/${image_arch}/kubeadm
#https://dl.k8s.io/${kube_version}/bin/linux/${image_arch}/kubectl
#https://dl.k8s.io/${kube_version}/bin/linux/${image_arch}/kubectl-convert
#https://dl.k8s.io/${kube_version}/bin/linux/${image_arch}/kubelet
#https://dl.k8s.io/${kube_version}/bin/linux/${image_arch}/mounter
#https://dl.k8s.io/${kube_version}/bin/linux/${image_arch}/kube-scheduler


wget -config=.wgetrc -q --show-progress --https-only --timestamping https://github.com/kubernetes-sigs/cri-tools/releases/download/${crictl_version}/crictl-${crictl_version}-linux-amd64.tar.gz

wget -config=.wgetrc -q --show-progress --https-only --timestamping https://github.com/cloudflare/cfssl/releases/download/v1.6.5/cfssl_1.6.5_linux_amd64 https://github.com/cloudflare/cfssl/releases/download/v1.6.5/cfssljson_1.6.5_linux_amd64

wget -config=.wgetrc -q --show-progress --https-only --timestamping https://github.com/etcd-io/etcd/releases/download/v${etcd_version}/etcd-v${etcd_version}-linux-${image_arch}.tar.gz


#wget -q --show-progress --https-only --timestamping -O kubernetes-server-linux-amd64.${kube_version2}.tar.gz https://storage.googleapis.com/kubernetes-release/release/v${kube_version2}/kubernetes-server-linux-amd64.tar.gz

wget -config=.wgetrc -q --show-progress --https-only --timestamping -O kubernetes-server-linux-amd64.${kube_version2}.tar.gz https://dl.k8s.io/v${kube_version2}/kubernetes-server-linux-amd64.tar.gz

# block чтобы не качал
#wget -config=.wgetrc -q --show-progress --https-only --timestamping -O kata-static-amd64-${kata_version}.tar.zst https://github.com/kata-containers/kata-containers/releases/download/${kata_version}/kata-static-${kata_version}-amd64.tar.zst
#zstd -dc kata-static-amd64-${kata_version}.tar.zst | gzip > kata-static-amd64-${kata_version}.tar.gz
#export kata_version="3.20.0"
#wget -config=.wgetrc -q --show-progress --https-only --timestamping -O kata-static-amd64.tar.xz https://github.com/kata-containers/kata-containers/releases/download/${kata_version}/kata-static-${kata_version}-amd64.tar.xz



(
  ARCH=$(uname -m)
  URL=https://storage.googleapis.com/gvisor/releases/release/latest/${ARCH}
  wget -config=.wgetrc ${URL}/runsc ${URL}/runsc.sha512 \
    ${URL}/containerd-shim-runsc-v1 ${URL}/containerd-shim-runsc-v1.sha512
  sha512sum -c runsc.sha512 \
    -c containerd-shim-runsc-v1.sha512
  rm -f *.sha512
  chmod a+rx runsc containerd-shim-runsc-v1
#  sudo mv runsc containerd-shim-runsc-v1 /usr/local/bin
)
