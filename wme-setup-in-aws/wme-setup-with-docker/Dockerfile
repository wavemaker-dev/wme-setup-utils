FROM hashicorp/terraform:latest as terraform
RUN terraform version



FROM ubuntu:18.04
ENV DEBIAN_FRONTEND noninteractive
# prerequisites installation
RUN apt-get update && apt-get install -y wget unzip python3-pip vim curl python3 openssh-server
RUN service ssh start
# copying terraform bin file from terraform base image
COPY --from=terraform /bin/terraform /bin/
# installing aws cli
RUN curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip awscliv2.zip && ./aws/install -i /usr/local/aws-cli -b /usr/local/bin
# installing ansible
RUN pip3 install ansible && ln -s ~/.local/bin/ansible /usr/bin/ansible && mkdir /etc/ansiblei \
    && mkdir -p /usr/local/wme-setup/module/wme-setup-creation/ && mkdir -p /usr/local/wme-setup/service/
ADD ./ansible.cfg /etc/ansible/
ADD ./wme-setup-creation /usr/local/wme-setup/module/wme-setup-creation/
ADD ./service /usr/local/wme-setup/service/
WORKDIR /usr/local/wme-setup/service/                                                

# image name: wmdevops/oneclick-wme-setup-tool:<version>