sudo podman run --volume /var/lib/etcd:/var/lib/etcd:Z quay.io/openshift-scale/etcd-perf

https://docs.openshift.com/container-platform/4.6/scalability_and_performance/recommended-host-practices.html


# Use Prometheus to track the metric. 

histogram_quantile(0.99, rate(etcd_network_peer_round_trip_time_seconds_bucket[2m])) reports the round trip time for etcd to finish replicating the client requests between the members; it should be less than 50 ms.
