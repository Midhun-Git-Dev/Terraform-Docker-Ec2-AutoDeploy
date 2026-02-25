#!/bin/bash

# Update system
dnf update -y

# Install Docker
dnf install docker -y

# Start Docker service
systemctl start docker
systemctl enable docker

# Allow ec2-user to run Docker
usermod -aG docker ec2-user

# Give Docker few seconds to fully start
sleep 10

# Pull latest image from DockerHub
docker pull midhun07/terraform-docker-ec2-autodeploy:latest

# Run container
docker run -d -p 80:80 --restart unless-stopped --name webapp midhun07/terraform-docker-ec2-autodeploy:latest
