#!/usr/bin/bash

route add -net 10.96.0.0/17 gw 192.168.200.140
route add -net 10.96.0.0/17 gw 192.168.200.141
route add -net 10.96.0.0/17 gw 192.168.200.142
route add -net 11.0.0.0/16 gw 192.168.200.140
route add -net 11.0.0.0/16 gw 192.168.200.141
route add -net 11.0.0.0/16 gw 192.168.200.142
route add -net 10.96.128.0/16 gw 192.168.200.140
route add -net 10.96.128.0/17 gw 192.168.200.140
route add -net 10.96.128.0/17 gw 192.168.200.141
route add -net 10.96.128.0/17 gw 192.168.200.142
