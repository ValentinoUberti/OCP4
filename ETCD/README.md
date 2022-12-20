# Etcd basic
https://www.krenger.ch/blog/exploring-the-openshift-etcd-with-etcdctl/

## Get all keys
etcdctl get / --prefix --keys-only --write-out=simple

## watch a key

etcdctl --write-out=json watch /openshift.io/project/test-etcd

## get a key

etcdctl --write-out=json get /openshift.io/project/test-etcd

## put a key
etcdctl --write-out=json put /openshift.io/project/test-etcd

## del a key
etcdctl --write-out=json del /openshift.io/project/test-etcd