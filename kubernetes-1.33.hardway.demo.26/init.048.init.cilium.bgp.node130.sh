#!/usr/bin/bash


cat <<EOF | kubectl apply -f -
---
apiVersion: "cilium.io/v2alpha1"
kind: CiliumLoadBalancerIPPool
metadata:
  name: "vlan200"
spec:
  blocks:
#  - cidr: "192.168.200.0/24"
  - start: "192.168.200.40"
    stop: "192.168.200.50"
  serviceSelector:
    matchLabels:
      color: vlan200
---
apiVersion: "cilium.io/v2alpha1"
kind: CiliumLoadBalancerIPPool
metadata:
  name: "vlan400"
spec:
  blocks:
#  - cidr: "192.168.200.0/24"
  - start: "192.168.201.40"
    stop: "192.168.201.50"
  serviceSelector:
    matchLabels:
      color: vlan400
---
apiVersion: "cilium.io/v2alpha1"
kind: CiliumLoadBalancerIPPool
metadata:
  name: "vlan600"
spec:
  blocks:
#  - cidr: "192.168.200.0/24"
  - start: "192.168.202.40"
    stop: "192.168.202.50"
  serviceSelector:
    matchLabels:
      color: vlan600
---
apiVersion: "cilium.io/v2alpha1"
kind: CiliumLoadBalancerIPPool
metadata:
  name: "vlan800"
spec:
  blocks:
#  - cidr: "192.168.200.0/24"
  - start: "192.168.203.40"
    stop: "192.168.203.50"
  serviceSelector:
    matchLabels:
      color: vlan800
EOF


cat <<EOF | kubectl apply -f -
---
apiVersion: cilium.io/v2alpha1
kind: CiliumBGPAdvertisement
metadata:
  name: vlan200
  labels:
    advertise: vlan200
spec:
  advertisements:
    - advertisementType: "PodCIDR"
      selector:
        matchExpressions:
         - {key: somekey, operator: NotIn, values: ['never-used-value']}
    - advertisementType: "Service"
      service:
        addresses:
          - ClusterIP
          - ExternalIP
          - LoadBalancerIP
      selector:
        matchLabels:
          color: vlan200
---
apiVersion: cilium.io/v2alpha1
kind: CiliumBGPAdvertisement
metadata:
  name: vlan400
  labels:
    advertise: vlan400
spec:
  advertisements:
    - advertisementType: "PodCIDR"
      selector:
        matchExpressions:
         - {key: somekey, operator: NotIn, values: ['never-used-value']}
    - advertisementType: "Service"
      service:
        addresses:
          - ClusterIP
          - ExternalIP
          - LoadBalancerIP
      selector:
        matchLabels:
          color: vlan400
---
apiVersion: cilium.io/v2alpha1
kind: CiliumBGPAdvertisement
metadata:
  name: vlan600
  labels:
    advertise: vlan600
spec:
  advertisements:
    - advertisementType: "Service"
      service:
        addresses:
          - LoadBalancerIP
      selector:
        matchLabels:
          color: vlan600
---
apiVersion: cilium.io/v2alpha1
kind: CiliumBGPAdvertisement
metadata:
  name: vlan800
  labels:
    advertise: vlan800
spec:
  advertisements:
    - advertisementType: "Service"
      service:
        addresses:
          - LoadBalancerIP
      selector:
        matchLabels:
          color: vlan800
EOF



cat <<EOF | kubectl apply -f -
---
apiVersion: cilium.io/v2alpha1
kind: CiliumBGPPeerConfig
metadata:
  name: vlan200
spec:
  ebgpMultihop: 1
  families:
  - advertisements:
      matchLabels:
        advertise: vlan200
    afi: ipv4
    safi: unicast
  gracefulRestart:
    enabled: true
    restartTimeSeconds: 15
  timers:
    connectRetryTimeSeconds: 120
    holdTimeSeconds: 9
    keepAliveTimeSeconds: 3
---
apiVersion: cilium.io/v2alpha1
kind: CiliumBGPPeerConfig
metadata:
  name: vlan400
spec:
  ebgpMultihop: 1
  families:
  - advertisements:
      matchLabels:
        advertise: vlan400
    afi: ipv4
    safi: unicast
  gracefulRestart:
    enabled: true
    restartTimeSeconds: 15
  timers:
    connectRetryTimeSeconds: 120
    holdTimeSeconds: 9
    keepAliveTimeSeconds: 3
---
apiVersion: cilium.io/v2alpha1
kind: CiliumBGPPeerConfig
metadata:
  name: vlan600
spec:
  ebgpMultihop: 1
  families:
  - advertisements:
      matchLabels:
        advertise: vlan600
    afi: ipv4
    safi: unicast
  gracefulRestart:
    enabled: true
    restartTimeSeconds: 15
  timers:
    connectRetryTimeSeconds: 120
    holdTimeSeconds: 9
    keepAliveTimeSeconds: 3
---
apiVersion: cilium.io/v2alpha1
kind: CiliumBGPPeerConfig
metadata:
  name: vlan800
spec:
  ebgpMultihop: 1
  families:
  - advertisements:
      matchLabels:
        advertise: vlan800
    afi: ipv4
    safi: unicast
  gracefulRestart:
    enabled: true
    restartTimeSeconds: 15
  timers:
    connectRetryTimeSeconds: 120
    holdTimeSeconds: 9
    keepAliveTimeSeconds: 3
EOF




cat <<EOF | kubectl apply -f -
apiVersion: cilium.io/v2alpha1
kind: CiliumBGPClusterConfig
metadata:
  labels:
    app.kubernetes.io/instance: cilium
  name: worker-nodes
spec:
  bgpInstances:
  - localASN: 65000
    name: vlan200
    peers:
    - name: node130
      peerASN: 65000
      peerAddress: 192.168.200.130
      peerConfigRef:
        group: cilium.io
        kind: CiliumBGPPeerConfig
        name: vlan200
    - name: node130-vlan400
      peerASN: 65000
      peerAddress: 192.168.201.130
      peerConfigRef:
        group: cilium.io
        kind: CiliumBGPPeerConfig
        name: vlan400
    - name: node130-vlan600
      peerASN: 65000
      peerAddress: 192.168.202.130
      peerConfigRef:
        group: cilium.io
        kind: CiliumBGPPeerConfig
        name: vlan600
    - name: node130-vlan800
      peerASN: 65000
      peerAddress: 192.168.203.130
      peerConfigRef:
        group: cilium.io
        kind: CiliumBGPPeerConfig
        name: vlan800
    - name: node131
      peerASN: 65000
      peerAddress: 192.168.200.131
      peerConfigRef:
        group: cilium.io
        kind: CiliumBGPPeerConfig
        name: vlan200
    - name: node131-vlan400
      peerASN: 65000
      peerAddress: 192.168.201.131
      peerConfigRef:
        group: cilium.io
        kind: CiliumBGPPeerConfig
        name: vlan400
    - name: node131-vlan600
      peerASN: 65000
      peerAddress: 192.168.202.131
      peerConfigRef:
        group: cilium.io
        kind: CiliumBGPPeerConfig
        name: vlan600
    - name: node131-vlan800
      peerASN: 65000
      peerAddress: 192.168.203.131
      peerConfigRef:
        group: cilium.io
        kind: CiliumBGPPeerConfig
        name: vlan800
    - name: node132
      peerASN: 65000
      peerAddress: 192.168.200.132
      peerConfigRef:
        group: cilium.io
        kind: CiliumBGPPeerConfig
        name: vlan200
    - name: node132-vlan400
      peerASN: 65000
      peerAddress: 192.168.201.132
      peerConfigRef:
        group: cilium.io
        kind: CiliumBGPPeerConfig
        name: vlan400
    - name: node132-vlan600
      peerASN: 65000
      peerAddress: 192.168.202.132
      peerConfigRef:
        group: cilium.io
        kind: CiliumBGPPeerConfig
        name: vlan600
    - name: node132-vlan800
      peerASN: 65000
      peerAddress: 192.168.203.132
      peerConfigRef:
        group: cilium.io
        kind: CiliumBGPPeerConfig
        name: vlan800
  nodeSelector:
    matchExpressions:
    - key: node-role.kubernetes.io/control-plane
      operator: DoesNotExist
EOF


kubectl rollout restart -n kube-system daemonset cilium
kubectl get pod -n kube-system  -o wide
