#!/bin/bash

# Update package list
sudo apt update && sudo apt upgrade -y

# Install UFW 
sudo apt install -y ufw
sudo ufw allow 22/tcp
sudo ufw allow 8080/tcp
sudo ufw enable
sudo ufw reload

# Install dependencies
sudo apt install -y apt-transport-https ca-certificates git curl software-properties-common

# Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Docker repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update package list again
sudo apt update

# Install Docker
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add your user to the docker group (optional, to run Docker without sudo)
sudo usermod -aG docker $USER

# Install Docker Compose (optional)
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Test Docker installation
docker --version

# Test Docker Compose installation
docker-compose --version

# Install NVM 20
sudo curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
source ~/.profile
nvm install 20
node --version

# Install Hexabot
cd /opt
git clone https://github.com/Hexastack/Hexabot.git
cd Hexabot

npm install
npx hexabot init
npx hexabot start 
npx hexabot dev --services ollama

sudo cat <<EOF > /etc/systemd/system/hexabot.service

[Unit]
Description=Hexabot Docker Container
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
Restart=always
WorkingDirectory=/opt/Hexabot
ExecStart=/usr/local/bin/docker-compose -f /opt/hexabot/docker/docker-compose.yml -f /opt/Hexabot/docker/docker-compose.ollama.yml up --build -d --remove-orphans
ExecStop=/usr/local/bin/docker-compose -f /opt/Hexabot/docker/docker-compose.yml -f /opt/Hexabot/docker/docker-compose.ollama.yml down

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable hexabot.service
sudo systemctl start hexabot.service
sudo systemctl status hexabot.service





