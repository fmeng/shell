1. rarlinux
   		tar -zxvf rarlinux-4.0.1.tar.gz
   		cp -f rar/rar_static /usr/local/bin/rar
   		# rar解压
   		rar -x fileName.rar
2. zlib(不要指定目录，使用默认安装目录)
		./configure
		make && make install
3. pcre(不要指定目录，使用默认安装目录)
		./configure --enable-utf8
		make && make install
4. openssl-fips(不要指定目录，使用默认安装目录)
		./config
		make && make install
5. nginx
		./configure
		make && make install

nginx command:
	1. nginx 配置文件 path/to/nginx/conf/nginx.conf
	2. 查看线程是否启动 `ps -ef | grep nginx`  或者。`ps -aux | grep nginx`
	3. nginx 启动 `path/to/nginx/sbin/nginx -c path/to/nginx/conf/nginx.conf`
