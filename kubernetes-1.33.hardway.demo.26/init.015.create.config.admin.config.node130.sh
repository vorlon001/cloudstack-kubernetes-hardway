#!/usr/bin/bash

export NODEID=$(hostname | awk '{print $1}' | sed 's|node||')
export VIPIP_KEEPALIVE=192.168.200.139

export INTERFACE_KEEPALIVED_VIP="enp1s0.200"
export INTERNAL_IP=$(ifconfig ${INTERFACE_KEEPALIVED_VIP} | grep inet\   | awk '{print $2}')


echo "INIT /etc/kubernetes/admin.kubeconfig"
rm /etc/kubernetes/admin.kubeconfig

kubectl config set-cluster cluster.local \
     --certificate-authority=/etc/kubernetes/pki/ca.crt \
     --embed-certs=true \
     --server=https://${VIPIP_KEEPALIVE}:6443 \
     --kubeconfig=/etc/kubernetes/admin.kubeconfig


kubectl config set-context system:masters \
    --cluster=cluster.local \
    --user=system:masters \
    --kubeconfig=/etc/kubernetes/admin.kubeconfig

kubectl config set-credentials system:masters \
     --client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt \
     --client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key \
     --embed-certs=true \
     --kubeconfig=/etc/kubernetes/admin.kubeconfig

kubectl config use-context system:masters \
     --kubeconfig=/etc/kubernetes/admin.kubeconfig


mkdir /root/.kube
cp /etc/kubernetes/admin.kubeconfig /root/.kube/config
