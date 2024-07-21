```shell

array=( 130 131 132 140 141 142 )
for i in "${array[@]}"
do
  scp -r * root@192.168.200.${i}:.
done

node130,node131,node132,node140,node141,node142 - Denian 12


master node: node130,node131,node132
worker node: node140,node141,node142

root@node130:~# ./init.016.test.sh
NAME           STATUS   ROLES    AGE   VERSION   INTERNAL-IP       EXTERNAL-IP   OS-IMAGE                         KERNEL-VERSION   CONTAINER-RUNTIME
node/node140   Ready    <none>   12m   v1.30.0   192.168.200.140   <none>        Debian GNU/Linux 12 (bookworm)   6.1.0-20-amd64   containerd://1.7.15
node/node141   Ready    <none>   12m   v1.30.0   192.168.200.141   <none>        Debian GNU/Linux 12 (bookworm)   6.1.0-20-amd64   containerd://1.7.15
node/node142   Ready    <none>   12m   v1.30.0   192.168.200.142   <none>        Debian GNU/Linux 12 (bookworm)   6.1.0-20-amd64   containerd://1.7.15

NAMESPACE     NAME                                          READY   STATUS    RESTARTS   AGE     IP                NODE      NOMINATED NODE   READINESS GATES
kube-system   pod/cilium-9xt4t                              1/1     Running   0          6m36s   192.168.200.140   node140   <none>           <none>
kube-system   pod/cilium-operator-5dc46cb5f4-5jc4t          1/1     Running   0          8m7s    192.168.200.142   node142   <none>           <none>
kube-system   pod/cilium-operator-5dc46cb5f4-t5pz4          1/1     Running   0          8m7s    192.168.200.140   node140   <none>           <none>
kube-system   pod/cilium-qq55r                              1/1     Running   0          6m36s   192.168.200.141   node141   <none>           <none>
kube-system   pod/cilium-x9v5f                              1/1     Running   0          6m25s   192.168.200.142   node142   <none>           <none>
kube-system   pod/coredns-75f457ddbb-d456c                  1/1     Running   0          8m16s   10.96.2.164       node140   <none>           <none>
kube-system   pod/coredns-75f457ddbb-wb4zz                  1/1     Running   0          8m16s   10.96.2.76        node140   <none>           <none>
nfs-client    pod/nfs-client-provisioner-77c5b7fdd8-qrb62   1/1     Running   0          5m58s   10.96.0.59        node141   <none>           <none>
test-kube-0   pod/mysql80-6dc4fdb9fb-tgl4d                  1/1     Running   0          5m56s   10.96.1.192       node142   <none>           <none>
test-kube-0   pod/postgres13-0                              1/1     Running   0          5m56s   10.96.1.230       node142   <none>           <none>
test-kube-0   pod/postgres13-1                              1/1     Running   0          5m44s   10.96.2.67        node140   <none>           <none>
test-kube-0   pod/postgres13-2                              1/1     Running   0          5m37s   10.96.0.44        node141   <none>           <none>
test-kube-0   pod/postgres13-3                              1/1     Running   0          5m33s   10.96.2.212       node140   <none>           <none>
test-kube-0   pod/postgres13-4                              1/1     Running   0          5m31s   10.96.1.143       node142   <none>           <none>
test-kube-0   pod/postgres13-5cc6cc74d8-4k5ff               1/1     Running   0          5m56s   10.96.0.132       node141   <none>           <none>
test-kube-0   pod/web-0                                     1/1     Running   0          5m56s   10.96.1.101       node142   <none>           <none>
test-kube-0   pod/web-1                                     1/1     Running   0          5m47s   10.96.0.32        node141   <none>           <none>
test-kube-0   pod/web-2                                     1/1     Running   0          5m43s   10.96.1.88        node142   <none>           <none>
test-kube-0   pod/web-3                                     1/1     Running   0          5m41s   10.96.2.64        node140   <none>           <none>
test-kube-0   pod/web-4                                     1/1     Running   0          5m38s   10.96.0.173       node141   <none>           <none>
test-kube-0   pod/web-5                                     1/1     Running   0          5m34s   10.96.1.231       node142   <none>           <none>
test-kube-0   pod/web10-0                                   1/1     Running   0          5m56s   10.96.0.191       node141   <none>           <none>
test-kube-0   pod/web10-1                                   1/1     Running   0          5m51s   10.96.2.38        node140   <none>           <none>

root@node130:~# kubectl get svc -A
NAMESPACE     NAME                 TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                  AGE
default       kubernetes           ClusterIP      10.96.128.1     <none>        443/TCP                  16m
kube-system   hubble-peer          ClusterIP      10.96.148.69    <none>        443/TCP                  9m57s
kube-system   kube-dns             ClusterIP      10.96.128.10    <none>        53/UDP,53/TCP,9153/TCP   10m
test-kube-0   mysql80nodeport      NodePort       10.96.236.56    <none>        3306:31577/TCP           7m46s
test-kube-0   mysql80oadbalancer   LoadBalancer   10.96.150.147   11.0.0.0      3306:31972/TCP           7m46s
root@node130:~# ip r s
default via 192.168.200.1 dev enp1s0.200 proto static
10.96.0.0/24 via 192.168.200.141 dev enp1s0.200 proto bgp metric 20
10.96.1.0/24 via 192.168.200.142 dev enp1s0.200 proto bgp metric 20
10.96.2.0/24 via 192.168.200.140 dev enp1s0.200 proto bgp metric 20
11.0.0.0 proto bgp metric 20
        nexthop via 192.168.200.140 dev enp1s0.200 weight 1
        nexthop via 192.168.200.141 dev enp1s0.200 weight 1
        nexthop via 192.168.200.142 dev enp1s0.200 weight 1
192.168.200.0/24 dev enp1s0.200 proto kernel scope link src 192.168.200.130
192.168.201.0/24 dev enp1s0.400 proto kernel scope link src 192.168.201.130
192.168.202.0/24 dev enp1s0.600 proto kernel scope link src 192.168.202.130
192.168.203.0/24 dev enp1s0.800 proto kernel scope link src 192.168.203.130


root@node130:~# ipvsadm -l
IP Virtual Server version 1.2.1 (size=4096)
Prot LocalAddress:Port Scheduler Flags
  -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
TCP  node130.cloud.local:31577 rr
  -> 10.96.1.192:mysql            Masq    1      0          0
TCP  node130.cloud.local:31972 rr
  -> 10.96.1.192:mysql            Masq    1      0          0
TCP  node139.cloud.local:31577 rr
  -> 10.96.1.192:mysql            Masq    1      0          0
TCP  node139.cloud.local:31972 rr
  -> 10.96.1.192:mysql            Masq    1      0          0
TCP  node130:31577 rr
  -> 10.96.1.192:mysql            Masq    1      0          0
TCP  node130:31972 rr
  -> 10.96.1.192:mysql            Masq    1      0          0
TCP  node130:31577 rr
  -> 10.96.1.192:mysql            Masq    1      0          0
TCP  node130:31972 rr
  -> 10.96.1.192:mysql            Masq    1      0          0
TCP  node130:31577 rr
  -> 10.96.1.192:mysql            Masq    1      0          0
TCP  node130:31972 rr
  -> 10.96.1.192:mysql            Masq    1      0          0
TCP  node130:https rr
  -> node130.cloud.local:6443     Masq    1      0          0
  -> node131.cloud.local:6443     Masq    1      0          0
  -> node132.cloud.local:6443     Masq    1      0          0
TCP  node130:domain rr
  -> 10.96.2.76:domain            Masq    1      0          0
  -> 10.96.2.164:domain           Masq    1      0          0
TCP  node130:9153 rr
  -> 10.96.2.76:9153              Masq    1      0          0
  -> 10.96.2.164:9153             Masq    1      0          0
TCP  node130:https rr
TCP  node130:mysql rr
  -> 10.96.1.192:mysql            Masq    1      0          0
TCP  node130:mysql rr
  -> 10.96.1.192:mysql            Masq    1      0          0
TCP  node130:mysql rr
  -> 10.96.1.192:mysql            Masq    1      0          0
UDP  node130:domain rr
  -> 10.96.2.76:domain            Masq    1      0          0
  -> 10.96.2.164:domain           Masq    1      0          0
root@node130:~#

root@node130:~# vtysh

Hello, this is FRRouting (version 8.4.4).
Copyright 1996-2005 Kunihiro Ishiguro, et al.

node130# sh ip bgp summary

IPv4 Unicast Summary (VRF default):
BGP router identifier 192.168.203.130, local AS number 65000 vrf-id 0
BGP table version 10
RIB entries 15, using 2880 bytes of memory
Peers 3, using 2172 KiB of memory
Peer groups 1, using 64 bytes of memory

Neighbor        V         AS   MsgRcvd   MsgSent   TblVer  InQ OutQ  Up/Down State/PfxRcd   PfxSnt Desc
192.168.200.140 4      65000        21        23        0    0    0 00:08:55            2        4 N/A
192.168.200.141 4      65000        21        23        0    0    0 00:08:55            2        4 N/A
192.168.200.142 4      65000        24        26        0    0    0 00:08:44            2        4 N/A

Total number of neighbors 3
node130# sh ip bgp
BGP table version is 10, local router ID is 192.168.203.130, vrf id 0
Default local pref 100, local AS 65000
Status codes:  s suppressed, d damped, h history, * valid, > best, = multipath,
               i internal, r RIB-failure, S Stale, R Removed
Nexthop codes: @NNN nexthop's vrf id, < announce-nh-self
Origin codes:  i - IGP, e - EGP, ? - incomplete
RPKI validation codes: V valid, I invalid, N Not found

   Network          Next Hop            Metric LocPrf Weight Path
*>i10.96.0.0/24     192.168.200.141               100      0 i
*>i10.96.1.0/24     192.168.200.142               100      0 i
*>i10.96.2.0/24     192.168.200.140               100      0 i
*>i11.0.0.0/32      192.168.200.140               100      0 i
*=i                 192.168.200.142               100      0 i
*=i                 192.168.200.141               100      0 i
*> 192.168.200.0/24 0.0.0.0                  0         32768 ?
*> 192.168.201.0/24 0.0.0.0                  0         32768 ?
*> 192.168.202.0/24 0.0.0.0                  0         32768 ?
*> 192.168.203.0/24 0.0.0.0                  0         32768 ?

Displayed  8 routes and 10 total paths
node130#

root@node130:~# kubectl -n kube-system exec ds/cilium -- cilium-dbg service list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ID   Frontend                Service Type   Backend
1    10.96.128.1:443         ClusterIP      1 => 192.168.200.131:6443 (active)
                                            2 => 192.168.200.132:6443 (active)
                                            3 => 192.168.200.130:6443 (active)
2    10.96.148.69:443        ClusterIP      1 => 192.168.200.140:4244 (active)
3    10.96.128.10:53         ClusterIP      1 => 10.96.2.164:53 (active)
                                            2 => 10.96.2.76:53 (active)
4    10.96.128.10:9153       ClusterIP      1 => 10.96.2.164:9153 (active)
                                            2 => 10.96.2.76:9153 (active)
5    10.96.150.147:3306      ClusterIP      1 => 10.96.1.192:3306 (active)
6    192.168.203.140:31972   NodePort       1 => 10.96.1.192:3306 (active)
7    0.0.0.0:31972           NodePort       1 => 10.96.1.192:3306 (active)
8    192.168.200.140:31972   NodePort       1 => 10.96.1.192:3306 (active)
9    192.168.201.140:31972   NodePort       1 => 10.96.1.192:3306 (active)
10   192.168.202.140:31972   NodePort       1 => 10.96.1.192:3306 (active)
11   11.0.0.0:3306           LoadBalancer   1 => 10.96.1.192:3306 (active)
12   10.96.236.56:3306       ClusterIP      1 => 10.96.1.192:3306 (active)
13   192.168.200.140:31577   NodePort       1 => 10.96.1.192:3306 (active)
14   192.168.201.140:31577   NodePort       1 => 10.96.1.192:3306 (active)
15   192.168.202.140:31577   NodePort       1 => 10.96.1.192:3306 (active)
16   192.168.203.140:31577   NodePort       1 => 10.96.1.192:3306 (active)
17   0.0.0.0:31577           NodePort       1 => 10.96.1.192:3306 (active)

root@node140:~# ipvsadm -l
IP Virtual Server version 1.2.1 (size=4096)
Prot LocalAddress:Port Scheduler Flags
  -> RemoteAddress:Port           Forward Weight ActiveConn InActConn

```
