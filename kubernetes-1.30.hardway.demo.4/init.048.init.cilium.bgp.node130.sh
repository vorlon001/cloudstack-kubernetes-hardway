#!/usr/bin/bash


kubectl delete node node130
kubectl delete node node131
kubectl delete node node132

# BGP VERSION

kubectl label node node140 bgp=zone1
kubectl label node node141 bgp=zone1
kubectl label node node142 bgp=zone1


cat <<EOF | kubectl apply -f -
apiVersion: cilium.io/v2alpha1
kind: CiliumBGPPeeringPolicy
metadata:
  name: vyos
spec:
  nodeSelector:
    matchLabels:
      bgp: zone1
  virtualRouters:
  - localASN: 65000
    exportPodCIDR: true
    neighbors:
    - peerASN: 65000
      peerAddress: 192.168.200.130/32
    - peerASN: 65000
      peerAddress: 192.168.200.131/32
    - peerASN: 65000
      peerAddress: 192.168.200.132/32
    serviceSelector:
      matchExpressions:
      - key: somekey
        operator: NotIn
        values:
        - never-used-value
EOF


kubectl rollout restart -n kube-system daemonset cilium
kubectl get pod -n kube-system  -o wide
