# 01 ceph

## Problem

```shell
# cephadm bootstrap --mon-ip 192.168.2.81
Verifying podman|docker is present...
Verifying lvm2 is present...
Verifying time synchronization is in place...
Unit systemd-timesyncd.service is enabled and running
Repeating the final host check...
docker (/usr/bin/docker) is present
systemctl is present
lvcreate is present
Unit systemd-timesyncd.service is enabled and running
Host looks OK
Cluster fsid: 3575451c-9db5-11ef-9831-5254006a9a0b
Verifying IP 192.168.2.81 port 3300 ...
Verifying IP 192.168.2.81 port 6789 ...
Mon IP `192.168.2.81` is in CIDR network `192.168.2.0/24`
Mon IP `192.168.2.81` is in CIDR network `192.168.2.0/24`
Mon IP `192.168.2.81` is in CIDR network `192.168.2.254/32`
Mon IP `192.168.2.81` is in CIDR network `192.168.2.254/32`
Internal network (--cluster-network) has not been provided, OSD replication will default to the public_network
Pulling container image quay.io/ceph/ceph:v18...
Non-zero exit code 127 from /usr/bin/docker run --rm --ipc=host --stop-signal=SIGTERM --ulimit nofile=1048576 --net=host --entrypoint ceph --init -e CONTAINER_IMAGE=quay.io/ceph/ceph:v18 -e NODE_NAME=ceph01 -e CEPH_USE_RANDOM_NONCE=1 quay.io/ceph/ceph:v18 --version
ceph: stderr Fatal glibc error: CPU does not support x86-64-v2
RuntimeError: Failed command: /usr/bin/docker run --rm --ipc=host --stop-signal=SIGTERM --ulimit nofile=1048576 --net=host --entrypoint ceph --init -e CONTAINER_IMAGE=quay.io/ceph/ceph:v18 -e NODE_NAME=ceph01 -e CEPH_USE_RANDOM_NONCE=1 quay.io/ceph/ceph:v18 --version: Fatal glibc error: CPU does not support x86-64-v2



	***************
	Cephadm hit an issue during cluster installation. Current cluster files will NOT BE DELETED automatically to change
	this behaviour you can pass the --cleanup-on-failure. To remove this broken cluster manually please run:

	   > cephadm rm-cluster --force --fsid 3575451c-9db5-11ef-9831-5254006a9a0b

	in case of any previous broken installation user must use the rm-cluster command to delete the broken cluster:

	   > cephadm rm-cluster --force --zap-osds --fsid <fsid>

	for more information please refer to https://docs.ceph.com/en/latest/cephadm/operations/#purging-a-cluster
	***************


Traceback (most recent call last):
  File "<frozen runpy>", line 198, in _run_module_as_main
  File "<frozen runpy>", line 88, in _run_code
  File "/tmp/tmpt_k6pl26.cephadm.build/__main__.py", line 10889, in <module>
  File "/tmp/tmpt_k6pl26.cephadm.build/__main__.py", line 10877, in main
  File "/tmp/tmpt_k6pl26.cephadm.build/__main__.py", line 6318, in _rollback
  File "/tmp/tmpt_k6pl26.cephadm.build/__main__.py", line 2626, in _default_image
  File "/tmp/tmpt_k6pl26.cephadm.build/__main__.py", line 6437, in command_bootstrap
  File "/tmp/tmpt_k6pl26.cephadm.build/__main__.py", line 4828, in run
  File "/tmp/tmpt_k6pl26.cephadm.build/__main__.py", line 2266, in call_throws
RuntimeError: Failed command: /usr/bin/docker run --rm --ipc=host --stop-signal=SIGTERM --ulimit nofile=1048576 --net=host --entrypoint ceph --init -e CONTAINER_IMAGE=quay.io/ceph/ceph:v18 -e NODE_NAME=ceph01 -e CEPH_USE_RANDOM_NONCE=1 quay.io/ceph/ceph:v18 --version: Fatal glibc error: CPU does not support x86-64-v2

```

## Solution

Terraform resource `libvirt_domain`:
```
...
  cpu {
    mode = "host-passthrough"
  }
...
```

Recreate with: `terraform`