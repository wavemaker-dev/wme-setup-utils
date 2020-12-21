provider "aws" {
  region = "region code" # code of region in AWS for WME setup
  #access_key = ""
  #secret_key = ""
  shared_credentials_file = "/home/Users_name/.aws/creds"
  profile                 = "customprofile" # profile name in aws cred file


}

module "WME-setup" {
  source = "module location" #"Terraform module location for wme setup"

  # variables required from aws for creating infrastructure for WME setup

  #vpc used to setup infrastructure required for wme in a given network
  vpc_id                           = "vpc id"
  public_subnet_id                 = "public subnet id"                   # public subnet id for creating platform instance
  private_subnet_id                = "private subnet id"                  # private subnet id for creating studio and appdeploy instance
  ami_image_id                     = "ami_id"                             # ID of ami for creating platform ,studio and appdeploy instances,if valuse is null , based on OS and Version it will take AMI
  no_of_appdeployment_instances    = 1                                    # no of appdeployment instances to create for WME setup, default is 1
  no_of_studio_workspace_instances = 1                                    # no of studio workspce instances to create for WME setup, default is 1
  instance_type                    = "t2.xlarge"                          # type of Instance for WME insfrastructure, default tr.xlarge
  pemfilename_in_aws               = "wme-setup"                          # name of pem file in aws account for infrastructure creation
  private_keypath_in_local         = "/home/user/Downloads/wme-setup.pem" # pem file path in local, for ssh into the platform, studio and appdeploy instances
  ssh_ip_cidr_range                = ["0.0.0.0/0"]                        # ssh IP ranges for WME Instances SSH,default ["0.0.0.0/0"]
  operating_system                 = "rhel"                               # type of operating system for WME infrastructure setup
  operating_version                = "7"                                  # operating system version for WME infrastructure setup
  #ubuntu_os_user_name             = "ubuntu" # default user name for ubuntu os
  #RHEL_os_user_name               = "ec2-user" # default username for RHEL os

  # variables required for WME setup process

  # WME version specific installer url. Contact WaveMaker support to get it.
  wme_sha1sum_url           = "wme shal file url" # provide sha1sum file url
  wme_installer_url         = "installer url"
  enterpise_name            = "wme10537y"             # name of the oraganaisation for wme setup
  setup_admin_password      = "Wme@1234"              # config portal password used to do setup operations.
  admin_Email_Address       = "wme1053@wavemaker.com" # launchpad admin user email
  admin_user_firstname      = "wme"                   #  launcpad Admin user name
  admin_user_lastname       = "test"                  # launchpad admin user last name
  admin_user_password       = "Wme@1234"              # launchpad admin user password
  setup_with_custom_sshkeys = "yes"                   # available options yes and no, with 'yes' platform , studio and 
  # Appdeploy instances will communicate with the wavemaker internal user , with 'no' option they communicate with oerating system user  
  internal_user_for_wavemaker         = "wavemaker_internal_user"            # this wavemaker internal will use to communicate between platform,studio and appdeploy instances
  internal_user_ssh_key_for_wavemaker = "/home/user/Downloads/wme-setup.pem" # private key path in local for custom user ssh
  wavemaker_built_apps_domain         = "wm-app.mysetup.com"                 # url used to access wavemaker built in apps
  wavemaker_studio_domain             = "wavemaker.mysetup.com"              # wavemaker studio url for accessing wavemaker studio
  network_interface_name              = "eth0"                               # network interface name used for WME setup,default is eth0 for ubuntu and rhel 
  cidr_range_for_docker_setup         = "10.3.1.1/24"                        # CIDR range used for Docker containers networks in WME setup
  WME_platform_configurations = true
  user_license_file    = "licenses.license"
  instance_addition_operation = "yes"
  wme_platform_version = "10.6.0"







}


