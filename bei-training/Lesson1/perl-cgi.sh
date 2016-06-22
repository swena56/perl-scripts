mkdir /var/cgi-bin

#create a perl script in /var/cgi-bin
cp echo.pl /var/cgi-bin/echo.pl

chmod +x /var/cgi-bin/echo.pl

echo "" > /etc/apache2/sites-enabled/000-default.conf
cat << EOT >> /etc/apache2/sites-enabled/000-default.conf
<VirtualHost *:80>
        #ServerName www.example.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
	
	ScriptAlias /cgi-bin/ /var/cgi-bin/
         <Directory "/var/cgi-bin">
                 AllowOverride None
                 Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
                 Require all granted
         </Directory>

        #LogLevel info ssl:warn

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
</VirtualHost>
EOT
ls -l /etc/apache2/mods-enabled/ | grep cgi
ls -l /etc/apache2/mods-available/ | grep cgi

ln -s /etc/apache2/mods-available/cgid.load /etc/apache2/mods-enabled/
ln -s /etc/apache2/mods-available/cgid.conf /etc/apache2/mods-enabled/

ls -l /etc/apache2/mods-enabled/ | grep cgi
ls -l /etc/apache2/mods-available/ | grep cgi

/etc/init.d/apache2 reload

sleep 5

apt-get install httpie
http http://localhost/cgi-bin/echo.pl
