# Configure-SSL-for-Nginx
SSL (Secure Socket Layer protocol) was created by Netscape to secure transactions between web servers and browsers.

SSL is an essential part of creating a secure Apache site. SSL certificates allow you encrypt all the traffic sent to and from your Apache web site to prevent others from viewing all of the traffic. It uses public key cryptography to establish a secure connection. This means that anything encrypted with a public key (the SSL certificate) can only be decrypted with the private key.

In order to set up the self-signed certificate, you will need to install mod_ssl Apache module in your system.

You can install mod_ssl by running the following command:
sudo yum install mod_ssl

Create a directory for SSL certificates with following command:
sudo mkdir /etc/nginx/ssl/

For SSL we'll need a certificate with a strong signature algorithm, SHA256. For testing purposes or non-production environments you can use a self-signed certificate while ignoring the SSL warnings. Create one self-signed cerificate with following command,

sudo openssl req -x509 -nodes -sha256 -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt

Answer the all questions shown below:

    Generating a 2048 bit RSA private key
    .........+++
    .............................+++
    writing new private key to '/etc/nginx/ssl/nginx.key'
    -----
    You are about to be asked to enter information that will be incorporated
    into your certificate request.
    What you are about to enter is what is called a Distinguished Name or a DN.
    There are quite a few fields but you can leave some blank
    For some fields there will be a default value,
    If you enter '.', the field will be left blank.
    -----
    Country Name (2 letter code) [XX]:IN
    State or Province Name (full name) []:GUJARAT
    Locality Name (eg, city) [Default City]:AHMEDABAD
    Organization Name (eg, company) [Default Company Ltd]:Hostpresto
    Organizational Unit Name (eg, section) []:IT
    Common Name (eg, your name or your server's hostname) []:Hitesh
    Email Address []:hitjethva@gmail.com

After that it will create a 2048 bit RSA encrypted key in the file /etc/nginx/ssl/nginx.key and a SHA256 certificate in the file /etc/nginx/ssl/nginx.crt.

Now generate stronger, 4096 bit long DH parameters. It may take long time depending upon your system. Run following command to generate the DH parameters,
sudo openssl dhparam -out /etc/nginx/ssl/dhparam.pem 4096

Once you get all the SSL related files ready, configure the default server block for SSL. Open its configuration file for editing,
sudo nano /etc/nginx/sites-enabled/default

Edit the server configuration part adding the SSL part after the server_name directive as shown below
        

    server {
            server_name example.com www.example.com;
            listen 80;
            listen 443 default_server ssl;
            # force https-redirects
            if ($scheme = http) {
            return 301 https://$server_name$request_uri;
            }
           
            ### SSL Config
            listen 443 ssl;
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



...

Let's quickly go through each of the configuration parameters configured above :-

    listen — enable the SSL listener on port 443, i.e. the HTTPS port.
    ssl_protocols — enable only these three, considered currently secure protocols - TLSv1 TLSv1.1 TLSv1.2.
    ssl_ciphers — enable only these secure SSL ciphers: EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH
    ssl_prefer_server_ciphers — make sure that the client respects the server's ciphers preferences.
    ssl_dhparam — use the custom, strong DH parameters which we have generated earlier.
    ssl_certificate — use our self-signed SSL certificate. Make sure to change it if you are using another certificate.
    ssl_certificate_key — use our SSL private key, which we have previously generated.

Save and close the file, reload 'nginx' to bring above settings in effect.
sudo systemctl reload nginx



