#!/bin/bash

# Update package list
sudo apt update && sudo apt upgrade -y

# Install python dependencies
sudo apt install -y python3-dev python3-pip python3-venv

# Add Docker's official GPG key:
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl git software-properties-common
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the system:
sudo apt update

# Install Docker Community Edition:
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Install Docker Compose (optional)
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Test Docker installation
docker --version

# Test Docker Compose installation
docker-compose --version

# Install NVM 18
sudo curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source ~/.profile
nvm install 20.18.1
node --version

npm install -g yarn

# Add your user to the docker group (optional, to run Docker without sudo)
sudo usermod -aG docker $USER
newgrp docker 

# Install Hexabot
cd /home/root/
npm install -g hexabot-cli

hexabot create my-chatbot
cd my-chatbot

npm install
npm i --save hexabot-plugin-ollama
npm i --save hexabot-helper-ollama

hexabot init

hexabot start --services ollama

sudo cat << EOF > /etc/systemd/system/hexabot.service

[Unit]
Description=Hexabot Docker Container
Requires=docker.service
After=docker.service

[Service]
Type=simple
#Restart=always
WorkingDirectory=/home/root/my-chatbot/docker
ExecStart=/usr/local/bin/docker-compose -f /home/root/my-chatbot/docker/docker-compose.yml -f /home/root/my-chatbot/docker/docker-compose.ollama.yml up -d 
ExecStop=/usr/local/bin/docker-compose -f /home/root/my-chatbot/docker/docker-compose.yml -f /home/root/my-chatbot/docker/docker-compose.ollama.yml down

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable hexabot.service
sudo systemctl start hexabot.service
sudo systemctl status hexabot.service


echo "UI Admin Panel is accessible via http://localhost:8080, the default credentials are :"
echo "Username: admin@admin.admin"
echo "Password: adminadmin"

