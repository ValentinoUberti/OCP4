https://developers.redhat.com/blog/2020/01/27/open-virtual-network-unidling/

# iptables --list

sh-4.4# iptables --list
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
ACCEPT     all  --  anywhere             anywhere             /* from OVN to localhost */
ACCEPT     all  --  anywhere             anywhere             /* from OVN to localhost */
KUBE-FIREWALL  all  --  anywhere             anywhere            

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         
OVN-KUBE-EXTERNALIP  all  --  anywhere             anywhere            
OVN-KUBE-NODEPORT  all  --  anywhere             anywhere            
ACCEPT     all  --  anywhere             anywhere             ctstate RELATED,ESTABLISHED
ACCEPT     all  --  anywhere             anywhere            
ACCEPT     all  --  anywhere             anywhere             ctstate RELATED,ESTABLISHED
ACCEPT     all  --  anywhere             anywhere            
REJECT     tcp  --  anywhere             anywhere             tcp dpt:22624 reject-with icmp-port-unreachable
REJECT     tcp  --  anywhere             anywhere             tcp dpt:22623 reject-with icmp-port-unreachable

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
REJECT     tcp  --  anywhere             anywhere             tcp dpt:22624 reject-with icmp-port-unreachable
REJECT     tcp  --  anywhere             anywhere             tcp dpt:22623 reject-with icmp-port-unreachable
KUBE-FIREWALL  all  --  anywhere             anywhere            

Chain KUBE-FIREWALL (2 references)
target     prot opt source               destination         
DROP       all  --  anywhere             anywhere             /* kubernetes firewall for dropping marked packets */ mark match 0x8000/0x8000
DROP       all  -- !127.0.0.0/8          127.0.0.0/8          /* block incoming localnet connections */ ! ctstate RELATED,ESTABLISHED,DNAT

Chain KUBE-KUBELET-CANARY (0 references)
target     prot opt source               destination         

Chain OVN-KUBE-NODEPORT (1 references)
target     prot opt source               destination         
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:32266
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:32563
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:32658
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:31612
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:31357
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:30151
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:32587

# Who is listent of those ports?

sh-4.4# ss -tulpn | grep -e 32266 -e 32563 -e 32658 -e 31612 -e 31357 -e 31612 -e 32587
tcp     LISTEN   0        128                    *:31612                *:*      users:(("ovnkube",pid=5041,fd=10))                                             
tcp     LISTEN   0        128                    *:31357                *:*      users:(("ovnkube",pid=5041,fd=9))                                              
tcp     LISTEN   0        128                    *:32266                *:*      users:(("ovnkube",pid=5041,fd=13))                                             
tcp     LISTEN   0        128                    *:32587                *:*      users:(("ovnkube",pid=5041,fd=6))                                              
tcp     LISTEN   0        128                    *:32658                *:*      users:(("ovnkube",pid=5041,fd=11))                                             
tcp     LISTEN   0        128                    *:32563                *:*      users:(("ovnkube",pid=5041,fd=12))  


on ovn pod:

12: br-ex: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 56:6f:64:4f:00:09 brd ff:ff:ff:ff:ff:ff
    inet 172.27.4.220/24 brd 172.27.4.255 scope global dynamic noprefixroute br-ex
       valid_lft 28316sec preferred_lft 28316sec
    inet6 fe80::7335:d4e5:77d0:6880/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever

