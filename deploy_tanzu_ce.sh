#!/bin/bash

##--------------------------------------------------------------------------------------------------------------------------------------------------##

## Docker installation.

echo "Step 01 : Intalling Docker"

sudo apt-get remove docker docker-engine docker.io containerd runc

sudo apt-get update
sudo apt-get install \
ca-certificates \
curl \
gnupg \
lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg -y

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io

sudo groupadd docker || true
sudo usermod -aG docker $USER

##--------------------------------------------------------------------------------------------------------------------------------------------------##

## Installling kubectl

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

##--------------------------------------------------------------------------------------------------------------------------------------------------##

## Installing Tanzu CLI

wget https://github.com/vmware-tanzu/community-edition/releases/download/v0.9.1/tce-linux-amd64-v0.9.1.tar.gz

tar zxvf tce-linux-amd64-v0.9.1.tar.gz
cd tce-linux-amd64-v0.9.1/
./install.sh
cd ..

##--------------------------------------------------------------------------------------------------------------------------------------------------##

## Generating Key pair
ssh-keygen -t rsa -N '' -f ~/.ssh/tanzu_key -C "Tanzu CE Key Pair"  <<< y
printf "\n\nKey pair is created and saved at  ~/.ssh/tanzu_key \n\n"

##--------------------------------------------------------------------------------------------------------------------------------------------------##

## Testing Docker , kubectl and tanzu cli

read -p "Press any key to test Docker ..."


printf "\n\nTesting Docker installed properly\n\n"
docker run hello-world

read -p "Press any key to test kubectl ..."

printf "\n\nTesting kubectl installed properly\n\n"
kubectl version --client
read -p "Press any key to test tanzu cli ..."

printf "\n\nTesting tanzu installed properly\n\n"
tanzu
read -p "Press any key to end the installation and start wizard.  ..."

##--------------------------------------------------------------------------------------------------------------------------------------------------##

## Start the installation Wizard

ipaddress=$(hostname -I | awk '{ print $1 }')
tanzu management-cluster create --ui --bind $ipaddress:5555 --browser none

##--------------------------------------------------------------------------------------------------------------------------------------------------##

## End . 
