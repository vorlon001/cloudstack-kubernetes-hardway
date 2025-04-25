#!/usr/bin/bash


cd /root/UTILS
./install.utils.sh

cd /root

# BGP VERSION

kubectl label node node140 bgp200=zone200
kubectl label node node141 bgp200=zone200
kubectl label node node142 bgp200=zone200

kubectl label node node140 bgp400=zone400
kubectl label node node141 bgp400=zone400
kubectl label node node142 bgp400=zone400

kubectl label node node140 bgp600=zone600
kubectl label node node141 bgp600=zone600
kubectl label node node142 bgp600=zone600

kubectl label node node140 bgp800=zone800
kubectl label node node141 bgp800=zone800
kubectl label node node142 bgp800=zone800

# WORK
helm repo add cilium https://helm.cilium.io/

# https://docs.cilium.io/en/stable/network/kubernetes/kubeproxy-free/#hybrid-dsr-and-snat-mode
# snat  dsr loadBalancer.mode

helm install cilium cilium/cilium --version 1.17.1  \
  --namespace kube-system  \
  --set tunnelProtocol=geneve   \
  --set kubeProxyReplacement=true \
  --set loadBalancer.mode=snat \
  --set loadBalancer.dsrDispatch=geneve \
  --set ipv4NativeRoutingCIDR=10.96.0.0/16 \
  --set ipam.operator.clusterPoolIPv4PodCIDRList="10.96.0.0/17" \
  --set ipam.operator.clusterPoolIPv4MaskSize="24" \
  --set k8sServiceHost=192.168.200.139 \
  --set k8sServicePort=6443 \
  --set bgpControlPlane.enabled=true \
  --set bgp.enabled=false \
  --set nodePort.enabled=true
