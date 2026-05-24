#!/usr/bin/bash

mkdir -p /etc/kubernetes/policies/
cp audit-policy.yaml /etc/kubernetes/policies/

cp /root/init.etcd/apiserver.pem /etc/kubernetes/pki/apiserver-etcd.pem
cp /root/init.etcd/apiserver-key.pem /etc/kubernetes/pki/apiserver-etcd-key.pem

ssh 192.168.200.131 mkdir -p /etc/kubernetes/pki/
ssh 192.168.200.132 mkdir -p /etc/kubernetes/pki/

#scp /etc/kubernetes/controller-manager.conf 192.168.200.131://etc/kubernetes/controller-manager.conf
#scp /etc/kubernetes/controller-manager.conf 192.168.200.132://etc/kubernetes/controller-manager.conf

#scp /etc/kubernetes/scheduler.conf 192.168.200.131://etc/kubernetes/scheduler.conf
#scp /etc/kubernetes/scheduler.conf 192.168.200.132://etc/kubernetes/scheduler.conf

scp /etc/kubernetes/pki/apiserver.crt 192.168.200.131://etc/kubernetes/pki/apiserver.crt
scp /etc/kubernetes/pki/apiserver.crt 192.168.200.132://etc/kubernetes/pki/apiserver.crt

scp /etc/kubernetes/pki/apiserver.key 192.168.200.131://etc/kubernetes/pki/apiserver.key
scp /etc/kubernetes/pki/apiserver.key 192.168.200.132://etc/kubernetes/pki/apiserver.key

scp /etc/kubernetes/pki/apiserver-kubelet-client* 192.168.200.131://etc/kubernetes/pki/
scp /etc/kubernetes/pki/apiserver-kubelet-client* 192.168.200.132://etc/kubernetes/pki/

scp /etc/kubernetes/pki/front-proxy-clie* 192.168.200.131://etc/kubernetes/pki/
scp /etc/kubernetes/pki/front-proxy-clie* 192.168.200.132://etc/kubernetes/pki/

scp /etc/kubernetes/pki/front-proxy-ca* 192.168.200.131://etc/kubernetes/pki/
scp /etc/kubernetes/pki/front-proxy-ca* 192.168.200.132://etc/kubernetes/pki/

scp /etc/kubernetes/pki/sa* 192.168.200.131://etc/kubernetes/pki/
scp /etc/kubernetes/pki/sa* 192.168.200.132://etc/kubernetes/pki/

scp /etc/kubernetes/pki/ca* 192.168.200.131://etc/kubernetes/pki/
scp /etc/kubernetes/pki/ca* 192.168.200.132://etc/kubernetes/pki/

ssh 192.168.200.131 mkdir -p /etc/kubernetes/policies/
scp /etc/kubernetes/policies/audit-policy.yaml 192.168.200.131://etc/kubernetes/policies/

ssh 192.168.200.132 mkdir -p /etc/kubernetes/policies/
scp /etc/kubernetes/policies/audit-policy.yaml 192.168.200.132://etc/kubernetes/policies/

scp /etc/kubernetes/pki/apiserver-etcd* 192.168.200.131://etc/kubernetes/pki/
scp /etc/kubernetes/pki/apiserver-etcd* 192.168.200.132://etc/kubernetes/pki/

#scp /etc/kubernetes/admin.conf 192.168.200.131://etc/kubernetes/admin.conf
#scp /etc/kubernetes/admin.conf 192.168.200.132://etc/kubernetes/admin.conf


scp /etc/kubernetes/pki/scheduler* 192.168.200.131://etc/kubernetes/pki/
scp /etc/kubernetes/pki/controller* 192.168.200.131://etc/kubernetes/pki/

scp /etc/kubernetes/pki/scheduler* 192.168.200.132://etc/kubernetes/pki/
scp /etc/kubernetes/pki/controller* 192.168.200.132://etc/kubernetes/pki/

scp /etc/kubernetes/pki/kube-proxy.* 192.168.200.131:/etc/kubernetes/pki
scp /etc/kubernetes/pki/kube-proxy.* 192.168.200.132:/etc/kubernetes/pki


#ssh 192.168.200.170 mkdir /root/.kube
#scp /etc/kubernetes/admin.conf 192.168.200.170://root/.kube/config



ssh 192.168.200.140 mkdir -p /etc/kubernetes/pki/
ssh 192.168.200.141 mkdir -p /etc/kubernetes/pki/
ssh 192.168.200.142 mkdir -p /etc/kubernetes/pki/



scp /etc/kubernetes/pki/ca.crt 192.168.200.140://etc/kubernetes/pki/
scp /etc/kubernetes/pki/ca.crt 192.168.200.141://etc/kubernetes/pki/
scp /etc/kubernetes/pki/ca.crt 192.168.200.142://etc/kubernetes/pki/

