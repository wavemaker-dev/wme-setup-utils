# wme-infra-setup-with-terraform

## prerequisites for operation

- Terraform
- Python
- Pip and
- Ansible

:::note
set host key checking as false in ansible configuration file ansible.cfg
disabled to avoid errors during SSH login for automatomation process.
host_key_checking = False
:::

NOTE: make sure have a connection between terraform host and instances network, or else it will fail to configure the infrastructure

## infrastructure setup process details

- wme-infra-setup-with-terraform consists of module and service folders
- module folder consists of main.tf , variable.tf and output.tf for creating infrastructure in aws
- service folder consists of main.tf and output.tf . we provide values for variables in main.tf for infrastructure creation.
- at main.tf in service firectory we mention module directory location for create the resources for **source** variable
- The infrastructure creation process it will create platform instance, studio workspace instance and app deploy instance , and also it will create security groups WME-SG-platform-public, WME-SG-platform-internal and WME-SG-workspace-internal
- After creating the infrastructure it will provide output values  IP Address of Instance and security group ID's
- for identify the instnaces and security groups we added tags with enterprise name as suffix

- for creating infrastructure resources execute below commands, we run the commands for service directory
  - for downloading modules and provider resources
    - terraform init
  - for validate the terraform files
    - terraform validate
  - for know what are the resources create
    - terraform plan
  - for creating resources
    - terraform apply
  
- for destroy (delete) resources in aws
  - terraform destroy
