provider "aws" {
  region                  = "region-code" # code of region in AWS for WME setup
  shared_credentials_file = "/home/user/.aws/credentials"
  profile                 = "default" # profile name in aws cred file


}

module "WME-setup" {
  source = "module-location" #"Terraform module location for wme setup"

  # variables required from aws for creating infrastructure for WME setup

  #vpc used to setup infrastructure required for wme in a given network
  vpc_id            = "vpc-123456"
  public_subnet_id  = "subnet-123456" # public subnet id for creating platform instance
  private_subnet_id = "subnet-123456" # private subnet id for creating studio and appdeploy instance
  #ami_image_id      = "ami_id"       # ID of ami for creating platform ,studio and appdeploy instances,if valuse is null , based on OS and Version it will take AMI
  no_of_appdeployment_instances    = 1                                    # no of appdeployment instances to create for WME setup, default is 1
  no_of_studio_workspace_instances = 1                                    # no of studio workspce instances to create for WME setup, default is 1
  instance_type      = "t2.xlarge"   # type of Instance for WME insfrastructure
  pemfilename_in_aws = "wme-pem"     # name of pem file in aws account for infrastructure creation
  ssh_ip_cidr_range  = ["0.0.0.0/0"] # ssh IP ranges for WME Instances SSH,default ["0.0.0.0/0"]
  operating_system   = "rhel"        # type of operating system for WME infrastructure setup
  operating_version  = "7"           # RHEL operating system version for WME infrastructure setup
  #ubuntu_os_user_name   = "ubuntu" # default user name for ubuntu os
  #RHEL_os_user_name     = "ec2-user" # default username for RHEL os

  # variables required for WME setup process

  enterpise_name = "mywme" # name of the oraganaisation for wme setup







}


