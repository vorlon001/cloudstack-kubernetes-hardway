#!/usr/bin/bash

export NODEID=$(hostname | awk '{print $1}' | sed 's|node||')
export VIPIP_KEEPALIVE="127.0.0.1"
# 192.168.200.139

export INTERFACE_KEEPALIVED_VIP="enp1s0.200"
export INTERNAL_IP="127.0.0.1"
# $(ifconfig ${INTERFACE_KEEPALIVED_VIP} | grep inet\   | awk '{print $2}')

cat <<EOF>/var/lib/kubelet/config.yaml
allowedUnsafeSysctls:
- net.core.somaxconn
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    cacheTTL: 0s
    enabled: true
  x509:
    clientCAFile: /etc/kubernetes/pki/ca.crt
authorization:
  mode: Webhook
  webhook:
    cacheAuthorizedTTL: 0s
    cacheUnauthorizedTTL: 0s
cgroupDriver: systemd
cgroupsPerQOS: true
clusterDNS:
- 10.96.128.10
clusterDomain: cluster.local
containerLogMaxFiles: 5
containerLogMaxSize: 50Mi
containerRuntimeEndpoint: ""
cpuManagerReconcilePeriod: 0s
evictionHard:
  imagefs.available: 25%
  imagefs.inodesFree: 15%
  memory.available: 500Mi
  nodefs.available: 20%
  nodefs.inodesFree: 10%
evictionMaxPodGracePeriod: 300
evictionMinimumReclaim:
  imagefs.available: 2Gi
  memory.available: 0Mi
  nodefs.available: 500Mi
evictionPressureTransitionPeriod: 5m0s
evictionSoft:
  imagefs.available: 30%
  imagefs.inodesFree: 25%
  memory.available: 500Mi
  nodefs.available: 25%
  nodefs.inodesFree: 15%
evictionSoftGracePeriod:
  imagefs.available: 2m30s
  imagefs.inodesFree: 2m30s
  memory.available: 2m30s
  nodefs.available: 2m30s
  nodefs.inodesFree: 2m30s
fileCheckFrequency: 0s
hairpinMode: hairpin-veth
healthzBindAddress: 127.0.0.1
healthzPort: 10248
httpCheckFrequency: 0s
imageGCHighThresholdPercent: 55
imageGCLowThresholdPercent: 50
imageMaximumGCAge: 0s
imageMinimumGCAge: 0s
kind: KubeletConfiguration
kubeAPIBurst: 100
kubeAPIQPS: 50
kubeReserved:
  cpu: 500m
  ephemeral-storage: 3Gi
  memory: 500Mi
kubeletCgroups: /kubelet.slice
logging:
  flushFrequency: 0
  options:
    json:
      infoBufferSize: "0"
    text:
      infoBufferSize: "0"
  verbosity: 0
maxOpenFiles: 1000000
maxParallelImagePulls: 5
maxPods: 20
memorySwap: {}
memoryThrottlingFactor: 0.9
nodeStatusMaxImages: 50
nodeStatusReportFrequency: 20s
nodeStatusUpdateFrequency: 30s
podPidsLimit: 4096
podsPerCore: 5
registerNode: true
resolvConf: /run/systemd/resolve/resolv.conf
rotateCertificates: true
runtimeRequestTimeout: 0s
serializeImagePulls: false
shutdownGracePeriod: 15s
shutdownGracePeriodCriticalPods: 5s
staticPodPath: /etc/kubernetes/manifests
streamingConnectionIdleTimeout: 0s
syncFrequency: 0s
systemReserved:
  cpu: 500m
  ephemeral-storage: 1Gi
  memory: 1000Mi
tlsCipherSuites:
- TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
- TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
- TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
- TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
- TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256
- TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
tlsMinVersion: VersionTLS12
volumeStatsAggPeriod: 0s
EOF


echo "INIT /etc/kubernetes/kubelet.kubeconfig"

kubectl config set-cluster cluster.local \
     --certificate-authority=/etc/kubernetes/pki/ca.crt \
     --embed-certs=true \
     --server=https://${VIPIP_KEEPALIVE}:6443 \
     --kubeconfig=/etc/kubernetes/kubelet.kubeconfig


kubectl config set-context system:node:node${NODEID}@cluster.local \
    --cluster=cluster.local \
    --user=system:node:node${NODEID} \
    --kubeconfig=/etc/kubernetes/kubelet.kubeconfig

kubectl config set-credentials system:node:node${NODEID} \
     --client-certificate=//var/lib/kubelet/pki/kubelet-client.pem \
     --client-key=/var/lib/kubelet/pki/kubelet-client-key.pem \
     --embed-certs=true \
     --kubeconfig=/etc/kubernetes/kubelet.kubeconfig

kubectl config use-context system:node:node${NODEID}@cluster.local \
     --kubeconfig=/etc/kubernetes/kubelet.kubeconfig





rm /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

cat <<EOF>/lib/systemd/system/kubelet.service
[Unit]
Description=kubelet: The Kubernetes Node Agent
Documentation=https://kubernetes.io/docs/home/
Wants=network-online.target
After=network-online.target

[Service]
Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.kubeconfig"
Environment="KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml"
# This is a file that "kubeadm init" and "kubeadm join" generates at runtime, populating the KUBELET_KUBEADM_ARGS variable dynamically
EnvironmentFile=-/var/lib/kubelet/kubeadm-flags.env
# This is a file that the user can use for overrides of the kubelet args as a last resort. Preferably, the user should use
# the .NodeRegistration.KubeletExtraArgs object in the configuration files instead. KUBELET_EXTRA_ARGS should be sourced from this file.
EnvironmentFile=-/etc/default/kubelet
#ExecStart=
ExecStart=/usr/bin/kubelet \$KUBELET_KUBECONFIG_ARGS \$KUBELET_CONFIG_ARGS \$KUBELET_KUBEADM_ARGS \$KUBELET_EXTRA_ARGS
#ExecStart=/usr/bin/kubelet
Restart=always
StartLimitInterval=0
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl restart kubelet.service
systemctl status kubelet.service
