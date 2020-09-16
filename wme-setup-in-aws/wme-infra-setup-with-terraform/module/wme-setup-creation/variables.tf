

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


variable "enterpise_name" {
  description = "name of the enterprise"
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