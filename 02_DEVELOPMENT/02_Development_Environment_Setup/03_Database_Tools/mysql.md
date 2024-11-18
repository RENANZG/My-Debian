## Reset 'root' password for MySQL Server (version 8.0+)
If you install [MySQL Server 8.0](https://dev.mysql.com/doc/refman/8.0/en/) or later in Ubuntu without specifying the `root` password, you can set (reset) it as follows.

Run `mysql` utility with `root` account without password:
```bash
sudo mysql
```
(Note: This only works if no `root` password is set.)

At the MySQL prompt, use the [`ALTER USER`](https://dev.mysql.com/doc/refman/8.0/en/alter-user.html) command to set the desired password.  It is important to specify the authentication plugin as [`mysql_native_password`](https://dev.mysql.com/doc/refman/8.0/en/native-pluggable-authentication.html) to allow applications such as [phpMyAdmin](https://www.phpmyadmin.net/) to connect (see also [here](https://github.com/phpmyadmin/phpmyadmin/issues/14220)).
```bash
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'new_root_password';
FLUSH PRIVILEGES;
```

Restart MySQL service:
```bash
sudo systemctl restart mysql
```

You should now be able to log in to MySQL from command prompt with the new password:
```bash
mysql -u root -pnew_root_password
```

[Reference: https://askubuntu.com/questions/766900/mysql-doesnt-ask-for-root-password-when-installing/766908#766908](https://askubuntu.com/questions/766900/mysql-doesnt-ask-for-root-password-when-installing/766908#766908)

