output "platform_instance_public_ip" {
  description = "public ip of platform instance"
  value       = module.WME-setup.platform_instance_public_ip
}
output "WME-SG-Platform-Public-id" {
  value = module.WME-setup.platform_security_group_public
}
output "WME-SG-Platform-Internal-id" {
  value = module.WME-setup.platform_security_groups_Internal
}
output "WME-SG-Workspace-Internal-id" {
  value = module.WME-setup.workspace_security_group_Internal
}
output "StudioWorkspace_instance_public_ip" {
  description = "public ip of external instance"
  value       = module.WME-setup.StudioWorkspace_instance_public_ip
}
output "AppDeployment_instance_public_ip" {
  description = "public ip of external instance"
  value       = module.WME-setup.AppDeployment_instance_public_ip
}
output "StudioWorkspace_instance_private_IP" {
  value = module.WME-setup.StudioWorkspace_instance_private_ip
}
output "APPDeployment_instance_private_IP" {
  value = module.WME-setup.AppDeployment_instance_private_ip
}

