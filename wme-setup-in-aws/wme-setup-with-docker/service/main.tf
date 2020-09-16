provider "aws" {
  region = "region-code" # code of region in AWS for WME setup
  shared_credentials_file = "/root/.aws/credentials"
  profile                 = "default" # profile name in aws cred file


}

module "WME-setup" {
  source = "/usr/local/wme-setup/module/wme-setup-creation/" #"Default Terraform module location for wme setup"

  # variables required from aws for creating infrastructure for WME setup

  #vpc used to setup infrastructure required for wme in a given network
  vpc_id            = "vpc-123456"
  public_subnet_id  = "subnet-12345" # public subnet id for creating platform instance
  private_subnet_id = "subnet-345678" # private subnet id for creating studio and appdeploy instance
  #ami_image_id      = "ami_id"                             # ID of ami for creating platform ,studio and appdeploy instances,if valuse is null , based on OS and Version it will take AMI
  no_of_appdeployment_instances    = 1                                    # no of appdeployment instances to create for WME setup, default is 1
  no_of_studio_workspace_instances = 1                                    # no of studio workspce instances to create for WME setup, default is 1
  instance_type            = "type of instance"                                                                      # type of Instance for WME insfrastructure
  pemfilename_in_aws       = "wme-setup.pem"                                                        # name of pem file in aws account for infrastructure creation
  private_keypath_in_local = "/usr/local/private_keys/wme-setup.pem"                             # pem file path in local, for ssh into the platform, studio and appdeploy instances
  ssh_ip_cidr_range        = ["0.0.0.0/0"] # ssh IP ranges for WME Instances SSH,default ["0.0.0.0/0"]
  operating_system         = "ubuntu"                                                                           # type of operating system for WME infrastructure setup
  #operating_version        = "7"                                                                              # RHEL operating system version for WME infrastructure setup
  ubuntu_os_user_name             = "ubuntu" # default user name for ubuntu os
  #RHEL_os_user_name               = "ec2-user" # default username for RHEL os

  # variables required for WME setup process

  # WME version specific installer url. Contact WaveMaker support to get it.
  wme_sha1sum_url           = "sha1sum file url"
  wme_installer_url         = "wme installer url"
  enterpise_name            = "myent"             # name of the oraganaisation for wme setup
  setup_admin_password      = "myadminpasswd"              # config portal password used to do setup operations.
  admin_Email_Address       = "wmesetup@mail.com" # launchpad admin user email
  admin_user_firstname      = "wme"                   #  launcpad Admin user name
  admin_user_lastname       = "setup"                  # launchpad admin user last name
  admin_user_password       = "myuserpasswd"              # launchpad admin user password
  setup_with_custom_sshkeys = "yes"                   # wavemaker setup with custom user ssh keys for operation will create user
  # internal username for wavemaker operation and communication between platform,studio and appdeploy
  internal_user_for_wavemaker         = "myuser"
  internal_user_ssh_key_for_wavemaker = "/usr/local/private_keys/wme-setup-custom.pem" # private key path in local for custom user ssh
  #wavemaker_services_domain           = "wm-services.rheltest.com"
  wavemaker_built_apps_domain = "mybuitapps.domain.com"    # url used to access wavemaker built in apps
  wavemaker_studio_domain     = "studio.domain.com" # wavemaker studio url for accessing wavemaker studio
  network_interface_name      = "eth0"                   # network interface name used for WME setup,default is eth0 for ubuntu and rhel will consider
  cidr_range_for_docker_setup = "10.3.1.1/24"            # CIDR range used for Docker containers networks in WME setup







}


