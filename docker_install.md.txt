## Initial Server Setup with Ubuntu 22.04
### Step 1 - Logging in as root
```
ssh root@your_server_ip
```

### Step 2 - Creating a New User
```
sudo adduser sammy
```

### Step 3 - Granting Administrative Privileges
```
sudo usermod -aG sudo sammy
```

### Step 4 - Setting Up a Firewall
Please allow firewall access to **OpenSSH** to connect by ssh.
```
sudo ufw enable
sudo ufw allow OpenSSH
sudo ufw status
```

### Step 5 - Enabling External Access for Your Regular User
```
sudo rsync --archive --chown=sammy:sammy ~/.ssh /home/sammy
```

## How To Install and Use Docker on Ubuntu 22.04
### Step 1 - Install Docker Dependencies
```
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release
```

### Step 2 - Enable Docker Official Repository
 ```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

### Step 3 - Install Docker with Apt Command
```
sudo apt-get update
sudo apt install docker-ce docker-ce-cli containerd.io -y
```

Once the docker package is installed, add your local user to docker group so that user can run docker commands without sudo,
```
sudo usermod -aG docker $USER
newgrp docker
```
**Note:** Make sure logout and login again after adding local user to docker group

Verify the Docker version by executing following,
```
docker version
```

Verify docker daemon service status, run below systemctl command
```
sudo systemctl status docker
```

## Installation of Docker Compose on Ubuntu 22.04 / 20.04
```
sudo curl -L "https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

Check the docker-compose version by running following command,
```
docker-compose --version
```
