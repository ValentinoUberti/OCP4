## On a Ceph admin node

ceph fs volume create ocp2-fs
ceph osd pool create ocp2-rbd
ceph osd pool application enable ocp2-rbd rbd



python3 external.py \
  --cephfs-filesystem-name ocp2-fs \
  --rbd-data-pool-name ocp2-rbd \
  --monitoring-endpoint 172.19.0.151,172.19.0.152 \
  --monitoring-endpoint-port 9283

