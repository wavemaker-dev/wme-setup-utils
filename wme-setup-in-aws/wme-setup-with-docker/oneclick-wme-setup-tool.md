# oneclick-wme-setup-tool

- oneclick-wme-setup-tool is setting up WME by running Docker container using wmdevops/oneclick-wme-setup-tool docker image
- Softwares Installed in Docker image
  - Terraform Latest version
  - aws cli version 2
  - pip3
  - python3 and
  - ansible latest stable version

## Terraform Module
  
- Terraform Module consists of main.tf, variable.tf and output.tf for infrastructure creation and also have ansible playbooks for instances configuration
- The default Module is located in container at **/usr/local/wme-setup/module/wme-setup-creation/**
- If the user want to use the customized module mount module as a volume and specify the module location in service main.tf file
- example docker command: wme setup with custom terraform module
  
  ```shell
     docker container run -d --rm -it --name <container-name> --network host -v <aws-credentiaas-file>:/root/.aws/ -v <private-key-location>:<private-key-location-in-docker> -v <terraform-service-file-location>:/usr/local/wme-setup/service/ -v <terraform-custom-module-file-location>:<terraform-custom-module-file-location-in-docker> wmdevops/oneclick-wme-setup-tool:<version> /bin/bash -c "terraform init;terraform validate;terraform apply"
  ```

- example Docker command: wme setup with default terraform module

    ```shell
        docker container run -d --rm -it --name <container-name> --network host -v <aws-credentiaas-file>:/root/.aws/ -v <private-key-location>:<private-key-location-in-docker> -v <terraform-service-file-location>:/usr/local/wme-setup/service/ wmdevops/oneclick-wme-setup-tool:<version> /bin/bash -c "terraform init;terraform validate;terraform apply"
    ```

- **aws-credentials-file** are aws credentials and config file for communicating with aws for resources creation, and set profile for credentilas as default or mention you own profile in service main.tf file at profile variable.
- **private-key-location** consists of private keys for ssh into instance and for the internal user of wavemaker(custom user)
- **private-key-location-in-docker** have to specify in service main.tf file .
- **terraform-service-file-location** is location of service files main.tf and output.tf in local
- **local/content/wme-setup/service/** is default service files location in docker container
- **terraform-custom-module-file-location** is custom module location in local, if you user want to create wme setup with custom terraform module
- **terraform-custom-module-file-location-in-docker** is terraform module location in Docker container , and also user have to specify this location in main.tf file of service

## Terraform service

- Terraform service consists of files main.tf and outout.tf with the desired values for wme creation

## example command

 docker container run --rm -it --name wmesetup --network host -v ~/.aws:/root/.aws/  -v ~/pemfile:/usr/local/private_key/ -v ~/services:/usr/local/wme-setup/service/ wmdevops/oneclick-wme-setup-tool:1.0 /bin/bash -c "terraform init;terraform validate;terraform apply"
