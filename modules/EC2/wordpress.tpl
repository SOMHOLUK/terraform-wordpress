#cloud-config

package_update: true

packages:
  - httpd
  - php
  - php-cli
  - php-curl
  - php-mbstring
  - php-gd
  - php-mysqlnd
  - php-gettext
  - php-json
  - php-xml
  - php-intl
  - php-zip
  - php-bcmath
  - php-ctype
  - php-fileinfo
  - php-openssl
  - php-pdo
  - php-tokenizer
  - wget
  - tar

runcmd:
  # Start and enable Apache
  - systemctl enable --now httpd

  # Set up web directory permissions
  - usermod -a -G apache ec2-user
  - chown -R ec2-user:apache /var/www
  - chmod 2775 /var/www
  - find /var/www -type d -exec chmod 2775 {} \;
  - find /var/www -type f -exec chmod 0664 {} \;

  # Download and extract WordPress
  - cd /tmp
  - wget https://wordpress.org/latest.tar.gz
  - tar -xzf latest.tar.gz
  - cp -r wordpress/* /var/www/html/
  - chown -R apache:apache /var/www/html

  # Create wp-config.php 
  - cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
  - chown apache:apache /var/www/html/wp-config.php

  # RDS database configuration
  - sed -i "s/database_name_here/${db_name}/g" /var/www/html/wp-config.php
  - sed -i "s/username_here/${db_username}/g" /var/www/html/wp-config.php
  - sed -i "s/password_here/${db_password}/g" /var/www/html/wp-config.php
  - sed -i "s/localhost/${db_endpoint}/g" /var/www/html/wp-config.php

    # === ADD THESE LINES TO AUTOMATE INSTALLATION ===
  # Install WP-CLI
  - curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  - chmod +x wp-cli.phar
  - mv wp-cli.phar /usr/local/bin/wp

  # Run WordPress installation (creates DB tables)
  - cd /var/www/html
  - wp core install --url="https://filsanhdmohamed.co.uk" --title="Filsan's WordPress Site" --admin_user="admin" --admin_password="${db_password}" --admin_email="admin@filsanhdmohamed.co.uk" --skip-email --allow-root

  # Optional: Force HTTPS and correct domain in wp-config.php
  - sed -i "/<?php/a define('WP_HOME','https://filsanhdmohamed.co.uk');\ndefine('WP_SITEURL','https://filsanhdmohamed.co.uk');" /var/www/html/wp-config.php

  # Let WordPress know the original request was HTTPS (sent by the load balancer),
# so it doesn’t think the site is insecure or serve mixed content.
  - sed -i "/<?php/a if (isset(\$_SERVER['HTTP_X_FORWARDED_PROTO']) && \$_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {\n    \$_SERVER['HTTPS'] = 'on';\n}" /var/www/html/wp-config.php

  # Restart Apache to apply changes
  - systemctl restart httpd
