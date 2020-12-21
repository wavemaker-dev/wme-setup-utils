provider "aws" {
  region = var.region # code of region in AWS for WME setup
  #shared_credentials_file = "/home/user/.aws/credentials"
  #profile                 = "default" # profile name in aws cred file
  access_key = var.access_key
  secret_key = var.secret_key


}

module "WME-setup" {
  source = "../../../../../wme-automations/wme-setup-in-aws/wme-infra-and-config-setup/modules/wme-setup-creation" #"Terraform module location for wme setup"

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
  private_keypath_in_local         = var.private_keypath_in_local         # pem file path in local, for ssh into the platform, studio and appdeploy instances
  ssh_ip_cidr_range                = var.ssh_ip_cidr_range                # ssh IP ranges for WME Instances SSH,default ["0.0.0.0/0"]
  operating_system                 = var.operating_system                 # type of operating system for WME infrastructure setup
  operating_version                = var.operating_version                # RHEL operating system version for WME infrastructure setup
  ubuntu_os_user_name              = var.ubuntu_os_user_name              # default user name for ubuntu os
  RHEL_os_user_name                = var.RHEL_os_user_name                # default username for RHEL os

  # variables required for WME setup process

  # WME version specific installer url. Contact WaveMaker support to get it.
  wme_sha1sum_url           = var.wme_sha1sum_url
  wme_installer_url         = var.wme_installer_url
  enterpise_name            = var.enterpise_name            # name of the oraganaisation for wme setup
  setup_admin_password      = var.setup_admin_password      # config portal password used to do setup operations.
  admin_Email_Address       = var.admin_Email_Address       # launchpad admin user email
  admin_user_firstname      = var.admin_user_firstname      #  launcpad Admin user name
  admin_user_lastname       = var.admin_user_lastname       # launchpad admin user last name
  admin_user_password       = var.admin_user_password       # launchpad admin user password
  setup_with_custom_sshkeys = var.setup_with_custom_sshkeys # wavemaker setup with custom user ssh keys for operation will create user
  # internal username for wavemaker operation and communication between platform,studio and appdeploy
  internal_user_for_wavemaker         = var.internal_user_for_wavemaker
  internal_user_ssh_key_for_wavemaker = var.internal_user_ssh_key_for_wavemaker # private key path in local for custom user ssh
  wavemaker_built_apps_domain         = var.wavemaker_built_apps_domain         # url used to access wavemaker built in apps
  wavemaker_studio_domain             = var.wavemaker_studio_domain             # wavemaker studio url for accessing wavemaker studio
  network_interface_name              = var.network_interface_name              # network interface name used for WME setup,default is eth0 for ubuntu and rhel will consider
  cidr_range_for_docker_setup         = var.cidr_range_for_docker_setup         # CIDR range used for Docker containers networks in WME setup
  WME_platform_configurations         = var.WME_platform_configurations
  user_license_file                   = var.user_license_file
  instance_addition_operation         = var.instance_addition_operation
  wme_platform_version                = var.wme_platform_version





}


