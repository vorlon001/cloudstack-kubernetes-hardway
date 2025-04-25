```shell

array=( 130 131 132 140 141 142 )
for i in "${array[@]}"
do
  scp -r * root@192.168.200.${i}:.
done

node130,node131,node132,node140,node141,node142 - Denian 12


master node: node130,node131,node132
worker node: node140,node141,node142

root@node130:~/CSI/TEST.1.NFS-STORE# kubectl get node,pod -A -o wide
NAME           STATUS   ROLES    AGE   VERSION   INTERNAL-IP       EXTERNAL-IP   OS-IMAGE                         KERNEL-VERSION   CONTAINER-RUNTIME
node/node140   Ready    <none>   25m   v1.31.2   192.168.200.140   <none>        Debian GNU/Linux 12 (bookworm)   6.1.0-26-amd64   containerd://2.0.0
node/node141   Ready    <none>   25m   v1.31.2   192.168.200.141   <none>        Debian GNU/Linux 12 (bookworm)   6.1.0-26-amd64   containerd://2.0.0
node/node142   Ready    <none>   25m   v1.31.2   192.168.200.142   <none>        Debian GNU/Linux 12 (bookworm)   6.1.0-26-amd64   containerd://2.0.0

NAMESPACE     NAME                                          READY   STATUS    RESTARTS   AGE     IP                NODE      NOMINATED NODE   READINESS GATES
kube-system   pod/cilium-gr4cc                              1/1     Running   0          21m     192.168.200.142   node142   <none>           <none>
kube-system   pod/cilium-operator-78c665d568-hd26s          1/1     Running   0          24m     192.168.200.142   node142   <none>           <none>
kube-system   pod/cilium-operator-78c665d568-pnsfw          1/1     Running   0          24m     192.168.200.141   node141   <none>           <none>
kube-system   pod/cilium-tqqvx                              1/1     Running   0          21m     192.168.200.141   node141   <none>           <none>
kube-system   pod/cilium-xnljl                              1/1     Running   0          21m     192.168.200.140   node140   <none>           <none>
kube-system   pod/coredns-846d48449-jsk2s                   1/1     Running   0          24m     10.96.0.167       node140   <none>           <none>
kube-system   pod/coredns-846d48449-nxj8g                   1/1     Running   0          24m     10.96.0.244       node140   <none>           <none>
nfs-client    pod/nfs-client-provisioner-5f84c45dd9-lsp74   1/1     Running   0          21m     10.96.1.44        node142   <none>           <none>
test-kube-0   pod/mysql80-56d796b478-wsnxp                  1/1     Running   0          60s     10.96.0.174       node140   <none>           <none>
test-kube-0   pod/postgres13-0                              1/1     Running   0          10s     10.96.2.9         node141   <none>           <none>
test-kube-0   pod/postgres13-1                              1/1     Running   0          6s      10.96.0.154       node140   <none>           <none>
test-kube-0   pod/postgres13-2                              0/1     Pending   0          1s      <none>            <none>    <none>           <none>
test-kube-0   pod/postgres13-6cffcff664-kfmz8               1/1     Running   0          2m51s   10.96.1.243       node142   <none>           <none>
test-kube-0   pod/web-0                                     1/1     Running   0          7m12s   10.96.0.198       node140   <none>           <none>
test-kube-0   pod/web-1                                     1/1     Running   0          7m7s    10.96.1.118       node142   <none>           <none>
test-kube-0   pod/web-2                                     1/1     Running   0          7m3s    10.96.2.170       node141   <none>           <none>
test-kube-0   pod/web-3                                     1/1     Running   0          7m      10.96.0.166       node140   <none>           <none>
test-kube-0   pod/web-4                                     1/1     Running   0          6m57s   10.96.1.154       node142   <none>           <none>
test-kube-0   pod/web-5                                     1/1     Running   0          6m54s   10.96.2.31        node141   <none>           <none>
test-kube-0   pod/web10-0                                   1/1     Running   0          7m12s   10.96.1.132       node142   <none>           <none>
test-kube-0   pod/web10-1                                   1/1     Running   0          7m8s    10.96.2.60        node141   <none>           <none>


root@node130:~/CSI/TEST.1.NFS-STORE# kubectl get svc -A
NAMESPACE     NAME                 TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                  AGE
default       kubernetes           ClusterIP      10.96.128.1     <none>        443/TCP                  27m
kube-system   hubble-peer          ClusterIP      10.96.199.109   <none>        443/TCP                  24m
kube-system   kube-dns             ClusterIP      10.96.128.10    <none>        53/UDP,53/TCP,9153/TCP   24m
test-kube-0   mysql80nodeport      NodePort       10.96.171.95    <none>        3306:32470/TCP           7m38s
test-kube-0   mysql80oadbalancer   LoadBalancer   10.96.252.7     11.0.0.0      3306:32137/TCP           7m38s

root@node130:~/CSI/TEST.1.NFS-STORE# ip r s
default via 192.168.200.1 dev enp1s0.200 proto static
10.96.0.0/24 via 192.168.200.140 dev enp1s0.200 proto bgp metric 20
10.96.1.0/24 via 192.168.200.142 dev enp1s0.200 proto bgp metric 20
10.96.2.0/24 via 192.168.200.141 dev enp1s0.200 proto bgp metric 20
11.0.0.0 proto bgp metric 20
        nexthop via 192.168.200.140 dev enp1s0.200 weight 1
        nexthop via 192.168.200.141 dev enp1s0.200 weight 1
        nexthop via 192.168.200.142 dev enp1s0.200 weight 1
192.168.200.0/24 dev enp1s0.200 proto kernel scope link src 192.168.200.130
192.168.201.0/24 dev enp1s0.400 proto kernel scope link src 192.168.201.130
192.168.202.0/24 dev enp1s0.600 proto kernel scope link src 192.168.202.130
192.168.203.0/24 dev enp1s0.800 proto kernel scope link src 192.168.203.130


root@node130:~/CSI/TEST.1.NFS-STORE# ipvsadm -l
IP Virtual Server version 1.2.1 (size=4096)
Prot LocalAddress:Port Scheduler Flags
  -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
TCP  node130:32137 rr
  -> 10.96.0.174:mysql            Masq    1      0          0
TCP  node130:32470 rr
  -> 10.96.0.174:mysql            Masq    1      0          0
TCP  node130:32137 rr
  -> 10.96.0.174:mysql            Masq    1      0          0
TCP  node130:32470 rr
  -> 10.96.0.174:mysql            Masq    1      0          0
TCP  node130:32137 rr
  -> 10.96.0.174:mysql            Masq    1      0          0
TCP  node130:32470 rr
  -> 10.96.0.174:mysql            Masq    1      0          0
TCP  node130:32137 rr
  -> 10.96.0.174:mysql            Masq    1      0          0
TCP  node130:32470 rr
  -> 10.96.0.174:mysql            Masq    1      0          0
TCP  node130:32137 rr
  -> 10.96.0.174:mysql            Masq    1      0          0
TCP  node130:32470 rr
  -> 10.96.0.174:mysql            Masq    1      0          0
TCP  node130:https rr
  -> node130:16443                Masq    1      0          0
  -> node131.cloud.local:16443    Masq    1      0          0
  -> node132.cloud.local:16443    Masq    1      0          0
TCP  node130:domain rr
  -> 10.96.0.167:domain           Masq    1      0          0
  -> 10.96.0.244:domain           Masq    1      0          0
TCP  node130:9153 rr
  -> 10.96.0.167:9153             Masq    1      0          0
  -> 10.96.0.244:9153             Masq    1      0          0
TCP  node130:mysql rr
  -> 10.96.0.174:mysql            Masq    1      0          0
TCP  node130:https rr
TCP  node130:mysql rr
  -> 10.96.0.174:mysql            Masq    1      0          0
TCP  node130:mysql rr
  -> 10.96.0.174:mysql            Masq    1      0          0
UDP  node130:domain rr
  -> 10.96.0.167:domain           Masq    1      0          0
  -> 10.96.0.244:domain           Masq    1      0          0
root@node130:~/CSI/TEST.1.NFS-STORE#




root@node130:~/CSI/TEST.1.NFS-STORE# vtysh

Hello, this is FRRouting (version 8.4.4).
Copyright 1996-2005 Kunihiro Ishiguro, et al.

node130# show ip bgp summary

IPv4 Unicast Summary (VRF default):
BGP router identifier 192.168.203.130, local AS number 65000 vrf-id 0
BGP table version 12
RIB entries 15, using 2880 bytes of memory
Peers 3, using 2172 KiB of memory
Peer groups 1, using 64 bytes of memory

Neighbor        V         AS   MsgRcvd   MsgSent   TblVer  InQ OutQ  Up/Down State/PfxRcd   PfxSnt Desc
192.168.200.140 4      65000        52        54        0    0    0 00:23:09            2        4 N/A
192.168.200.141 4      65000        52        54        0    0    0 00:23:11            2        4 N/A
192.168.200.142 4      65000        54        56        0    0    0 00:22:58            2        4 N/A

Total number of neighbors 3
node130# show ip bgp
BGP table version is 12, local router ID is 192.168.203.130, vrf id 0
Default local pref 100, local AS 65000
Status codes:  s suppressed, d damped, h history, * valid, > best, = multipath,
               i internal, r RIB-failure, S Stale, R Removed
Nexthop codes: @NNN nexthop's vrf id, < announce-nh-self
Origin codes:  i - IGP, e - EGP, ? - incomplete
RPKI validation codes: V valid, I invalid, N Not found

   Network          Next Hop            Metric LocPrf Weight Path
*>i10.96.0.0/24     192.168.200.140               100      0 i
*>i10.96.1.0/24     192.168.200.142               100      0 i
*>i10.96.2.0/24     192.168.200.141               100      0 i
*=i11.0.0.0/32      192.168.200.142               100      0 i
*=i                 192.168.200.141               100      0 i
*>i                 192.168.200.140               100      0 i
*> 192.168.200.0/24 0.0.0.0                  0         32768 ?
*> 192.168.201.0/24 0.0.0.0                  0         32768 ?
*> 192.168.202.0/24 0.0.0.0                  0         32768 ?
*> 192.168.203.0/24 0.0.0.0                  0         32768 ?

Displayed  8 routes and 10 total paths
node130#

root@node130:~/CSI/TEST.1.NFS-STORE# kubectl -n kube-system exec ds/cilium -- cilium-dbg service list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ID   Frontend                Service Type   Backend
1    10.96.128.1:443         ClusterIP      1 => 192.168.200.131:16443 (active)
                                            2 => 192.168.200.132:16443 (active)
                                            3 => 192.168.200.130:16443 (active)
2    10.96.199.109:443       ClusterIP      1 => 192.168.200.141:4244 (active)
3    10.96.128.10:9153       ClusterIP      1 => 10.96.0.244:9153 (active)
                                            2 => 10.96.0.167:9153 (active)
4    10.96.128.10:53         ClusterIP      1 => 10.96.0.244:53 (active)
                                            2 => 10.96.0.167:53 (active)
18   10.96.252.7:3306        ClusterIP      1 => 10.96.0.174:3306 (active)
19   192.168.200.141:32137   NodePort       1 => 10.96.0.174:3306 (active)
20   192.168.201.141:32137   NodePort       1 => 10.96.0.174:3306 (active)
21   192.168.202.141:32137   NodePort       1 => 10.96.0.174:3306 (active)
22   192.168.203.141:32137   NodePort       1 => 10.96.0.174:3306 (active)
23   0.0.0.0:32137           NodePort       1 => 10.96.0.174:3306 (active)
24   11.0.0.0:3306           LoadBalancer   1 => 10.96.0.174:3306 (active)
25   10.96.171.95:3306       ClusterIP      1 => 10.96.0.174:3306 (active)
26   192.168.203.141:32470   NodePort       1 => 10.96.0.174:3306 (active)
27   0.0.0.0:32470           NodePort       1 => 10.96.0.174:3306 (active)
28   192.168.200.141:32470   NodePort       1 => 10.96.0.174:3306 (active)
29   192.168.201.141:32470   NodePort       1 => 10.96.0.174:3306 (active)
30   192.168.202.141:32470   NodePort       1 => 10.96.0.174:3306 (active)
root@node130:~/CSI/TEST.1.NFS-STORE#


```
