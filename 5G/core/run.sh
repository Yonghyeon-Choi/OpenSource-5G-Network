#!/bin/bash

pkill -9 -ef mongod
mongod --bind_ip 0.0.0.0 --fork --logpath /var/log/mongodb.log --logappend
mongo open5gs ./account.js
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv6.conf.all.forwarding=1
iptables -t nat -A POSTROUTING -s 10.45.0.0/16 ! -o ogstun -j MASQUERADE
ip6tables -t nat -A POSTROUTING -s 2001:db8:cafe::/48 ! -o ogstun -j MASQUERADE
