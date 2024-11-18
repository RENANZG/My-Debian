# Preparation-for-Nginx
What first you need to do before configure your server.conf
      
      useradd --no-create-home www-data  
      mkdir -p /var/www/example.com/htdocs
      chcon -R -t httpd_sys_rw_content_t /var/www/example.com/htdocs
      sudo chown -R www-data:www-data /var/www/example.com/htdocs
      chmod -R 0755   /var/www/example.com/htdocs
      #setsebool -P httpd_setrlimit on

# next 
    grep addr access.log --color=auto
    find /var/www/example.com/htdocs -type f -print0 | xargs -0 chmod -v 644
    grep -RPn "(passthru|shell_exec|system|base64_decode|fopen|fclose|eval)" /var/www/example.com/htdocs 
   
