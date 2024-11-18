#!/bin/sh

########################################################################
# VISIT: https://www.torproject.org
# NOTE: This is not the best way to install Tor-Browser, this is only 
#       for specific configurations or tests. Security Considerations: 
#       the script downloads Tor Browser using wget and curl without 
#       verifying the download using GPG signatures or checksums. The
#       script assumes it will be run with superuser privileges, which 
#       is necessary for writing to /opt and /usr/local/bin, but it's
#       generally better to use a package manager when possible.
# SCRIPT CREDITS: https://portable-linux-apps.github.io
# Make it executable:
# $ sudo chmod +x file.sh
# Then run
# $ sudo bash file.sh
########################################################################

APP=tor-browser

# CREATE THE DIRECTORY
mkdir -p /opt/"$APP"
cd /opt/"$APP"

# ADD THE REMOVER
echo '#!/bin/sh' >> /opt/"$APP"/remove
echo "rm -R -f /usr/local/share/applications/$APP-AM.desktop /opt/$APP /usr/local/bin/$APP" >> /opt/"$APP"/remove
chmod a+x /opt/"$APP"/remove

# DOWNLOAD THE ARCHIVE
mkdir -p tmp
cd ./tmp

wget https://www.torproject.org/$(curl -Ls https://www.torproject.org/download/ | grep -i linux | grep 'tar.xz"' | sed 's/ //g' | head -1 | grep -o -P '(?<="href=").*(?=">)')
[ -e ./*tar.* ] && tar fx ./*tar.* && rm -f ./*tar.*
cd ..
mv ./tmp/*/Browser/* ./
rm -R ./tmp

# LINK / SCRIPT IN $PATH

cat >> /usr/local/bin/"$APP" << 'EOF'
#!/bin/sh
sh -c '/opt/tor-browser/start-tor-browser --detach || ([ ! -x /opt/tor-browser/start-tor-browser ] && /opt/tor-browser/start-tor-browser --detach)' dummy %k
EOF
chmod a+x /usr/local/bin/"$APP"

# LAUNCHER
echo "
[Desktop Entry]
Type=Application
Name=Tor Browser
GenericName=Web Browser
Comment=Tor Browser is +1 for privacy and −1 for mass surveillance
Categories=Network;WebBrowser;Security;
Exec=sh -c '/opt/tor-browser/start-tor-browser --detach || ([ ! -x /opt/tor-browser/start-tor-browser ] && /opt/tor-browser/start-tor-browser --detach)' dummy %k
X-TorBrowser-ExecShell=/opt/tor-browser/start-tor-browser --detach
Icon=/opt/tor-browser/browser/chrome/icons/default/default128.png
StartupWMClass=Tor Browser" > /usr/local/share/applications/"$APP"-AM.desktop




