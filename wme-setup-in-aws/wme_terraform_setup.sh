#!/bin/bash
set -e
file_location="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $file_location
terraform_setup_source=$file_location

wme_creation() {

    case "$setup_type" in
      # Whole setup
      full_setup)
        terraform_setup_source+="/wme-automation-jenkins/jenkins_service/infra_and_config/"
        cd $terraform_setup_source
        terraform_validation
        terraform apply -auto-approve -var 'region='"$wme_region"'' -var 'user_license_file='"$wme_license_file"'' -var 'instance_addition_operation='"$wme_external_instance_addition"'' -var 'WME_platform_configurations='"$wme_platform_instance_configuration"'' -var 'access_key='"$wme_access_key"'' -var 'secret_key='"$wme_secret_key"'' -var 'public_subnet_id='"$wme_public_subnet_id"'' -var 'private_subnet_id='"$wme_private_subnet_id"'' -var 'ami_image_id='"$wme_ami_image_id"'' -var 'no_of_appdeployment_instances='"$no_of_app_deploy_instances"'' -var 'no_of_studio_workspace_instances='"$no_of_studio_instances"'' -var 'instance_type='"$wme_instance_type"'' -var 'pemfilename_in_aws='"$wme_pemfilename_in_aws"'' -var 'vpc_id='"$wme_vpc_id"'' -var 'private_keypath_in_local='"$wme_private_keypath_in_local"'' -var 'ssh_ip_cidr_range='"$ssh_cidr_range"''   -var 'wme_installer_url='"$wme_setup_url"'' -var 'wme_sha1sum_url='"$wme_sha1sum_file_url"''  -var 'setup_admin_password='"$wme_setup_admin_password"'' -var 'enterpise_name='"$wme_enterprise_name"'' -var 'admin_Email_Address='"$wme_admin_Email_Address"'' -var 'admin_user_firstname='"$wme_admin_user_firstname"'' -var 'admin_user_lastname='"$wme_admin_user_lastname"'' -var 'admin_user_password='"$wme_admin_user_password"'' -var 'operating_system='"$wme_operating_system"'' -var 'operating_version='"$wme_operating_version"'' -var 'ubuntu_os_user_name='"$os_username"'' -var 'RHEL_os_user_name='"$os_username"''  -var 'setup_with_custom_sshkeys='"$wme_setup_with_custom_sshkeys"'' -var 'internal_user_for_wavemaker='"$wme_internal_user_for_wavemaker"'' -var 'internal_user_ssh_key_for_wavemaker='"$internal_user_sshkey_for_wavemaker"''  -var 'wavemaker_built_apps_domain='"$wavemaker_built_apps_domain_name"'' -var 'wavemaker_studio_domain='"$wavemaker_studio_domain_name"'' -var 'network_interface_name='"$wme_network_interface_name"'' -var 'cidr_range_for_docker_setup='"$wme_cidr_range_for_docker_setup"'';;
     # Only infrastructure
      only_infrastructure)
        terraform_setup_source+="/wme-automation-jenkins/jenkins_service/infra/"
        cd $terraform_setup_source
        terraform_validation
        terraform apply -auto-approve -var 'region='"$wme_region"'' -var 'access_key='"$wme_access_key"'' -var 'secret_key='"$wme_secret_key"'' -var 'public_subnet_id='"$wme_public_subnet_id"'' -var 'private_subnet_id='"$wme_private_subnet_id"'' -var 'ami_image_id='"$wme_ami_image_id"'' -var 'no_of_appdeployment_instances='"$no_of_app_deploy_instances"'' -var 'no_of_studio_workspace_instances='"$no_of_studio_instances"'' -var 'instance_type='"$wme_instance_type"'' -var 'pemfilename_in_aws='"$wme_pemfilename_in_aws"'' -var 'vpc_id='"$wme_vpc_id"'' -var 'private_keypath_in_local='"$wme_private_keypath_in_local"'' -var 'ssh_ip_cidr_range='"$ssh_cidr_range"'' -var 'enterpise_name='"$wme_enterprise_name"'' -var 'operating_system='"$wme_operating_system"'' -var 'operating_version='"$wme_operating_version"'' -var 'ubuntu_os_user_name='"$os_username"'' -var 'RHEL_os_user_name='"$os_username"'';;
    esac
}


terraform_validation() {
    terraform init .
    terraform validate
    validate_status=$?
    if [ "$validate_status" != 0 ]
    then
        exit
    fi
}


wme_destroy() {
  # Add Location wrt build number
    case "$setup_type" in
      # Whole setup
      full_setup)
        terraform_setup_source+="/wme-automation-jenkins/jenkins_service/infra_and_config/"
        cd $terraform_setup_source
        terraform_validation
        terraform destroy -auto-approve -var 'region='"$wme_region"'' -var 'access_key='"$wme_access_key"'' -var 'wme_platform_version='"$wme_platform_version"'' -var 'secret_key='"$wme_secret_key"'' -var 'public_subnet_id='"$wme_public_subnet_id"'' -var 'private_subnet_id='"$wme_private_subnet_id"'' -var 'no_of_appdeployment_instances='"$no_of_app_deploy_instances"'' -var 'no_of_studio_workspace_instances='"$no_of_studio_instances"'' -var 'instance_type='"$wme_instance_type"'' -var 'pemfilename_in_aws='"$wme_pemfilename_in_aws"'' -var 'vpc_id='"$wme_vpc_id"'' -var 'private_keypath_in_local='"$wme_private_keypath_in_local"''  -var 'enterpise_name='"$wme_enterprise_name"'' -var 'admin_Email_Address='"$wme_admin_Email_Address"'' -var 'admin_user_firstname='"$wme_admin_user_firstname"'' -var 'admin_user_lastname='"$wme_admin_user_lastname"''  -var 'internal_user_ssh_key_for_wavemaker='"$internal_user_sshkey_for_wavemaker"''  -var 'wavemaker_built_apps_domain='"$wavemaker_built_apps_domain_name"'' -var 'wavemaker_studio_domain='"$wavemaker_studio_domain_name"'';;
     # Only infrastructure
      only_infrastructure)
        terraform_setup_source+="/wme-automation-jenkins/jenkins_service/infra/"
        cd $terraform_setup_source
        terraform_validation
        terraform destroy -auto-approve -var 'region='"$wme_region"'' -var 'access_key='"$wme_access_key"'' -var 'secret_key='"$wme_secret_key"'' -var 'public_subnet_id='"$wme_public_subnet_id"'' -var 'private_subnet_id='"$wme_private_subnet_id"'' -var 'no_of_appdeployment_instances='"$no_of_app_deploy_instances"'' -var 'no_of_studio_workspace_instances='"$no_of_studio_instances"'' -var 'instance_type='"$wme_instance_type"'' -var 'pemfilename_in_aws='"$wme_pemfilename_in_aws"'' -var 'vpc_id='"$wme_vpc_id"'' -var 'private_keypath_in_local='"$wme_private_keypath_in_local"''  -var 'enterpise_name='"$wme_enterprise_name"'' -var 'admin_Email_Address='"$wme_admin_Email_Address"'' -var 'admin_user_firstname='"$wme_admin_user_firstname"'' -var 'admin_user_lastname='"$wme_admin_user_lastname"''  -var 'internal_user_ssh_key_for_wavemaker='"$internal_user_sshkey_for_wavemaker"''  -var 'wavemaker_built_apps_domain='"$wavemaker_built_apps_domain_name"'' -var 'wavemaker_studio_domain='"$wavemaker_studio_domain_name"'';;
    esac
}


ansible_configuration() {
      ansible_location=$file_location
      ansible_location+="/wme-infra-config-with-ansible/wme_setup_scripts"
      cd $ansible_location
      case "$setup_type" in
            platform_instance)
                ansible-playbook -u $os_username -i ''"$wme_platform_public_ip"',' --private-key $wme_private_keypath_in_local -e 'wme_installer_url="'"$wme_setup_url"'" wme_platform_version='"$wme_platform_version"'  user_license_file='"$wme_license_file"' appdeploy_instance_private_ip='"$AppDeploymenet_instance_private_ip"' instance_addition_operation='"$wme_external_instance_addition"' studio_workspace_instance_private_ip='"$studio_instance_private_ip"'  network_interface_name="'"$wme_network_interface_name"'" cidr_range_for_docker_setup="'"$wme_cidr_range_for_docker_setup"'"  os_user_name="'"$os_username"'" internal_user_ssh_key_for_wavemaker="'"$internal_user_sshkey_for_wavemaker"'"    internal_user_for_wavemaker="'"$wme_internal_user_for_wavemaker"'" platform_instance_ip="'"$wme_platform_public_ip"'" wavemaker_studio_domain="'"$wavemaker_studio_domain_name"'" wavemaker_built_apps_domain="'"$wavemaker_built_apps_domain_name"'" setup_admin_password="'"$wme_setup_admin_password"'" enterprise_name="'"$wme_enterprise_name"'" admin_Email_Address="'"$wme_admin_Email_Address"'" admin_user_firstname="'"$wme_admin_user_firstname"'" admin_user_lastname="'"$wme_admin_user_lastname"'" admin_user_password="'"$wme_admin_user_password"'" operating_version="'"$wme_operating_version"'"  wme_sha1sum_url="'"$wme_sha1sum_file_url"'"  setup_with_custom_sshkeys="'"$wme_setup_with_custom_sshkeys"'"' platform_instance_setup.yml -vv 
                ;;
            studio_and_appDeploy)
                ansible-playbook -u $os_username -i ''"$wme_external_instance_public_ip"',' --private-key $wme_private_keypath_in_local -e 'operating_version="'"$wme_operating_version"'"  wme_platform_version='"$wme_platform_version"' os_user_name="'"$os_username"'" internal_user_ssh_key_for_wavemaker="'"$internal_user_sshkey_for_wavemaker"'" setup_with_custom_sshkeys="'"$wme_setup_with_custom_sshkeys"'" internal_user_for_wavemaker="'"$wme_internal_user_for_wavemaker"'"' external_instance_setup.yml -vv
                ;;
            platform_and_studio_app_deploy)
                ansible-playbook -u $os_username -i ''"$wme_platform_public_ip"',' --private-key $wme_private_keypath_in_local -e 'wme_installer_url="'"$wme_setup_url"'" wme_platform_version='"$wme_platform_version"'  user_license_file='"$wme_license_file"' appdeploy_instance_private_ip='"$AppDeploymenet_instance_private_ip"' instance_addition_operation='"$wme_external_instance_addition"' studio_workspace_instance_private_ip='"$studio_instance_private_ip"' network_interface_name="'"$wme_network_interface_name"'" cidr_range_for_docker_setup="'"$wme_cidr_range_for_docker_setup"'"  os_user_name="'"$os_username"'" internal_user_ssh_key_for_wavemaker="'"$internal_user_sshkey_for_wavemaker"'"    internal_user_for_wavemaker="'"$wme_internal_user_for_wavemaker"'" platform_instance_ip="'"$wme_platform_public_ip"'" wavemaker_studio_domain="'"$wavemaker_studio_domain_name"'" wavemaker_built_apps_domain="'"$wavemaker_built_apps_domain_name"'" setup_admin_password="'"$wme_setup_admin_password"'" enterprise_name="'"$wme_enterprise_name"'" admin_Email_Address="'"$wme_admin_Email_Address"'" admin_user_firstname="'"$wme_admin_user_firstname"'" admin_user_lastname="'"$wme_admin_user_lastname"'" admin_user_password="'"$wme_admin_user_password"'" operating_version="'"$wme_operating_version"'"  wme_sha1sum_url="'"$wme_sha1sum_file_url"'"  setup_with_custom_sshkeys="'"$wme_setup_with_custom_sshkeys"'"' platform_instance_setup.yml -vv
                ansible-playbook -u $os_username -i ''"$wme_external_instance_public_ip"',' --private-key $wme_private_keypath_in_local -e 'operating_version="'"$wme_operating_version"'"  wme_platform_version='"$wme_platform_version"'  os_user_name="'"$os_username"'" internal_user_ssh_key_for_wavemaker="'"$internal_user_sshkey_for_wavemaker"'" setup_with_custom_sshkeys="'"$wme_setup_with_custom_sshkeys"'" internal_user_for_wavemaker="'"$wme_internal_user_for_wavemaker"'"' external_instance_setup.yml -vv
                ;;
      esac

}


while getopts i:a:s:k:K:r:o:v:f:l:e:p:P:m:S:V:O:F:c:b:A:W:T:I:C:h:U:w:u:d:D:n:B:z:q:E:L:g:G:H:j:  options
do
    case "${options}" in
        o) operation=${OPTARG};;
        i) wme_setup_url=${OPTARG};;
        a) wme_access_key=${OPTARG};;
        s) wme_secret_key=${OPTARG};;
        K) wme_private_keypath_in_local=${OPTARG};;   # caps K
        k) wme_pemfilename_in_aws=${OPTARG};;
        r) wme_region=${OPTARG};;
        v) wme_operating_version=${OPTARG};;
        f) wme_admin_user_firstname=${OPTARG};;
        l) wme_admin_user_lastname=${OPTARG};;
        e) wme_enterprise_name=${OPTARG};;
        p) wme_admin_user_password=${OPTARG};;
        P) wme_setup_admin_password=${OPTARG};;  # caps P
        m) wme_admin_Email_Address=${OPTARG};;
        S) wme_public_subnet_id=${OPTARG};;
        V) wme_vpc_id=${OPTARG};;
        O) wme_operating_system=${OPTARG};;
        c) wme_setup_with_custom_sshkeys=${OPTARG};;
        b) wme_private_subnet_id=${OPTARG};;
        A) no_of_app_deploy_instances=${OPTARG};;
        W) no_of_studio_instances=${OPTARG};;
        T) wme_instance_type=${OPTARG};;
        I) wme_ami_image_id=${OPTARG};;
        C) ssh_cidr_range=${OPTARG};;
        h) wme_sha1sum_file_url=${OPTARG};;
        U) os_username=${OPTARG};;
        w) wme_internal_user_for_wavemaker=${OPTARG};;
        u) internal_user_sshkey_for_wavemaker=${OPTARG};;
        d) wavemaker_built_apps_domain_name=${OPTARG};;
        D) wavemaker_studio_domain_name=${OPTARG};;
        n) wme_network_interface_name=${OPTARG};;
        B) wme_cidr_range_for_docker_setup=${OPTARG};;
        z) setup_type=${OPTARG};;
        q) wme_external_instance_public_ip=${OPTARG};;
        E) wme_external_instance_addition=${OPTARG};;
        L) wme_license_file=${OPTARG};;
        g) studio_instance_private_ip=${OPTARG};;
        G) AppDeploymenet_instance_private_ip=${OPTARG};;
        H) wme_platform_instance_configuration=${OPTARG};;
        j) wme_platform_version=${OPTARG};;


    esac
done


if [ "$#" -gt 1 ]
then
    case $operation in
        creation) 
            wme_creation
            ;;
        deletion)
            wme_destroy
            ;;
        upgrade)
            wme_update
            ;;
        configuration)
            ansible_configuration
            ;;
    esac
fi


# operations
# wme_terraform_setup.sh -o creation
# wme_terraform_setup.sh -o deletion
# wme_terraform_setup.sh -o upgrade
# wme_terraform_setup.sh -o configuration
