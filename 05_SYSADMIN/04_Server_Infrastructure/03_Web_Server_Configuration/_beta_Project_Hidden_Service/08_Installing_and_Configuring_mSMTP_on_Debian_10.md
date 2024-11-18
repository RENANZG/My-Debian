# Installing-and-Configuring-mSMTP-on-Debian-10


Installing and Configuring mSMTP

    For Arch
    $ sudo pacman -S msmtp ca-certificates

    For Debian/Ubuntu
    $ sudo apt-get install msmtp ca-certificates

    For Fedora/Rhel/CentOS
    $ sudo yum install msmtp ca-certificates

    nano ~/.msmtprc
    account default
    host smtp.gmail.com
    from email@youremailhost.com
    auth on
    port 587
    user email@gmail.com
    password MySecret
    syslog LOG_MAIL
    logfile /var/log/msmtp/msmtp.log
    tls on
    tls_starttls on
    tls_trust_file /etc/ssl/certs/ca-certificates.crt
    chmod 600 .msmtprc

Then do this

    echo -e "Subject: Test Mail\r\n\r\nThis is a test mail" | msmtp --debug --from=default -t your_account@gmail.com

To send email via php file you can use this an example

    <?php
    ini_set( 'display_errors', 1 );
    error_reporting( E_ALL );
    $to = "your_account@gmail.com;
    $subject = "PHP Mail Test script";
    $message = "This is a test to check the PHP Mail functionality.";
    mail($to,$subject,$message);
    echo "Test email sent\n.";
    ?>
Open php.ini file and find sendmail_path and add this line

    [mail function]
    sendmail_path = "/usr/bin/msmtp -t"
  
Save php.ini and restart php7.4-fpm 


