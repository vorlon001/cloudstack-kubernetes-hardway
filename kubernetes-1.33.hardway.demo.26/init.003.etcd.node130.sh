#!/usr/bin/bash

set -x 
apt install -y sshpass pdsh moreutils

cat > ~/.ssh/config <<EOF
Host node130
    Hostname node130.cloud.local
    StrictHostKeyChecking no
    User root
Host node131
    Hostname node131.cloud.local
    StrictHostKeyChecking no
    User root
Host node132
    Hostname node132.cloud.local
    StrictHostKeyChecking no
    User root
Host 192.168.200.130
    Hostname 192.168.200.130
    StrictHostKeyChecking no
    User root
Host 192.168.200.131
    Hostname 192.168.200.131
    StrictHostKeyChecking no
    User root
Host 192.168.200.132
    Hostname 192.168.200.132
    StrictHostKeyChecking no
    User root

Host 192.168.200.140
    Hostname 192.168.200.140
    StrictHostKeyChecking no
    User root
Host 192.168.200.141
    Hostname 192.168.200.141
    StrictHostKeyChecking no
    User root
Host 192.168.200.142
    Hostname 192.168.200.142
    StrictHostKeyChecking no
    User root

EOF


chmod 600 ~/.ssh/config


echo root >password.node
sshpass -f password.node  ssh-copy-id 192.168.200.130
sshpass -f password.node  ssh-copy-id 192.168.200.131
sshpass -f password.node  ssh-copy-id 192.168.200.132

sshpass -f password.node  ssh-copy-id 192.168.200.140
sshpass -f password.node  ssh-copy-id 192.168.200.141
sshpass -f password.node  ssh-copy-id 192.168.200.142

# ##############################################################################################################################


NODE_ETCD=( 0 1 2 )
NAME_NODE_ETCD=( NODE130 NODE131 NODE132 )

mkdir /root/init.etcd
cd /root/init.etcd

# STEP-1


# wget -q --show-progress --https-only --timestamping https://github.com/cloudflare/cfssl/releases/download/v1.6.5/cfssl_1.6.5_linux_amd64 https://github.com/cloudflare/cfssl/releases/download/v1.6.5/cfssljson_1.6.5_linux_amd64
# chmod +x cfssl_1.6.5_linux_amd64 cfssljson_1.6.5_linux_amd64

cp /root/IMAGES/cfssl_1.6.5_linux_amd64 /usr/local/bin/cfssl
cp /root/IMAGES/cfssljson_1.6.5_linux_amd64 /usr/local/bin/cfssljson
chmod +x /usr/local/bin/cfss*

# STEP-2

cat > ca-config.json <<EOF
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}
EOF

cat > ca-csr.json <<EOF
{
  "CN": "etcd-ca",
  "key": {
    "algo": "ecdsa",
    "size": 256
  },
  "names": [
    {
      "C": "RU",
      "L": "URAL",
      "O": "Kubernetes",
      "OU": "CA",
      "ST": "Yekaterinburg"
    }
  ]
}
EOF

cfssl gencert -initca ca-csr.json | cfssljson -bare ca

ls -la

KUBERNETES_HOSTNAMES=kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.svc.cluster.local


for i in {130..132}; do

cat > server-csr-node${i}.json <<EOF
{
  "CN": "node${i}.cloud.local",
  "key": {
    "algo": "ecdsa",
    "size": 256
  },
  "names": [
    {
      "C": "RU",
      "L": "URAL",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Yekaterinburg"
    }
  ]
}
EOF

cat > peer-csr-node${i}.json <<EOF
{
  "CN": "node${i}.cloud.local",
  "key": {
    "algo": "ecdsa",
    "size": 256
  },
  "names": [
    {
      "C": "RU",
      "L": "URAL",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Yekaterinburg"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=node${i}.cloud.local,node${i},192.168.200.${i},127.0.0.1,localhost \
  -profile=kubernetes \
  server-csr-node${i}.json | cfssljson -bare server-node${i}

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=node${i}.cloud.local,node${i},192.168.200.${i},127.0.0.1,localhost \
  -profile=kubernetes \
  peer-csr-node${i}.json | cfssljson -bare peer-node${i}

done



cat > apiserver-csr.json <<EOF
{
  "CN": "kube-apiserver-etcd-client",
  "key": {
    "algo": "ecdsa",
    "size": 256
  },
  "names": [
    {
      "C": "RU",
      "L": "URAL",
      "O": "system:masters",
      "OU": "Kubernetes The Hard Way",
      "ST": "Yekaterinburg"
    }
  ]
}
EOF



ETCD_ACCESS=""
for Item in "${NODE_ETCD[@]}"
do
    ETCD_ACCESS+="node13${Item}.cloud.local,node13${Item},192.168.200.13${Item}"
    if [[ ${Item} -ne "${NODE_ETCD[ $((${#NODE_ETCD[@]}-1)) ]}" ]]
    then
        ETCD_ACCESS+=","
    fi
done
echo $ETCD_ACCESS

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=${ETCD_ACCESS},127.0.0.1,${KUBERNETES_HOSTNAMES} \
  -profile=kubernetes \
  apiserver-csr.json | cfssljson -bare apiserver

ls -la



for i in {130..132}; do

pdsh -R ssh -w root@192.168.200.${i} "mkdir -p /etc/etcd"
pdsh -R ssh -w root@192.168.200.${i} "mkdir -p /var/lib/etcd"
pdsh -R ssh -w root@192.168.200.${i} "chmod 700 /var/lib/etcd"
pdsh -R ssh -w root@192.168.200.${i} "ls -la"


scp -r /root/init.etcd/ca-key.pem root@192.168.200.${i}:/etc/etcd
scp -r /root/init.etcd/ca.pem root@192.168.200.${i}:/etc/etcd

scp -r /root/init.etcd/server-node${i}.pem root@192.168.200.${i}:/etc/etcd/server.pem
scp -r /root/init.etcd/server-node${i}-key.pem root@192.168.200.${i}:/etc/etcd/server-key.pem

scp -r /root/init.etcd/peer-node${i}.pem root@192.168.200.${i}:/etc/etcd/peer.pem
scp -r /root/init.etcd/peer-node${i}-key.pem root@192.168.200.${i}:/etc/etcd/peer-key.pem

pdsh -R ssh -w root@192.168.200.${i} "ls -la /etc/etcd/"

scp /root/IMAGES/etcd-v3.5.21-linux-amd64.tar.gz root@192.168.200.${i}:/root
#pdsh -R ssh -w root@192.168.200.${i} "wget -q --show-progress --https-only --timestamping 'https://github.com/etcd-io/etcd/releases/download/v3.5.15/etcd-v3.5.13-linux-amd64.tar.gz'"
pdsh -R ssh -w root@192.168.200.${i} "tar -xvf /root/etcd-v3.5.21-linux-amd64.tar.gz"
pdsh -R ssh -w root@192.168.200.${i} "sudo mv /root/etcd-v3.5.21-linux-amd64/etcd* /usr/local/bin/"



done

ETCD_CLUSTER=""
for Item in "${NODE_ETCD[@]}"
do
    ETCD_CLUSTER+="NODE13${Item}=https://192.168.200.13${Item}:2380"
    if [[ ${Item} -ne "${NODE_ETCD[ $((${#NODE_ETCD[@]}-1)) ]}" ]]
    then
        ETCD_CLUSTER+=","
    fi
done
echo $ETCD_CLUSTER



for Item in 0 1 2;
  do
    echo $Item
    INTERNAL_IP=192.168.200.13${Item}
    ETCD_NAME=NODE13${Item}

cat <<EOF | sudo tee etcd.service-node13${Item}

[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
Type=notify
ExecStart=/usr/local/bin/etcd \\
  --name ${ETCD_NAME} \\
  --cert-file=/etc/etcd/server.pem \\
  --key-file=/etc/etcd/server-key.pem \\
  --peer-cert-file=/etc/etcd/peer.pem \\
  --peer-key-file=/etc/etcd/peer-key.pem \\
  --trusted-ca-file=/etc/etcd/ca.pem \\
  --peer-trusted-ca-file=/etc/etcd/ca.pem \\
  --peer-client-cert-auth \\
  --client-cert-auth \\
  --initial-advertise-peer-urls https://${INTERNAL_IP}:2380 \\
  --listen-peer-urls https://${INTERNAL_IP}:2380 \\
  --listen-client-urls https://${INTERNAL_IP}:2379,https://127.0.0.1:2379 \\
  --advertise-client-urls https://${INTERNAL_IP}:2379 \\
  --initial-cluster-token etcd-cluster-0 \\
  --initial-cluster ${ETCD_CLUSTER} \\
  --initial-cluster-state new \\
  --snapshot-count=10000 \\
  --max-snapshots=5 \\
  --max-wals=5 \\
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
done


for Item in 0 1 2;
  do
    scp etcd.service-node13${Item} root@192.168.200.13${Item}:/etc/systemd/system/etcd.service
done

pdsh -R ssh -w root@192.168.200.13[0-2] "sudo systemctl daemon-reload"
pdsh -R ssh -w root@192.168.200.13[0-2] "sudo systemctl enable etcd"
pdsh -R ssh -w root@192.168.200.13[0-2] "sudo systemctl start etcd"
pdsh -R ssh -w root@192.168.200.13[0-2] "sudo systemctl status etcd"


sleep 20


pdsh -R ssh -w root@192.168.200.13[0-2] "ETCDCTL_API=3 etcdctl member list --endpoints=https://127.0.0.1:2379 --cacert=/etc/etcd/ca.pem --cert=/etc/etcd/server.pem --key=/etc/etcd/server-key.pem"


pdsh -R ssh -w root@192.168.200.13[0-2] "ETCDCTL_API=3 etcdctl endpoint health --cluster --endpoints=https://127.0.0.1:2379 --cacert=/etc/etcd/ca.pem --cert=/etc/etcd/server.pem --key=/etc/etcd/server-key.pem"

pdsh -R ssh -w root@192.168.200.13[0-2] "systemctl status etcd"

pdsh -R ssh -w root@192.168.200.13[0-2] "ETCDCTL_API=3 etcdctl endpoint status --cluster --endpoints=https://127.0.0.1:2379 --cacert=/etc/etcd/ca.pem --cert=/etc/etcd/server.pem --key=/etc/etcd/server-key.pem"

pdsh -R ssh -w root@192.168.200.13[0-2] "ETCDCTL_API=3 etcdctl endpoint status --cluster --endpoints=https://127.0.0.1:2379 --cacert=/etc/etcd/ca.pem --cert=/etc/etcd/server.pem --key=/etc/etcd/server-key.pem  --write-out=table"
