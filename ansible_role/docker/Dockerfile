FROM almalinux:9

RUN dnf -y install epel-release  openssh-server openssh-clients sudo zip 

RUN dnf --enablerepo=epel -y install supervisor

COPY  ./.docker/supervisord/supervisord.conf /etc/supervisord.conf

# #USER root
# #RUN useradd ansible_user && \
# #    echo "remote_user:1234" | chpasswd && \
# #    mkdir /home/ansible_user/.ssh -p && \
# #    chmod 700 /home/ansible_user/.ssh && \
# #    mkdir -p  /var/run/sshd

USER root
RUN groupadd --system --gid 10003 remote_user  && useradd -g remote_user  remote_user && \
    echo "remote_user:1234" | chpasswd && \
    mkdir /home/remote_user/.ssh -p && \
    chmod 700 /home/remote_user/.ssh && \
    mkdir -p  /var/run/sshd  && \
    echo 'remote_user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY ./.docker/ssh/remote-key.pub /home/remote_user/.ssh/authorized_keys

RUN chown remote_user:remote_user   -R /home/remote_user && \
    chmod 400 /home/remote_user/.ssh/authorized_keys

RUN ssh-keygen -A && rm -rf /run/nologin


USER root
ENTRYPOINT ["/usr/bin/supervisord","--configuration=/etc/supervisord.conf"]