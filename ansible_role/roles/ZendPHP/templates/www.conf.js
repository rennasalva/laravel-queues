[default]
user = zendphp
group = zendphp
listen = 0.0.0.0:9000
pm = static
pm.max_children = 4
pm.max_requests = 1024
pm.status_path = /status
access.log = /proc/self/fd/2
access.format = "%R - %u %t \"%m %r%Q%q\" %s %f %{mili}d %{kilo}M %C%%"
slowlog = /proc/self/fd/2
catch_workers_output = yes
decorate_workers_output = no
clear_env = no

;php_admin_value[sendmail_path] = /usr/sbin/sendmail -t -i -f www@my.domain.com
;php_flag[display_errors] = off
;php_admin_value[error_log] = /proc/self/fd/2
;php_admin_flag[log_errors] = on
;php_admin_value[memory_limit] = 256M
;php_value[session.save_handler] = redis
;php_value[session.save_path] = "tcp://redis:6379?database=0&prefix=app::"
;php_value[soap.wsdl_cache_dir]  = /var/opt/php/8.2-zend/wsdlcache
;php_value[opcache.file_cache]  = /var/opt/php/8.2-zend/opcache

; zendhq configuration
;php_value[zendhq.use_php_error_log] = 1
;php_value[zendhq.daemon_uri] = tcp://zendhq:10090
