#!/bin/bash

echo "Install yum-utils"
sudo yum install -y yum-utils

echo "Add repository"
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
	
echo "Install Docker"
sudo yum install -y docker-ce docker-ce-cli containerd.io
 
echo "Start Docker Service"
sudo systemctl start docker