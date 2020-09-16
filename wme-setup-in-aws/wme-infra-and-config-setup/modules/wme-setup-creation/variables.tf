
variable "wme_installer_url" {
  description = "wme installer link"
  type        = string
  default     = ""

}
variable "wme_patch_installer_url" {
  description = "wme patch installer link"
  type        = string
  default     = ""

}
variable "operating_system" {
  description = "type of os for wme instances"
  type        = string
  default     = "ubuntu"

}
variable "ubuntu_os_user_name" {
  description = "user name of ubuntu instance"
  type        = string
  default     = "ubuntu"

}

variable "RHEL_os_user_name" {
  description = "user name of RHEL instance"
  type        = string
  default     = "ec2-user"

}



variable "operating_version" {
  description = "RHEL os version for wme setup"
  type        = string
  default     = "7"
}


variable "private_keypath_in_local" {
  description = "pemfile location in local for instance ssh"
  type        = string

}


variable "instance_type" {
  description = "type of instance for platform instance"
  type        = string
  default     = "t2.xlarge"

}
variable "public_subnet_id" {
  description = "Id of public subnet to launch platform instance"
  type        = string
  default     = ""

}

variable "private_subnet_id" {
  description = "Id of private subnet to launch studio and appdeploy instance"
  type        = string
  default     = ""

}

variable "pemfilename_in_aws" {
  description = "pemfilename_in_aws for ssh into machine"
  type        = string

}

variable "vpc_id" {
  description = "vps id for creating security groups and instance"
  type        = string

}

variable "setup_admin_password" {
  description = "setup admin user password"
  type        = string
  default     = "Wme@1234"

}

variable "enterpise_name" {
  description = "name of the enterprise"
  type        = string

}

variable "admin_Email_Address" {
  description = "email address of the user"
  type        = string

}

variable "admin_user_firstname" {
  description = "first name of the launchpad admin user"
  type        = string

}

variable "admin_user_lastname" {
  description = "last name of the launchpad admin user"
  type        = string

}

variable "admin_user_password" {
  description = "launchpad admin user password"
  type        = string
  default     = "Wme@1234"

}

variable "setup_with_custom_sshkeys" {
  description = "setup wme with custom user"
  type        = string
  default     = ""
}

variable "internal_user_for_wavemaker" {
  description = "custom user name for comminication between platform ,studio and appdeploy instances in setup"
  type        = string
  default     = "wave"
}




variable "wavemaker_built_apps_domain" {
  description = "custom cloud domain name example: wm-app.myent.com"
  type        = string
}

variable "wavemaker_studio_domain" {
  description = "custom enterprise domain name"
  type        = string
}

variable "ssh_ip_cidr_range" {
  description = "ssh IP ranges for platform , studio and appdeploy instances"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}


variable "ami_image_id" {
  description = "ami id for platform, studio and appdeploy instances"
  type        = string
  default     = ""
}

variable "network_interface_name" {
  description = "platform instance network interface name"
  type        = string
  default     = "eth0"
}

variable "cidr_range_for_docker_setup" {
  description = "CIDR range for setup docker container networks in WME"
  type        = string
  default     = "10.3.1.1/24"
}

variable "internal_user_ssh_key_for_wavemaker" {
  description = "custom user private key path in local"
  type        = string
  default     = ""
}

variable "wme_sha1sum_url" {
  description = "sha1sum file url for checking wme file sha1sum"
  type  = string
  default = ""
}

variable "no_of_appdeployment_instances" {
  description = "no of appdeployment instances"
  type  = number
  default = 1
}

variable "no_of_studio_workspace_instances" {
  description = "no fo studio workspace instances"
  type = number
  default = 1
}