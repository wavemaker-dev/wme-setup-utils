# WME infrastructure creation and provisioning

## prerequisites for process

- Install Terraform
- python and pip3
- Install ansible
- create VPC and subnets in aws
- create pem file in aws and download to local

:::note
set host key checking as false in ansible configuration file ansible.cfg
disabled to avoid errors during SSH login for automatomation process.
host_key_checking = False
:::

NOTE: make sure have a connection between terraform host and instances network, or else it will fail to configure the infrastructure and make sure have a unique enterprise name, because we are using the enterprise name as tag

## WME infrastructure creation process

### module

- For Infrastructure creation process we are using Terraform module structure.The teraform module folder consists of main.tf, output.tf and variable.tf terraform files for multiple resources creation.
- In module path it also consists of ansible playbooks for infrastructure configuration.
- The anisble playbooks located in **wme_setup_scripts** in module path.it have two playbooks
- The ansible playbooks are
  - platform_instance_setup.yml
  - external_instance_setup.yml
- The platform_instance_setup.yml file provision platform instance ,in process it will create file system for volumes , mount volumes , install prerequisites, downloading wme installer file , create user and wme configwizard setup process
- The external_instance_setup.yml file provision studio workspace and appdeploy instances , in process it will create file system for volumes , mount volumes , installing prerequisites

### service

- for module structure we have another folder service. the service folder consists of main.tf and output.tf terraform files for create resources.
- In main.tf file in service directory required values for the variables to create infrastructure and for infrastructure configuration.the variables in main.tf we are getting from varibales.tf file in module folder.
- we have to specify the aws configuration deatils aws ACCESS_kEY and SECRET_KEY or the credentails file and profile for communicating with AWS.
- and also we have to specify the module location at source varibale in main.tf file

### commands for excute the process

- for downloading terraform module and providers
  - terraform init
- validateing terraform files and syntax
  - terraform validate
- for knowing excution plan
  - terraform plan
- for creating resources
  - terraform apply
- for destroy or delete resources
  - terraform destroy
