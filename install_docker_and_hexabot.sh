#!/bin/bash

# Update package list
sudo apt update && sudo apt upgrade -y

# Install UFW 
sudo apt install -y ufw
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
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
nvm install 20.18.1
node --version

npm install -g yarn

# Add your user to the docker group (optional, to run Docker without sudo)
sudo usermod -aG docker $USER

# Install Hexabot
cd /opt
git clone https://github.com/Hexastack/Hexabot.git
cd Hexabot
npm install -g hexabot-cli

npm install
npx hexabot init

npx hexabot start --services ollama

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

sudo apt install -y nginx certbot python3-certbot-nginx 
sudo systemctl enable nginx.service
sudo systemctl start nginx.service

sudo cat <<EOF > /etc/nginx/sites-available/hexabot.conf

server {
    listen 80;
    server_name chat.example.com;                             # You will need to update this to use your own domain 
    server_tokens off;
    client_max_body_size 100M;

    location / {
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header X-Url-Scheme /$scheme;
        proxy_set_header X-Forwarded-For /$proxy_add_x_forwarded_for;
        proxy_set_header Host /$http_host;
        proxy_redirect off;
        proxy_pass http://localhost:8080;                     # Make sure to use the port configured in .env file
    }

    location /api/ {
        rewrite ^/api/?(.*)$ /$1 break;
        proxy_pass http://localhost:4000;                     # Make sure to use the port configured in .env file
        proxy_http_version 1.1;
        proxy_set_header X-Forwarded-Host /$host;
        proxy_set_header X-Forwarded-Server /$host;
        proxy_set_header X-Real-IP /$remote_addr;
        proxy_set_header X-Forwarded-For /$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto /$scheme;
        proxy_set_header Host /$http_host;
        proxy_set_header Upgrade /$http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header X-NginX-Proxy false;
        proxy_pass_request_headers on;
    }

    location ~* \.io {
        rewrite ^/api/?(.*)$ /$1 break;
        proxy_set_header X-Real-IP /$remote_addr;
        proxy_set_header X-Forwarded-For /$proxy_add_x_forwarded_for;
        proxy_set_header Host /$http_host;
        proxy_set_header X-NginX-Proxy false;

        proxy_pass http://localhost:4000;                               #  Make sure to use the port configured in .env file
        proxy_redirect off;

        proxy_http_version 1.1;
        proxy_set_header Upgrade /$http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/hexabot.conf /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx

sudo certbot --nginx -d chat.example.com



