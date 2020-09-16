output "platform_instance_public_ip" {
  description = "public ip of platform Instance"
  value       = aws_instance.Platform.public_ip
}
output "StudioWorkspace_instance_public_ip" {
  description = "public ip of StudioWorkspace Instance"
  value       = aws_instance.StudioWorkspace[*].public_ip
}
output "AppDeployment_instance_public_ip" {
  description = "public IP of AppDeployment Instance"
  value       = aws_instance.AppDeployment[*].public_ip
}

output "StudioWorkspace_instance_private_ip" {
  description = "private IP of StudioWorkspace Instance"
  value       = aws_instance.StudioWorkspace[*].private_ip
}

output "AppDeployment_instance_private_ip" {
  description = "private IP of APPDeployment Instance"
  value       = aws_instance.AppDeployment[*].private_ip
}

output "platform_security_group_public" {
  description = "wme-sg-platform-public-id"
  value       = aws_security_group.WME-SG-Platform-Public.id
}

output "platform_security_groups_Internal" {
  description = "wme-sg-platform-internal-id"
  value       = aws_security_group.WME-SG-Platform-Internal.id
}

output "workspace_security_group_Internal" {
  description = "wme-sg-workspace-internal-id"
  value       = aws_security_group.WME-SG-Workspace-Internal.id
}

