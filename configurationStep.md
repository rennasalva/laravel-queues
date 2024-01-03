# Jenkins Server

1) Jenkins setup installation
* url https://www.jenkins.io/doc/book/installing/linux/

2) Generate ssh key (privare/public) and e copy on remote server
    - ssh-keygen -t ed25519 -a 256 -f KeyFileName
    - ssh-copy-id -i ~/.ssh/KeyFileName remote_user@remote_server_ip
    - or nano ~/.ssh/authorized_keys  manually add key to remote_server_ip


3) Ansible setup installation
* Install ansible https://www.snel.com/support/how-to-install-ansible-on-centos-7/
* config file /etc/ansible/ansible.cfg
* define hosts (inventory) 
* test host with ping module (ansible -m ping all)

4) Install docker client
* Jenking run in a container
    * volumes:
      - "$PWD/jenkins-ansible/jenkins_home:/var/jenkins_home"
      - "/var/run/docker.sock:/var/run/docker.sock"
    * change sock permission 
        -  chmod 666 /var/run/docker.sock

5) Jenkins configuration
    * plugins
        - ansible
        - docker (CloudBees Docker Build and Publish)
        - pipeline stage step (scm)
        - Docker Pipeline
        - ssh
    * git setup
        - setup credential to remote repo    
6) Jenkinsfile load directly from git repository


# Builder Server ZendPHP
* install ZendPhp 
* install ZendPhp extension
* configure xdebug
* create e user or copy public key to root user


# Node Server ZendPHP - Nginx
* install ZendPhp 
* install ZendPhp extension
* configure xdebug
* install nginx
* create e user or copy public key to root user


# Playbook ansible and inventory ansible

# Jenkins variable for build
https://wiki.jenkins.io/display/JENKINS/Building+a+software+project

# Jenkins parameter for running pipeline
https://www.jenkins.io/doc/book/pipeline/syntax/#parameters


