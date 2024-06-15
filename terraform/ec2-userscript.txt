#!/bin/bash

sudo yum update -y

sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user

sudo curl -L "https://github.com/docker/compose/releases/download/v2.27.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

# Create a symbolic link to /usr/bin
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

sudo dnf install libxcrypt-compat -y

# docker --version
# docker-compose --version

cd /home/ec2-user/
mkdir project
cd ./project
curl -L "https://raw.githubusercontent.com/enricogoerlitz/aws-bp-2-hosting-backend-on-ec2-asg-alb/main/docker/prod/docker-compose.yml" -o docker-compose.yml

sudo docker-compose up -d
