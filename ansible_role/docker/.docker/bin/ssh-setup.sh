#!/bin/bash

set -e

groupadd --system --gid 10003 remote_user
useradd -rm -d /home/remote_user -s /bin/bash -g root -G sudo -u 10003 remote_user 
echo "remote_user:1234" | chpasswd 
mkdir /home/remote_user/.ssh -p 
chmod 700 /home/remote_user/.ssh 
usermod -aG sudo remote_user
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


cp -f  /entrypoint.d/jenkins/ssh/remote-key.pub /home/remote_user/.ssh/authorized_keys

chown remote_user:remote_user   -R /home/remote_user 
chmod 400 /home/remote_user/.ssh/authorized_keys

ssh-keygen -A && rm -rf /run/nologin