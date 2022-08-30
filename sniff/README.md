# ksniff
https://github.com/eldadru/ksniff

oc sniff pod-name -c vault-agent -o /tmp/vault_agent.pcap -f "tcp port 443"

# tcpdump
tcpdump -qns 0 -X -r file.pcap
