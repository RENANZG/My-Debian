# Nginx-php-configuration
define php in server config

    location ~ [^/]\.php(/|$) {
    fastcgi_split_path_info ^(.+?\.php)(/.*)$;
    if (!-f $document_root$fastcgi_script_name) {
      return 404;
    }

        charset utf-8;
        root /var/www/example.com/htdocs;
        index index.php;
        try_files $uri /index.php;
        #try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        #fastcgi_pass unix:/var/run/php-fpm.sock;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_read_timeout 3;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
        fastcgi_intercept_errors on;
        #fastcgi_param HTTPS on;
      }
    }
