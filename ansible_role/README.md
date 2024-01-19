# zendphp-ansible-tools
ZendPHP Ansible Tools

# Roles

## ZendPHP role

ZendPHP Ansible role to provision ZendPHP using zendphpctl utility.

Sample playbook for usage:

```
---
  - hosts: virtualmachines
    roles:
     - role: ZendPHP
       become: yes
       vars:
         webserver: nginx
         php_version: 8.1
         php_extensions: 
           - xml
           - mysql
         php_directives:
           error_log: /var/log/my_app_errors.log
           error_reporting: E_ALL
    tasks:
     - name: Some custom task to run after ZendPHP provisioning
       debug:
         msg: "Here is some custom task that runs after ZendPHP provisioning"
```

