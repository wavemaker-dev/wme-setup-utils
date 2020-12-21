data "aws_ami" "wme_ubuntu_ami" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }


}

data "aws_ami" "wme_rhel7_ami" {
  most_recent = true
  owners      = ["309956199498"]
  filter {
    name   = "name"
    values = ["RHEL-7.7_HVM-20190923-x86_64-0-Hourly2-GP2*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

data "aws_ami" "wme_rhel8_ami" {
  most_recent = true
  owners      = ["309956199498"]
  filter {
    name   = "name"
    values = ["RHEL-8.2.0_HVM-20200423-x86_64-0-Hourly2-GP2*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

locals {
  user_name = var.operating_system == "rhel" ? var.RHEL_os_user_name : var.ubuntu_os_user_name
}



resource "aws_instance" "Platform" {
  ami                         = (var.ami_image_id == "" ? (var.operating_system == "rhel" ? (var.operating_version == "7" ? data.aws_ami.wme_rhel7_ami.image_id : data.aws_ami.wme_rhel8_ami.image_id) : data.aws_ami.wme_ubuntu_ami.image_id) : var.ami_image_id)
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.WME-SG-Platform-Public.id, aws_security_group.WME-SG-Platform-Internal.id]
  key_name                    = var.pemfilename_in_aws
  #associate_public_ip_address = true
  depends_on                  = [aws_security_group.WME-SG-Platform-Internal, aws_security_group.WME-SG-Platform-Public]
  tags = {
    Name = "WME-platform-Instance-${var.enterpise_name}"
  }
  volume_tags = {
    Name = "WME-platform-Instance-${var.enterpise_name}"
    Env = "wme-dev"
  }
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "50"
    delete_on_termination = true
  }
  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_type           = "gp2"
    volume_size           = "150"
    delete_on_termination = true
  }
  ebs_block_device {
    device_name           = "/dev/sdc"
    volume_type           = "gp2"
    volume_size           = "50"
    delete_on_termination = true
  }
  connection {
    type        = "ssh"
    user        = local.user_name
    private_key = file(var.private_keypath_in_local)
    host        = self.public_ip
  }

  
  timeouts {
    create = "30m"
    delete = "10m"
  }

}


resource "aws_instance" "StudioWorkspace" {
  ami                    = (var.ami_image_id == "" ? (var.operating_system == "rhel" ? (var.operating_version == "7" ? data.aws_ami.wme_rhel7_ami.image_id : data.aws_ami.wme_rhel8_ami.image_id) : data.aws_ami.wme_ubuntu_ami.image_id) : var.ami_image_id)
  instance_type          = var.instance_type
  count                  = var.no_of_studio_workspace_instances
  subnet_id              = var.private_subnet_id #private_subnet_id
  vpc_security_group_ids = [aws_security_group.WME-SG-Workspace-Internal.id]
  key_name               = var.pemfilename_in_aws
  #associate_public_ip_address = true
  depends_on = [aws_security_group.WME-SG-Workspace-Internal]
  tags = {
    Name = "WME-studio-workspace-Instance-${var.enterpise_name}-${count.index}"
  }
  
  volume_tags = {
    Name = "WME-studio-workspace-Instance-${var.enterpise_name}-${count.index}"
    Env = "wme-dev"
  }
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "50"
    delete_on_termination = true
  }
  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_type           = "gp2"
    volume_size           = "150"
    delete_on_termination = true
  }
  connection {
    type        = "ssh"
    user        = local.user_name
    private_key = file(var.private_keypath_in_local)
    host        = self.public_ip
  }

  timeouts {
    create = "30m"
    delete = "10m"
  }

}
resource "aws_instance" "AppDeployment" {
  ami                    = (var.ami_image_id == "" ? (var.operating_system == "rhel" ? (var.operating_version == "7" ? data.aws_ami.wme_rhel7_ami.image_id : data.aws_ami.wme_rhel8_ami.image_id) : data.aws_ami.wme_ubuntu_ami.image_id) : var.ami_image_id)
  instance_type          = var.instance_type
  count                  = var.no_of_appdeployment_instances
  subnet_id              = var.private_subnet_id #private_subnet_id
  vpc_security_group_ids = [aws_security_group.WME-SG-Workspace-Internal.id]
  key_name               = var.pemfilename_in_aws
  #associate_public_ip_address = true
  depends_on = [aws_security_group.WME-SG-Workspace-Internal]
  tags = {
    Name = "WME-AppDeployment-Instance-${var.enterpise_name}-${count.index}"
  }
  volume_tags = {
    Name = "WME-AppDeployment-Instance-${var.enterpise_name}-${count.index}"
    Env = "wme-dev"
  }
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "50"
    delete_on_termination = true
  }
  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_type           = "gp2"
    volume_size           = "150"
    delete_on_termination = true
  }

  connection {
    type        = "ssh"
    user        = local.user_name
    private_key = file(var.private_keypath_in_local)
    host        = self.public_ip
  }

  timeouts {
    create = "30m"
    delete = "10m"
  }
}




resource "aws_security_group" "WME-SG-Platform-Public" {
  name        = "WME-SG-Platform-Public-${var.enterpise_name}"
  description = "Access Platfrom from Developer Workstation"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Platform HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Config Portal"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_ip_cidr_range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WME-Platform_Public-${var.enterpise_name} "
  }

}

resource "aws_security_group" "WME-SG-Platform-Internal" {
  name        = "WME-SG-Platform-Internal-${var.enterpise_name}"
  description = "Access Platfrom Instance from Studio workspace/AppDeployment Instance"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WME-Platform_Internal-${var.enterpise_name}"
  }

}

resource "aws_security_group" "WME-SG-Workspace-Internal" {
  name        = "WME-SG-Workspace-Internal-${var.enterpise_name}"
  description = "Access StudioWorkspace/AppDeployment Instance from Platfrom Instance"
  vpc_id      = var.vpc_id


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WME-workspace_Internal-${var.enterpise_name} "
  }

}

resource "aws_security_group_rule" "platform-internal-backupserver" {
  type                     = "ingress"
  from_port                = 2200
  to_port                  = 2200
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.WME-SG-Workspace-Internal.id
  security_group_id        = aws_security_group.WME-SG-Platform-Internal.id

}
resource "aws_security_group_rule" "platform-internal-Platform_Instance_AppRegistry" {
  type                     = "ingress"
  from_port                = 5000
  to_port                  = 5000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.WME-SG-Workspace-Internal.id
  security_group_id        = aws_security_group.WME-SG-Platform-Internal.id

}
resource "aws_security_group_rule" "platform-internal-Platform_Instance_Studio_and_Cloud_Internal_Service" {
  type                     = "ingress"
  from_port                = 8000
  to_port                  = 8020
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.WME-SG-Workspace-Internal.id
  security_group_id        = aws_security_group.WME-SG-Platform-Internal.id

}
resource "aws_security_group_rule" "platform-internal-consoul" {
  type                     = "ingress"
  from_port                = 8500
  to_port                  = 8500
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.WME-SG-Workspace-Internal.id
  security_group_id        = aws_security_group.WME-SG-Platform-Internal.id

}
resource "aws_security_group_rule" "platform-internal-Elastic_Search" {
  type                     = "ingress"
  from_port                = 9200
  to_port                  = 9200
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.WME-SG-Workspace-Internal.id
  security_group_id        = aws_security_group.WME-SG-Platform-Internal.id

}
resource "aws_security_group_rule" "platform-internal-gitlab" {
  type                     = "ingress"
  from_port                = 8081
  to_port                  = 8081
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.WME-SG-Workspace-Internal.id
  security_group_id        = aws_security_group.WME-SG-Platform-Internal.id

}

resource "aws_security_group_rule" "platform-internal-external_instance_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.WME-SG-Workspace-Internal.id
  security_group_id        = aws_security_group.WME-SG-Platform-Internal.id

}

# workspace instance security groups rules

resource "aws_security_group_rule" "workspace-internal-remote-studio" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.WME-SG-Platform-Internal.id
  security_group_id        = aws_security_group.WME-SG-Workspace-Internal.id

}
resource "aws_security_group_rule" "workspace-internal-App_Deployment_Instance_User_container_ssh" {
  type                     = "ingress"
  from_port                = 2200
  to_port                  = 2299
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.WME-SG-Platform-Internal.id
  security_group_id        = aws_security_group.WME-SG-Workspace-Internal.id

}
resource "aws_security_group_rule" "workspace-internal-HTTP" {
  type                     = "ingress"
  from_port                = 8001
  to_port                  = 8099
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.WME-SG-Platform-Internal.id
  security_group_id        = aws_security_group.WME-SG-Workspace-Internal.id

}
resource "aws_security_group_rule" "workspace-internal-User_Workspace_instance_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.WME-SG-Platform-Internal.id
  security_group_id        = aws_security_group.WME-SG-Workspace-Internal.id

}
resource "aws_security_group_rule" "workspace-internal-pm2" {
  type                     = "ingress"
  from_port                = 5000
  to_port                  = 5000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.WME-SG-Platform-Internal.id
  security_group_id        = aws_security_group.WME-SG-Workspace-Internal.id

}
resource "aws_security_group_rule" "workspace-internal-rs-jmx" {
  type                     = "ingress"
  from_port                = 9404
  to_port                  = 9404
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.WME-SG-Platform-Internal.id
  security_group_id        = aws_security_group.WME-SG-Workspace-Internal.id

}
resource "aws_security_group_rule" "workspace-internal-jmx" {
  type                     = "ingress"
  from_port                = 9500
  to_port                  = 9599
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.WME-SG-Platform-Internal.id
  security_group_id        = aws_security_group.WME-SG-Workspace-Internal.id

}
resource "aws_security_group_rule" "workspace-internal-mysql" {
  type                     = "ingress"
  from_port                = 3300
  to_port                  = 3399
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.WME-SG-Platform-Internal.id
  security_group_id        = aws_security_group.WME-SG-Workspace-Internal.id

}

resource "aws_security_group_rule" "workspace-internal-fluentd-workspace-internal-cadviser-node_exporter" {
  type                     = "ingress"
  from_port                = 9100
  to_port                  = 9102
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.WME-SG-Platform-Internal.id
  security_group_id        = aws_security_group.WME-SG-Workspace-Internal.id

}


resource "aws_security_group_rule" "docker" {
  type                     = "ingress"
  from_port                = 2375
  to_port                  = 2375
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.WME-SG-Platform-Internal.id
  security_group_id        = aws_security_group.WME-SG-Workspace-Internal.id

}

resource "aws_security_group_rule" "ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  cidr_blocks              = var.ssh_ip_cidr_range
  security_group_id        = aws_security_group.WME-SG-Workspace-Internal.id

}