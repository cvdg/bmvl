# portainer

## uninstall

```shell
$ ansible-playbook portainer.yml -t portainer -e portainer_uninstall=true

PLAY [infra] *******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [infra01]

TASK [portainer : include_tasks] ***********************************************
skipping: [infra01]

TASK [portainer : include_tasks] ***********************************************
included: /Users/cees/Projects/bmvl/ansible/roles/portainer/tasks/uninstall.yml for infra01

TASK [portainer : Stop portainer] **********************************************
changed: [infra01]

TASK [portainer : Remove data directory] ***************************************
changed: [infra01]

TASK [portainer : Remove deploy directory] *************************************
changed: [infra01]

PLAY RECAP *********************************************************************
infra01                    : ok=5    changed=3    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

```