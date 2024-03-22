#!/bin/bash

# install dependencies
sudo apt-get install curl acl

# stop any running containers
if curl -s --unix-socket /var/run/docker.sock http/_ping 2>&1 >/dev/null
then
  docker stop $(docker ps -a -q)
else
  echo "Docker is not running"
fi

# uninstall previous installations, try all installation options, some will fail
sudo service docker stop
sudo service docker.socket stop
sudo systemctl stop docker.socket
sudo snap stop docker
sudo snap remove docker

for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
sudo apt-get purge -y docker-buildx-plugin
sudo apt-get purge -y docker-ce
sudo apt-get purge -y docker-ce-cli
sudo apt-get purge -y docker-ce-rootless-extras
sudo apt-get purge -y docker-compose-plugin
sudo apt-get purge -y containerd.io
sudo apt-get remove -y docker 
sudo apt-get remove -y docker.io 
sudo apt-get remove -y containerd 
sudo apt-get remove -y runc
sudo apt-get autoremove -y --purge docker-buildx-plugin
sudo apt-get autoremove -y --purge docker-ce
sudo apt-get autoremove -y --purge docker-ce-cli
sudo apt-get autoremove -y --purge docker-ce-rootless-extras
sudo apt-get autoremove -y --purge docker-compose-plugin
sudo apt-get autoremove -y --purge containerd.io
sudo apt -y autoclean
sudo rm -rf /var/lib/docker /etc/docker
sudo rm /etc/apparmor.d/docker
sudo groupdel docker
sudo rm -rf /var/run/docker.sock
sudo rm -rf /usr/local/bin/docker-compose
sudo rm -rf /etc/apt/keyrings/docker.gpg
sudo rm -rf /etc/docker
sudo rm -rf ~/.docker
sudo rm -rf /etc/systemd/system/multi-user.target.wants/docker.service
sudo rm -rf /etc/systemd/system/sockets.target.wants/docker.socket
sudo rm -rf /lib/systemd/system/docker.service
sudo rm -rf /lib/systemd/system/docker.socket
sudo rm -rf /run/docker
sudo rm -rf /etc/apt/sources.list.d/docker.list
sudo rm -rf /etc/apt/sources.list.d/docker.list.save
sudo ip link delete docker0

# prepare for installation 
sudo apt-get update
sudo apt -y upgrade
sudo apt -y autoremove
sudo apt-get -y clean

# install
curl -fsSL https://get.docker.com -o get-docker.sh && chmod +x get-docker.sh
sudo sh get-docker.sh --channel stable

# set up the group if it does not exist
if [ $(getent group docker) ]; then
    echo "group docker exists."
else
    sudo groupadd docker
fi

# add the user to the group if it isn't already in there
if id -nG "$USER" | grep -qw docker; then
    echo [$USER] user belongs to docker group
else
    sudo usermod -aG docker $USER
fi

sudo setfacl --modify user:"$USER":rw /var/run/docker.sock

# check that it all worked
docker run hello-world

# clean up
rm get-docker.sh
