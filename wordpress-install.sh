
 find . -type f -exce sed 's/http:\/\/182.92.118.19:8080\//\//g' {} \;

 find . -type f -name '*.php|*.html|*.js|*.css' -exec sed 's/http:\/\/182.92.118.19:8080\//\//g' {} \; &

find . -type f -regex '.*\.php\|.*\.js\|.*\.css\|.*\.html' -exec sed -i 's/http:\/\/182.92.118.19:8080\//\//g' {} \; &

http:\/\/182.92.118.19:8080\/
http://182.92.118.19:8080/
http://myroome.com/


find . -type f -exec chmod u=6 {} \;
find . -type f -name "*.sh" -exec chmod u=7 {} \;
find . -type d -exec chmod u=7 {} \;


#vsftp
yum install -y vsftpd

#mysql
yum remove -y mysql-libs
yum install -y mysql-server mysql mysql-devel
http://47.93.113.205:8080/rmf-web

#apache
yum install httpd

#php
yum install -y php php-deve php-mysql php-gd php-imap php-ldap php-odbc php-pear php-xml php-xmlrpc
