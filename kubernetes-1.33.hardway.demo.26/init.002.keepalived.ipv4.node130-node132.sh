#!/usr/bin/bash

function throw()
{
   errorCode=$?
   echo "Error: ($?) LINENO:$1"
   exit $errorCode
}

function check_error {
  if [ $? -ne 0 ]; then
    echo "Error: ($?) LINENO:$1"
    exit 1
  fi
}



export INTERFACE_KEEPALIVED="enp1s0.800"
export INTERFACE_KEEPALIVED_VIP="enp1s0.200"

export PASSWORD_KEEPALIVE="e470f126" #$(openssl rand -hex 4)
export OCTET_KEEPALIVE=24
export VIPIP_KEEPALIVE=192.168.200.139
export KEEPALIVED_NET="192.168.203"
export IP_KEEPALIVE=${VIPIP_KEEPALIVE}/${OCTET_KEEPALIVE}

apt install -y keepalived net-tools || throw ${LINENO}
mkdir -p /etc/keepalived/ || throw ${LINENO}


NODEID=$(hostname | awk '{print $1}' | sed 's|node||')
INTERNAL_IP=$(ifconfig ${INTERFACE_KEEPALIVED} | grep inet\   | awk '{print $2}')


cat <<EOF | sudo tee check_apiserver.sh-node${NODEID}
#!/bin/sh

errorExit() {
    echo "*** \$*" 1>&2
    exit 1
}

APISERVER_DEST_PORT=6443
APISERVER_VIP=${VIPIP_KEEPALIVE}
curl --silent --max-time 2 --insecure https://localhost:\${APISERVER_DEST_PORT}/ -o /dev/null || errorExit "Error GET https://localhost:\${APISERVER_DEST_PORT}/"
if ip addr | grep -q \${APISERVER_VIP}; then
    curl --silent --max-time 2 --insecure https://\${APISERVER_VIP}:\${APISERVER_DEST_PORT}/ -o /dev/null || errorExit "Error GET https://\${APISERVER_VIP}:\${APISERVER_DEST_PORT}/"
fi

EOF


cat <<EOF | sudo tee keepalived.conf-node${NODEID}



global_defs {
   router_id LVS_DEVEL
   script_user username [groupname]
   enable_script_security
}

vrrp_script check_apiserver {
   script "/etc/keepalived/check_apiserver.sh"
   # seconds between script invocations, (default: 1 second)
   interval 2

   # seconds after which script is considered to have failed
   # timeout <INTEGER>

   # required number of successes for KO transition
   fall 2       # require 2 failures for KO
   # required number of successes for OK transition
   rise 2       # require 2 successes for OK

   # adjust priority by this weight, (default: 0)
   # For description of reverse, see track_script.
   # 'weight 0 reverse' will cause the vrrp instance to be down when the
   # script is up, and vice versa.
   # weight <INTEGER:-253..253> [reverse]
   weight -100

   #  group default to group of user
   # user USERNAME [GROUPNAME]
   user root

}

vrrp_instance VI_1 {
    state MASTER
    interface ${INTERFACE_KEEPALIVED}
    virtual_router_id 50
    advert_int 1
    priority $((150-(${NODEID}-150)))
    authentication {
        auth_type AH
        auth_pass $PASSWORD_KEEPALIVE
    }
    virtual_ipaddress {
      ${IP_KEEPALIVE}  dev ${INTERFACE_KEEPALIVED_VIP} label ${INTERFACE_KEEPALIVED_VIP}:1
    }
    unicast_src_ip ${INTERNAL_IP}
    unicast_peer {
       $(if [ $NODEID -ne 130 ]; then echo "${KEEPALIVED_NET}.130";fi;)
       $(if [ $NODEID -ne 131 ]; then echo "${KEEPALIVED_NET}.131";fi;)
       $(if [ $NODEID -ne 132 ]; then echo "${KEEPALIVED_NET}.132";fi;)
    }
    track_script {
        check_apiserver
    }
}
EOF

cp check_apiserver.sh-node${NODEID}  /etc/keepalived/check_apiserver.sh || throw ${LINENO}
chmod 700 /etc/keepalived/check_apiserver.sh || throw ${LINENO}
cp keepalived.conf-node${NODEID} /etc/keepalived/keepalived.conf || throw ${LINENO}

systemctl enable keepalived || throw ${LINENO}
systemctl restart keepalived || throw ${LINENO}
systemctl status keepalived || throw ${LINENO}
ipvsadm -L -n || throw ${LINENO}
ifconfig ${INTERFACE_KEEPALIVED_VIP}:1 || throw ${LINENO}
