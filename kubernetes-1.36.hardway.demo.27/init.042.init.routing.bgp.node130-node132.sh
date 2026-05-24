#!/usr/bin/bash

set -x

export DEBIAN_FRONTEND=noninteractive


# add GPG key
curl -s https://deb.frrouting.org/frr/keys.gpg | sudo tee /usr/share/keyrings/frrouting.gpg > /dev/null

# possible values for FRRVER: frr-6 frr-7 frr-8 frr-9 frr-9.0 frr-9.1 frr-10 frr10.0 frr10.1 frr-10.2 frr-10.3 frr-rc frr-stable
# frr-stable will be the latest official stable release. frr-rc is the latest release candidate in beta testing
FRRVER="frr-9.1"
echo deb '[signed-by=/usr/share/keyrings/frrouting.gpg]' https://deb.frrouting.org/frr \
     bookworm $FRRVER | sudo tee -a /etc/apt/sources.list.d/frr.list
# $(lsb_release -s -c)
# update and install FRR

apt list --all-versions frr
apt update
apt install frr=9.1.3-0~deb12u1 -y

sed -i "s/^bgpd=no/bgpd=yes/" /etc/frr/daemons
sed -i "s/^ospfd=no/ospfd=yes/" /etc/frr/daemons
sed -i "s/^ldpd=no/ldpd=yes/" /etc/frr/daemons
sed -i "s/^ospfd=no/ospfd=yes/" /etc/frr/daemons
sed -i "s/^bfdd=no/bfdd=yes/" /etc/frr/daemons
sed -i "s/^vrrpd=no/vrrpd=yes/" /etc/frr/daemons

# if frr in netns and not vrf
# nano /etc/frr/daemons

sed -i 's|zebra_options="  -A 127.0.0.1 -s 90000000"|zebra_options="  -A 127.0.0.1 -s 90000000 --vrfwnetns"|' /etc/frr/daemons


systemctl enable frr
systemctl restart frr
systemctl status frr
