# bmvl / bromvogel

A `terraform` project to setup a homelab environment on
a `Debian` laptop with `KVM` to learn more about `ceph`.


## Terraform

By default creates 3 virtual guests with a root partition og 32 GiB and a data partition of 128 GiB on the KVM host.

- `cd ./terraform/`
- `terraform init`
- `terraform plan -out terraform.tfplan`
- `terraform apply terraform.tfplan`

`terraform apply` generates `../ansible/inventory.yml`. 


## Ansible

Configures all hosts created by `terraform`.

- `cd ./ansible/`
- `ansible-playbook site.yml`
