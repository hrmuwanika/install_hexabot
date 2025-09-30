#!/bin/bash

# Update package list
sudo apt update && sudo apt upgrade -y

# Install UFW 
sudo apt install -y ufw
sudo ufw allow 22/tcp
sudo ufw allow 8080/tcp
sudo ufw allow 3000/tcp
sudo ufw allow 4000/tcp
sudo ufw enable
sudo ufw reload

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
nvm install 20
node --version

npm install -g yarn

# Add your user to the docker group (optional, to run Docker without sudo)
sudo usermod -aG docker $USER
su - ${USER}

# Install Hexabot
cd /opt
git clone https://github.com/Hexastack/Hexabot.git
cd Hexabot
npm install -g hexabot-cli

npm install
hexabot init

hexabot start --services ollama

#sudo cat <<EOF > /etc/systemd/system/hexabot.service

#[Unit]
#Description=Hexabot Docker Container
#Requires=docker.service
#After=docker.service

#[Service]
#Type=simple
#Restart=always
#WorkingDirectory=/opt/my-chatbot
#ExecStart=/usr/local/bin/docker-compose -f /opt/my-chatbot/docker/docker-compose.yml -f /opt/my-chatbot/docker/docker-compose.ollama.yml up --build -d --remove-orphans
#ExecStop=/usr/local/bin/docker-compose -f /opt/my-chatbot/docker/docker-compose.yml -f /opt/my-chatbot/docker/docker-compose.ollama.yml down

#[Install]
#WantedBy=multi-user.target
#EOF

#sudo systemctl daemon-reload
#sudo systemctl enable hexabot.service
#sudo systemctl start hexabot.service
#sudo systemctl status hexabot.service





