# Setup Mysql for Encrypted connections and expose the service through passthrough route

## Main steps

- Create a ca, cert and key for mysqld configuration
- edit mysqld config

# Create a CA cert

openssl genrsa -des3 -out myCA.key 2048
openssl req -x509 -new -nodes -key myCA.key -sha256 -days 1825 -out myCA.pem


openssl genrsa -out mysql.key 2048
openssl req -new -key mysql.key -out mysql.csr

v3.ext

```
cat << EOF > v3.ext
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = *.apps.ocp.example.seeweb
EOF
```

openssl x509 -req -in mysql.csr -CA myCA.pem -CAkey myCA.key -CAcreateserial -out mysql.crt -days 825 -sha256 -extfile v3.ext

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: mysql-config
data:
  tls.cnf: |-
    [mysqld]
    ssl-ca=myCA.pem
    ssl-cert=mysql.crt
    ssl-key=mysql.key
    require_secure_transport=ON
  20-default-authentication-plugin.cnf: |-
    [mysqld]
    default_authentication_plugin=caching_sha2_password
  40-paas.cnf: |-
    [mysqld]
    #
    # Settings configured by the user
    #
    
    # Sets how the table names are stored and compared. Default: 0
    lower_case_table_names = 0
    
    # Sets whether queries should be logged
    general_log      = 0
    general_log_file = /var/lib/mysql/data/mysql-query.log
    
    # The maximum permitted number of simultaneous client connections. Default: 151
    max_connections = 151
    
    # The minimum/maximum lengths of the word to be included in a FULLTEXT index. Default: 4/20
    ft_min_word_len = 4
    ft_max_word_len = 20
    
    # In case the native AIO is broken. Default: 1
    # See http://help.directadmin.com/item.php?id=529
    innodb_use_native_aio = 1
    
    [myisamchk]
    # The minimum/maximum lengths of the word to be included in a FULLTEXT index. Default: 4/20
    #
    # To ensure that myisamchk and the server use the same values for full-text
    # parameters, we placed them in both sections.
    ft_min_word_len = 4
    ft_max_word_len = 20
  50-my-tuning.cnf: |-
    [mysqld]
    key_buffer_size = 51M
    max_allowed_packet = 200M
    table_open_cache = 400
    sort_buffer_size = 256K
    read_buffer_size = 25M
    read_rnd_buffer_size = 256K
    net_buffer_length = 2K
    thread_stack = 256K
    myisam_sort_buffer_size = 2M
    
    # It is recommended that innodb_buffer_pool_size is configured to 50 to 75 percent of system memory.
    innodb_buffer_pool_size = 256M
    # Set .._log_file_size to 25 % of buffer pool size
    innodb_log_file_size = 76M
    innodb_log_buffer_size = 76M
    
    [mysqldump]
    quick
    max_allowed_packet = 16M
    
    [mysql]
    no-auto-rehash
    
    [myisamchk]
    key_buffer_size = 8M
    sort_buffer_size = 8M
    
  base.cnf: |-
    [mysqld]
    datadir = /var/lib/mysql/data
    basedir = /usr
    plugin-dir = /usr/lib64/mysql/plugin


```

/etc/my.cnf.d/

oc set volumes dc/mysql --add --name=config --configmap-name=mysql --mount-path=/etc/my.cnf.d/


 command: [ "mysqld",
                    "--character-set-server=utf8mb4",
                    "--collation-server=utf8mb4_unicode_ci",
                    "--bind-address=0.0.0.0",
                    "--require_secure_transport=ON",
                    "--ssl-ca=/etc/certs/myCA.pem",
                    "--ssl-cert=/etc/certs/mysql.pem",
                    "--ssl-key=/etc/certs/mysql.key",
                    "--default_authentication_plugin=mysql_native_password" ]


apiVersion: v1
kind: ConfigMap
metadata:
  name: mysql-config
data:
  tls.cnf: |-
    [mysqld]
    
    # Disabling symbolic-links is recommended to prevent assorted security risks
    symbolic-links = 0
    
    # http://www.percona.com/blog/2008/05/31/dns-achilles-heel-mysql-installation/
    skip_name_resolve
    
    !includedir /etc/my.cnf.d
    
    ssl-ca=/etc/certs/myCA.pem
    ssl-cert=/etc/certs/mysql.crt
    ssl-key=/etc/certs/mysql.key
    require_secure_transport=ON



    mysql -uroot --ssl-ca ./certs/myCA.pem  --ssl-cert ./certs/mysql.crt --ssl-key ./certs/mysql.key -hmysql-mysql.apps.ocp.example.seeweb -P 443