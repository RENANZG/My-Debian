# NGINX-execute-embedded-PHP-in-HTML-file


    find / -name www.conf 
or
  
    nano /etc/php/7.4/fpm/pool.d/www.conf

adding the line:

      security.limit_extensions = .php .html .htm

then open nginx config file
    
    nano /etc/nginx/sites-enabled/server.conf

    location ~ [^/]\.php|.html(/|$) {
    fastcgi_split_path_info ^(.+?\.php)(/.*)$;
    fastcgi_intercept_errors on;

# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000

    if (!-f $document_root$fastcgi_script_name) { return 404; }

# Secure NGINX from Clickjacking attack
    add_header X-Frame-Options "deny";
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";

    systemctl restart nginx php7.4-fpm
