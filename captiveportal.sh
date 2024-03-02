#!/bin/bash
# Remove old docker files 
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
# install repo
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo -y
# install docker
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# start and enable startup docker
sudo systemctl start docker
sudo systemctl enable docker

#firewall-cmd --zone=public --add-port=8080/tcp --permanent
#firewall-cmd --reload

# create systemd file to autostart
cat << 'EOF'>> /etc/systemd/system/captiveportal.service

[Unit]
Description=Docker Compose Application Service
Requires=docker.service
After=docker.service
StartLimitIntervalSec=60

[Service]
WorkingDirectory=/captive_portal
ExecStart=docker compose up -d
ExecStop=docker compose down
TimeoutStartSec=0
Restart=on-failure
StartLimitBurst=3

[Install]
WantedBy=multi-user.target
EOF
# enable startup 
systemctl enable captiveportal.service

# create a folder to save the file
mkdir /captive_portal

# create docker compose file 
cat << 'EOF'>> /captive_portal/docker-compose.yaml
version: "3"
services:

  captive:
    image: isandano/captivephp:t1
    ports:
      - "8080:443"
    command: /bin/bash -c "service apache2 start && service mysql start && tail -f /var/log/mysql/error.log /var/log/apache2/error.log "
EOF

# start docker compose 
docker compose -f /captive_portal/docker-compose.yaml up -d