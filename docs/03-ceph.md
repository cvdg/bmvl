# 03 ceph

```shell
$ sudo ceph -s
  cluster:
    id:     5d875d8a-9dbd-11ef-aea4-525400e68aed
    health: HEALTH_WARN
            OSD count 0 < osd_pool_default_size 3

  services:
    mon: 1 daemons, quorum ceph01 (age 13m)
    mgr: ceph01.fqwifv(active, since 4m)
    osd: 0 osds: 0 up, 0 in

  data:
    pools:   0 pools, 0 pgs
    objects: 0 objects, 0 B
    usage:   0 B used, 0 B / 0 B avail
    pgs:

```

## Copy ssh key

```shell
$ sudo for i in ceph02 ceph03 ; do ssh-copy-id -f -i /etc/ceph/ceph.pub root@${i}; done
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/etc/ceph/ceph.pub"
The authenticity of host 'ceph02 (192.168.2.86)' can't be established.
ED25519 key fingerprint is SHA256:ee7CvWIKerrVeiy5sZpw0DVtmR/cXeveri3AbLWMYSw.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'root@ceph02'"
and check to make sure that only the key(s) you wanted were added.

/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/etc/ceph/ceph.pub"
The authenticity of host 'ceph03 (192.168.2.87)' can't be established.
ED25519 key fingerprint is SHA256:2glm/WCbMQX2icEa1YFcQHXzxOh712xZM2rRv2jROLo.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'root@ceph03'"
and check to make sure that only the key(s) you wanted were added.

```

```shell
$ sudo ceph orch host ls
HOST    ADDR          LABELS  STATUS
ceph01  192.168.2.85  _admin
1 hosts in cluster
```

```shell
# ceph orch host add ceph02
Added host 'ceph02' with addr '192.168.2.86'
root@ceph01:~# ceph orch host add ceph03
Added host 'ceph03' with addr '192.168.2.87'
root@ceph01:~# ceph -s
  cluster:
    id:     5d875d8a-9dbd-11ef-aea4-525400e68aed
    health: HEALTH_WARN
            OSD count 0 < osd_pool_default_size 3

  services:
    mon: 1 daemons, quorum ceph01 (age 16m)
    mgr: ceph01.fqwifv(active, since 7m)
    osd: 0 osds: 0 up, 0 in

  data:
    pools:   0 pools, 0 pgs
    objects: 0 objects, 0 B
    usage:   0 B used, 0 B / 0 B avail
    pgs:

```

```shell
# ceph orch apply osd --all-available-devices
Scheduled osd.all-available-devices update...
```

```shell
# ceph -s
  cluster:
    id:     5d875d8a-9dbd-11ef-aea4-525400e68aed
    health: HEALTH_WARN
            1 slow ops, oldest one blocked for 719 sec, mon.ceph02 has slow ops

  services:
    mon: 3 daemons, quorum ceph01,ceph02,ceph03 (age 9m)
    mgr: ceph01.fqwifv(active, since 34m), standbys: ceph02.jqmrsv
    osd: 3 osds: 3 up (since 9m), 3 in (since 14m)

  data:
    pools:   1 pools, 1 pgs
    objects: 2 objects, 449 KiB
    usage:   81 MiB used, 384 GiB / 384 GiB avail
    pgs:     1 active+clean

```
