# wme-infra-config-with-ansible

## prerequisites for operation

- Terraform
- Python
- Pip and
- Ansible

:::note
set host key checking as false in ansible configuration file ansible.cfg
disabled to avoid errors during SSH login for automatomation process.
host_key_checking = False
:::

NOTE: make sure have a connection between terraform host and instances network, or else it will fail to configure the infrastructure

## infrastructure configuration deatils and process

- wme-infra-config-with-ansible folder consists ansible playbook files for provisioning instances
- The ansible playbooks are
  - platform_instance_setup.yml
  - external_instance_setup.yml
- The platform_instance_setup.yml file provision platform instance ,in process it will create file system for volumes , mount volumes , install prerequisites, downloading wme installer file , create user and wme configwizard setup process
- The external_instance_setup.yml file provision studio workspace and appdeploy instances , in process it will create file system for volumes , mount volumes , installing prerequisites

- example command for execute the platform_instance_setup.yml playbook

```shell
 ansible-playbook -u <os_user_name> -i '<IP-Address>,' --private-key <private_key_path> -e 'wme_installer_url="<wme-installation-url>" network_interface_name="eth0" cidr_range_for_docker_setup="10.3.1.1/24"  os_user_name="ec2-user" internal_user_ssh_key_for_wavemaker="/home/user/wme-setup.pem"    internal_user_for_wavemaker="<myuser>" platform_instance_ip="<platform-instance-public-ip>" wavemaker_studio_domain="<mydomain.com>" wavemaker_built_apps_domain="<myappsdomain.com>" setup_admin_password="Wme@1234" enterprise_name="myent" admin_Email_Address="<myadmin@ent.com>" admin_user_firstname="<myfirstname>" admin_user_lastname="<mylastname>" admin_user_password="Wme@1234" operating_version="7"  wme_sha1sum_url="<wme-sha1sumfile-url>"  setup_with_custom_sshkeys="yes"' wme_setup_scripts/platform_instance_setup.yml -vv

```

- example command for excute the external_instance_setup.yml playbook

```shell
 ansible-playbook -u <os_user_name> -i '<IP-Address>,' --private-key /home/user/wme-setup.pem -e 'operating_version="7"  os_user_name="ec2-user" internal_user_ssh_key_for_wavemaker="/home/user/wme-setup.pem" setup_with_custom_sshkeys="yes" internal_user_for_wavemaker="myuser"' wme_setup_scripts/external_instance_setup.yml -vv

```

## list of variables

- **os_user_name** is username of operating system . example ubuntu, ec2-user, centos
- **IP-Address** is public or private IP address for ssh in to instance
- **private_key_path** is location of private key in local for ssh in to instance. example /home/user/wme-setup.pem
- **wme_installer_url** wme installer url for downloading the wme setup  provided by wavemaker team
- **network_interface_name** is name of network interface in platform instance. example eth0 , ens33
- **cidr_range_for_docker_setup** it is CIDR network range for docker containers. examples 10.3.1.1/24
- **internal_user_ssh_key_for_wavemaker** is the private key path for internal wavemaker user . example /home/user/mykey.pem
- **internal_user_for_wavemaker** is used for internal communication in WME . example myuser. dont give wavemaker
- **platform_instance_ip** is public IP addres  of platform instance used for config wizard setup
- **wavemaker_studio_domain** is domain name for wavemaker which user has to register. example studio.mydomain.com
- **wavemaker_built_apps_domain** is domain name for wavemaker developed apps. example apps.mydomain.com
- **setup_admin_password** the password setup admin for installing WME in config wizard and password must be wavemaker password standard
- **enterprise_name** name of enterprise for wme setup. example myent
- **admin_Email_Address** is admin user email address for login to launchpad
- **admin_user_firstname** first name of admin user
- **admin_user_lastname** admin user last name
- **wme_sha1sum_url** is wme sha1sum file url
- **admin_user_password** admin user pasword for login to launchpad and password must be wavemaker password standard
- **operating_version** is operating system version for installing some prerequisites operations
- **setup_with_custom_sshkeys** available options yes and no. if select **yes** , user have to provide username for **internal_user_for_wavemaker** and **internal_user_ssh_key_for_wavemaker**.if **no** provide **empty** values for **internal_user_for_wavemaker** and **internal_user_ssh_key_for_wavemaker**
