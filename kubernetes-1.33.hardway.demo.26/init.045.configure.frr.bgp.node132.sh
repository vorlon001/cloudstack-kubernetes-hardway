#!/usr/bin/bash


vtysh -c "config t
hostname node182
log syslog informational
!
interface enp1s0.200
exit
!
!
ip prefix-list No seq 5 permit 192.168.200.0/24
ip prefix-list No seq 10 permit 192.168.201.0/24
ip prefix-list No seq 15 permit 192.168.202.0/24
ip prefix-list No seq 20 permit 192.168.203.0/24
ip prefix-list Yes seq 5 permit any
!
!
route-map fromAS65000ipv4 permit 65535
exit
!
route-map redistributeAS65000 permit 65535
exit
!
route-map toAS65000ipv4 deny 100
 match ip address prefix-list No
exit
!
route-map toAS65000ipv4 permit 65535
 match ip address prefix-list Yes
exit
!
route-map toAS65000ipv4 permit 65535
 match ip address prefix-list Yes
exit
!
route-map toAS65000ipv6 deny 100
 match ipv6 address prefix-list No
exit
!
!
!
router bgp 65000
 no bgp ebgp-requires-policy
 no bgp default ipv4-unicast
 no bgp network import-check
 neighbor fabric_v200 peer-group
 neighbor fabric_v200 remote-as 65000
 neighbor fabric_v200 update-source enp1s0.200
 neighbor 192.168.200.140 peer-group fabric_v200
 neighbor 192.168.200.141 peer-group fabric_v200
 neighbor 192.168.200.142 peer-group fabric_v200
 neighbor fabric_v400 peer-group
 neighbor fabric_v400 remote-as 65000
 neighbor fabric_v400 update-source enp1s0.400
 neighbor 192.168.201.140 peer-group fabric_v400
 neighbor 192.168.201.141 peer-group fabric_v400
 neighbor 192.168.201.142 peer-group fabric_v400
 neighbor fabric_v600 peer-group
 neighbor fabric_v600 remote-as 65000
 neighbor fabric_v600 update-source enp1s0.600
 neighbor 192.168.202.140 peer-group fabric_v600
 neighbor 192.168.202.141 peer-group fabric_v600
 neighbor 192.168.202.142 peer-group fabric_v600
 neighbor fabric_v800 peer-group
 neighbor fabric_v800 remote-as 65000
 neighbor fabric_v800 update-source enp1s0.800
 neighbor 192.168.203.140 peer-group fabric_v800
 neighbor 192.168.203.141 peer-group fabric_v800
 neighbor 192.168.203.142 peer-group fabric_v800
 !
 address-family ipv4 unicast
  redistribute connected route-map redistributeAS65000
  redistribute static route-map redistributeAS65000
  neighbor fabric_v200 activate
  neighbor fabric_v200 route-reflector-client
  neighbor fabric_v200 next-hop-self
  neighbor fabric_v200 soft-reconfiguration inbound
  neighbor fabric_v200 route-map fromAS65000ipv4 in
  neighbor fabric_v200 route-map toAS65000ipv4 out
  neighbor fabric_v400 activate
  neighbor fabric_v400 route-reflector-client
  neighbor fabric_v400 next-hop-self
  neighbor fabric_v400 soft-reconfiguration inbound
  neighbor fabric_v400 route-map fromAS65000ipv4 in
  neighbor fabric_v400 route-map toAS65000ipv4 out
  neighbor fabric_v600 activate
  neighbor fabric_v600 route-reflector-client
  neighbor fabric_v600 next-hop-self
  neighbor fabric_v600 soft-reconfiguration inbound
  neighbor fabric_v600 route-map fromAS65000ipv4 in
  neighbor fabric_v600 route-map toAS65000ipv4 out
  neighbor fabric_v800 activate
  neighbor fabric_v800 route-reflector-client
  neighbor fabric_v800 next-hop-self
  neighbor fabric_v800 soft-reconfiguration inbound
  neighbor fabric_v800 route-map fromAS65000ipv4 in
  neighbor fabric_v800 route-map toAS65000ipv4 out
 exit-address-family
 !
!
!
"

vtysh -c "show run"
vtysh -c "write"

