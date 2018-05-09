#!/bin/bash
# Version 1.0
# Written by: WenZan.Shaofeng.Peng

# This script is used for installing the platform
# in a new Community ENTerprise Operating System.
# This script should be run as root user.

### when error occurred, exit
#set -o errexit
set -euxo pipefail

### install need root user.
if [ $(whoami) != "root" ]; then
    echo " Need root user."
    exit 
fi

### install some tools
yum update
yum -y install wget \
    net-tools \
    unzip
### install the docker-ce
rpm -qa | grep docker
if [ "$?" -ne 0 ]; then
	{
		yum install -y yum-utils \
       		device-mapper-persistent-data \
    		lvm2
		yum-config-manager \
    		--add-repo \
    		https://download.docker.com/linux/centos/docker-ce.repo
		yum install -y docker-ce
		systemctl enable docker #run automatically when boot
		systemctl start docker
	}
fi

### using the DaoCloud to speed up the images downloading 
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh \
    | sh -s http://2990f961.m.daocloud.io
systemctl restart docker

### install the docker-compose
curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o\
	/usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version

### download the docker-compose.yml of the platform from github 
### to setup the platform 
# the compose file is downloaded to /root director by default
#cd /root
#wget https://github.com/WenZan/GitSVN/archive/master.zip
#unzip master.zip 
#rm -f master.zip
#cd GitSVN-master
# setup the platform
#docker-compose up -d #the platform will run in backgroud

# That's all.
