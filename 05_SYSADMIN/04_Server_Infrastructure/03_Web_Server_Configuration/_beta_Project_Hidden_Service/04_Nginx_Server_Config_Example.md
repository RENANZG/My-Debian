# Nginx-Server-Config-Example
Just a simple example
  

	server {
  	server_name example.com www.example.com;
	#listen 80;
	#listen 443 default_server ssl;

	listen 80;
	listen 443 ssl;

	# force https-redirects
	if ($scheme = http) {
	    return 301 https://$server_name$request_uri;
	}

        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers 'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH';
        ssl_prefer_server_ciphers on;
        ssl_dhparam /etc/nginx/ssl/dhparam.pem;
        ssl_certificate /etc/nginx/ssl/nginx.crt;
        ssl_certificate_key /etc/nginx/ssl/nginx.key;

        client_max_body_size 51M;
        client_header_buffer_size 2048k;
        #large_client_header_buffers 4 204

        # Secure NGINX from Clickjacking attack
        add_header X-Frame-Options "deny";
        add_header X-Content-Type-Options nosniff;
        add_header X-XSS-Protection "1; mode=block";

        if ($request_method !~ ^(GET|HEAD|POST)$ ) {  return 405; }

        #root /var/www/html;
        root /var/www/example.com/htdocs;

        location / {
        if ($request_uri ~ ^/(.*)\.html$) {  return 302 /$1;  }
        root /var/www/example.com/htdocs;
        index  index.html index.htm index.php;
        #try_files $uri $uri/ /index.html;
	      try_files $uri $uri/ /index.php?$query_string;

        access_log   off;
        expires      2h;
        }

       # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        location ~ \.php$ {
        # Secure NGINX from Clickjacking attack
        add_header X-Frame-Options "deny";
        add_header X-Content-Type-Options nosniff;
        add_header X-XSS-Protection "1; mode=block";

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
        #fastcgi_param HTTPS on;
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }

	location ~ /\.ht {
		deny all;
	}

	}

