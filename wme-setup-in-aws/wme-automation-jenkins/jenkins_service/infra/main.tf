provider "aws" {
  region     = var.region # code of region in AWS for WME setup
  access_key = var.access_key
  secret_key = var.secret_key


}

module "WME-setup" {
  source = "../../../../../wme-automations/wme-setup-in-aws/wme-infra-setup-with-terraform/module/wme-setup-creation" 
  # "Terraform module location for wme setup"
  
  # variables required from aws for creating infrastructure for WME setup

  #vpc used to setup infrastructure required for wme in a given network
  vpc_id                           = var.vpc_id
  public_subnet_id                 = var.public_subnet_id                 # public subnet id for creating platform instance
  private_subnet_id                = var.private_subnet_id                # private subnet id for creating studio and appdeploy instance
  ami_image_id                     = var.ami_image_id                     # ID of ami for creating platform ,studio and appdeploy instances,if valuse is null , based on OS and Version it will take AMI
  no_of_appdeployment_instances    = var.no_of_appdeployment_instances    # no of appdeployment instances to create for WME setup, default is 1
  no_of_studio_workspace_instances = var.no_of_studio_workspace_instances # no of studio workspce instances to create for WME setup, default is 1
  instance_type                    = var.instance_type                    # type of Instance for WME insfrastructure
  pemfilename_in_aws               = var.pemfilename_in_aws               # name of pem file in aws account for infrastructure creation
  ssh_ip_cidr_range                = var.ssh_ip_cidr_range                # ssh IP ranges for WME Instances SSH,default ["0.0.0.0/0"]
  operating_system                 = var.operating_system                 # type of operating system for WME infrastructure setup
  operating_version                = var.operating_version                # RHEL operating system version for WME infrastructure setup
  ubuntu_os_user_name              = var.ubuntu_os_user_name              # default user name for ubuntu os
  RHEL_os_user_name                = var.RHEL_os_user_name                # default username for RHEL os
  enterpise_name                   = var.enterpise_name                   # name of the oraganaisation for wme setup







}


