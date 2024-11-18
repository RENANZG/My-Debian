### UNDER WORK ###

$ sudo su
# cd /lib/modules/$(uname -r)/build/scripts

sudo tee x509.genkey > /dev/null << 'EOF'
[ req ]
default_bits = 4096
distinguished_name = req_distinguished_name
prompt = no
string_mask = utf8only
x509_extensions = myexts
[ req_distinguished_name ]
CN = Modules
[ myexts ]
basicConstraints=critical,CA:FALSE
keyUsage=digitalSignature
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid
EOF

$ sudo openssl req -config x509.genkey -new -nodes -utf8 -sha256 -days 36500 -batch -x509 -outform DER -out /var/lib/shim-signed/modules/Module.x509 -keyout /var/lib/shim-signed/modules/Module.pem

$ sudo /usr/src/linux-headers-6.1.0-12-amd64/scripts/sign-file sha256 /var/lib/shim-signed/modules/Module.x509 /var/lib/shim-signed/modules/module.der /lib/modules/6.1.0-12-amd64/kernel/drivers/net/wireless/realtek/rtw88/rtw_8723d.ko

$ sudo mokutil --import Module.x509

$ sudo /usr/src/linux-headers-6.1.0-12-amd64/scripts/sign-file sha256 /var/lib/shim-signed/modules/Module.pem /var/lib/shim-signed/modules/Module.x509 /lib/modules/6.1.0-12-amd64/kernel/drivers/net/wireless/realtek/rtw88/rtw_8723du.ko
