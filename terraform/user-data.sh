#!/bin/bash


dnf update -y

dnf install docker -y
systemctl start dokcer
systemctl enable dokcer
usermod -aG docker ec2-user


docker run -d -p 80:80 nginx
