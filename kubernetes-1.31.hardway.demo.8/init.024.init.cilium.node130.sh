#!/usr/bin/bash


cd /root/UTILS
./install.utils.sh

cd /root

# BGP VERSION

kubectl label node node140 bgp=zone1
kubectl label node node141 bgp=zone1
kubectl label node node142 bgp=zone1


cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: bgp-config
  namespace: kube-system
data:
  config.yaml: |
    address-pools:
      - name: default
        protocol: bgp
        addresses:
          - 11.0.0.0/24
      - name: default2
        protocol: bgp
        addresses:
        - 12.0.0.0-12.0.3.255
      - name: internet23
        protocol: bgp
        addresses:
        - 12.0.10.1-12.0.10.1
      - name: internet24
        protocol: bgp
        addresses:
        - 12.0.11.2-12.0.11.2
EOF

# WORK
helm repo add cilium https://helm.cilium.io/

# https://docs.cilium.io/en/stable/network/kubernetes/kubeproxy-free/#hybrid-dsr-and-snat-mode
# snat  dsr loadBalancer.mode

helm install cilium cilium/cilium --version 1.15.6  \
  --namespace kube-system  \
  --set tunnel=geneve   \
  --set kubeProxyReplacement=true \
  --set loadBalancer.mode=snat \
  --set loadBalancer.dsrDispatch=geneve \
  --set ipv4NativeRoutingCIDR=10.96.0.0/16 \
  --set ipam.operator.clusterPoolIPv4PodCIDRList="10.96.0.0/17" \
  --set ipam.operator.clusterPoolIPv4MaskSize="24" \
  --set k8sServiceHost=192.168.200.139 \
  --set k8sServicePort=6443 \
  --set bgpControlPlane.enabled=true \
  --set bgp.enabled=true \
  --set bgp.announce.loadbalancerIP=true \
  --set nodePort.enabled=true \
  --set bgp.announce.podCIDR=true
