#!/usr/bin/bash

#wget https://storage.googleapis.com/kubernetes-release/release/v1.28.2/kubernetes-server-linux-amd64.tar.gz

export kube_version="v1.31.2"
export kube_version2="1.31.2"
export crictl_version="v1.31.1"
export containerd_version="1.7.23"
export image_arch="amd64"
export runc_version="1.2.0"
export cni_version="1.6.0"
export k8s_regestry="harbor.iblog.pro/registry.k8s.io"
export etcd_version="3.5.16"


cp /root/IMAGES/kubernetes-server-linux-amd64.${kube_version2}.tar.gz /root
tar -xf kubernetes-server-linux-amd64.${kube_version2}.tar.gz  --strip-components=3 -C /usr/local/bin kubernetes/server/bin/kube{let,ctl,-apiserver,-controller-manager,-scheduler,-proxy}


apt install -y haproxy


cat <<EOF>/etc/haproxy/haproxy.cfg
global
    maxconn 4000
    log 127.0.0.1 local0
    chroot /var/lib/haproxy
    stats socket /run/haproxy/admin.sock mode 660 level admin
    stats timeout 30s
    user haproxy
    group haproxy
    daemon

defaults
    mode                    http
    log                     global
    option                  httplog
    option                  dontlognull
    option                  http-server-close
    option                  redispatch
    retries                 5
    timeout http-request    5m
    timeout queue           5m
    timeout connect         30s
    timeout client          60s
    timeout server          15m
    timeout http-keep-alive 30s
    timeout check           5s
    maxconn                 4000

frontend healthz
  bind 0.0.0.0:6666
  mode http
  monitor-uri /healthz

frontend kube_api_frontend
    bind 0.0.0.0:6443
    mode tcp
    option tcplog
    use_backend kube_api_backend

backend kube_api_backend
    mode tcp
    balance leastconn
    default-server inter 15s downinter 15s rise 2 fall 2 slowstart 60s maxconn 1000 maxqueue 256 weight 100
    option httpchk GET /healthz
    http-check expect status 200
    server kube-api-0 192.168.200.130:16443 check check-ssl verify none
    server kube-api-1 192.168.200.131:16443 check check-ssl verify none
    server kube-api-2 192.168.200.132:16443 check check-ssl verify none

frontend stats
        bind *:8888
        stats enable
        stats auth root:Vajra@2020
        stats refresh 60s
        stats uri /haproxy?stats
        stats refresh 5s
        stats show-node
        stats show-legends
        stats hide-version
EOF


systemctl restart haproxy
systemctl status haproxy
