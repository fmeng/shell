# 备份文件
export -f bak
function bak(){
	local orig_file_name=$1
	local orig_full_path_name=$orig_file_name
	if [[ "${orig_file_name}" != "/*" ]] && [[ "${orig_file_name}" != "~*" ]]; then
		local orig_full_path_name="`pwd`/$orig_file_name"
	fi
	if [ ! -e $orig_file_name ]; then
		echo "\"$orig_file_name\" 不存在"
		return 0
	fi
	for (( i = 0; i < 20; i++ )); do
		local now=`date +%Y%m%d`
		local dest_full_path_name="${orig_full_path_name/$orig_file_name/$orig_file_name.bak.$i.$now}"
		if ! [ -e $dest_full_path_name ]; then
			cp -R $orig_full_path_name $dest_full_path_name
			return 1
		fi
	done
	echo "\"$orig_file_name\" 今天备份文件超过20个"
	return 0
}

# 修改权限
export -f chp
function chp(){
	local orig_file_name=$1
	local orig_full_path_name=$orig_file_name
	if [ "${orig_file_name}" != "/*" ] && [ "${orig_file_name}" != "~*" ] ; then
		if [ "$orig_file_name" = "." ]; then
			local orig_full_path_name="`pwd`"
		else
			local orig_full_path_name="`pwd`/$orig_file_name"
		fi		
	fi
	if [ ! -e $orig_file_name ]; then
		echo "\"$orig_file_name\" 不存在"
		return 0
	fi
	find $orig_full_path_name -type d -exec chmod 755 {} \;
	find $orig_full_path_name -type f -exec chmod 644 {} \;
	find $orig_full_path_name -name "*.sh" -exec chmod u+x {} \;
}
export -f jenkins
function jenkins(){
	local server_name="jenkins"
	local start_cmd="sudo launchctl load /Library/LaunchDaemons/org.jenkins-ci.plist 2>&1 > /dev/null"
	local stop_cmd="sudo launchctl unload /Library/LaunchDaemons/org.jenkins-ci.plist 2>&1 > /dev/null"
	local user_name="`whoami`"
	for param; do true; done # 取最后一个参数
	# 用户权限判断
	if [ "root" != "${user_name}" ]; then
		echo "\033[33m 请使用root用户 \033[0m"
		return 0
	fi
	# 参数判断
	if [ "${param}" = "start" ]; then
		eval $start_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}\033[32m 已启动 \033[0m"
		else
	  		echo "${server_name}\033[31m 启动失败 \033[0m"
	  		return 0
		fi
	elif [ "${param}" = "stop" ]; then
		eval $stop_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}\033[32m 已停止 \033[0m"
		else
	  		echo "${server_name}\033[31m 停止失败 \033[0m"
	  		return 0
		fi
	elif [ "${param}" = "restart" ]; then
		eval $stop_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}\033[32m 已停止 \033[0m"
		else
	  		echo "${server_name}\033[31m 停止失败 \033[0m"
	  		return 0
		fi
		eval $start_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}\033[32m 已启动 \033[0m"
		else
	  		echo "${server_name}\033[31m 启动失败 \033[0m"
	  		return 0
		fi
	else
		echo "\033[31m 参数不合法 \033[0m"
		return 0
	fi
	echo -e "------------------------------"
	echo -e "${server_name}_scheme:\t\t\033[32m https \033[0m"
	echo -e "${server_name}_host:\t\t\033[32m 127.0.0.1 \033[0m"
	echo -e "${server_name}_port:\t\t\033[32m 7070 \033[0m"
	echo -e "${server_name}_username:\t\033[32m fmeng \033[0m"
	echo -e "${server_name}_password:\t\033[32m fmeng**## \033[0m"
	return 1
}

export -f mysql
function mysql(){
	local server_name="mysql"
	local start_cmd="mysql.server start 2>&1 > /dev/null"
	local stop_cmd="mysql.server stop 2>&1 > /dev/null"
	local user_name="`whoami`"
	for param; do true; done # 取最后一个参数
	# 用户权限判断
	if [ "fmeng" != "${user_name}" ]; then
		echo "\033[33m 请使用fmeng用户 \033[0m"
		return 0
	fi
	# 参数判断
	if [ "${param}" = "start" ]; then
		eval $start_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}\033[32m 已启动 \033[0m"
		else
	  		echo "${server_name}\033[31m 启动失败 \033[0m"
	  		return 0
		fi
	elif [ "${param}" = "stop" ]; then
		eval $stop_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}\033[32m 已停止 \033[0m"
		else
	  		echo "${server_name}\033[31m 停止失败 \033[0m"
	  		return 0
		fi
	elif [ "${param}" = "restart" ]; then
		eval $stop_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}\033[32m 已停止 \033[0m"
		else
	  		echo "${server_name}\033[31m 停止失败 \033[0m"
	  		return 0
		fi
		eval $start_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}\033[32m 已启动 \033[0m"
		else
	  		echo "${server_name}\033[31m 启动失败 \033[0m"
	  		return 0
		fi
	else
		echo "\033[31m 参数不合法 \033[0m"
		return 0
	fi
	echo -e "------------------------------"
	echo -e "${server_name}_scheme:\t\033[32m jdbc:mysql \033[0m"
	echo -e "${server_name}_host:\t\033[32m 127.0.0.1 \033[0m"
	echo -e "${server_name}_port:\t\033[32m 3306 \033[0m"
	echo -e "${server_name}_client:\t\033[32m mysql -u root -p \033[0m"
	echo -e "${server_name}_username:\t\033[32m root \033[0m"
	echo -e "${server_name}_password:\t\033[32m fmeng123 \033[0m"
	return 1
}
export -f redis
function redis(){
	local server_name="redis"
	local start_cmd="brew services start redis"
	local stop_cmd="brew services stop redis"
	local user_name="`whoami`"
	for param; do true; done # 取最后一个参数
	# 用户权限判断
	if [ "fmeng" != "${user_name}" ]; then
		echo "\033[33m 请使用fmeng用户 \033[0m"
		return 0
	fi
	# 参数判断
	if [ "${param}" = "start" ]; then
		eval $start_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}\033[32m 已启动 \033[0m"
		else
	  		echo "${server_name}\033[31m 启动失败 \033[0m"
	  		return 0
		fi
	elif [ "${param}" = "stop" ]; then
		eval $stop_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}\033[32m 已停止 \033[0m"
		else
	  		echo "${server_name}\033[31m 停止失败 \033[0m"
	  		return 0
		fi
	elif [ "${param}" = "restart" ]; then
		eval $stop_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}\033[32m 已停止 \033[0m"
		else
	  		echo "${server_name}\033[31m 停止失败 \033[0m"
	  		return 0
		fi
		eval $start_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}\033[32m 已启动 \033[0m"
		else
	  		echo "${server_name}\033[31m 启动失败 \033[0m"
	  		return 0
		fi
	else
		echo "\033[31m 参数不合法 \033[0m"
		return 0
	fi
	echo -e "------------------------------"
	echo -e "${server_name}_scheme:\t\033[32m tcp \033[0m"
	echo -e "${server_name}_host:\t\033[32m 127.0.0.1 \033[0m"
	echo -e "${server_name}_port:\t\033[32m 6379 \033[0m"
	echo -e "${server_name}_client:\t\033[32m redis-cli \033[0m"
	echo -e "${server_name}_username:\t\033[32m auth(进入客户端敲该命令) \033[0m"
	echo -e "${server_name}_password:\t\033[32m fmeng123 \033[0m"
	return 1
}


export -f memcached
function memcached(){
	local server_name="memcached"
	local start_cmd="brew services start memcached"
	local stop_cmd="brew services stop memcached"
	local user_name="`whoami`"
	for param; do true; done # 取最后一个参数
	# 用户权限判断
	if [ "fmeng" != "${user_name}" ]; then
		echo "\033[33m 请使用fmeng用户 \033[0m"
		return 0
	fi
	# 参数判断
	if [ "${param}" = "start" ]; then
		eval $start_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}\033[32m 已启动 \033[0m"
		else
	  		echo "${server_name}\033[31m 启动失败 \033[0m"
	  		return 0
		fi
	elif [ "${param}" = "stop" ]; then
		eval $stop_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}\033[32m 已停止 \033[0m"
		else
	  		echo "${server_name}\033[31m 停止失败 \033[0m"
	  		return 0
		fi
	elif [ "${param}" = "restart" ]; then
		eval $stop_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}\033[32m 已停止 \033[0m"
		else
	  		echo "${server_name}\033[31m 停止失败 \033[0m"
	  		return 0
		fi
		eval $start_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}\033[32m 已启动 \033[0m"
		else
	  		echo "${server_name}\033[31m 启动失败 \033[0m"
	  		return 0
		fi
	else
		echo "\033[31m 参数不合法 \033[0m"
		return 0
	fi
	echo -e "------------------------------"
	echo -e "${server_name}_scheme:\t\033[32m telnet \033[0m"
	echo -e "${server_name}_host:\t\033[32m 127.0.0.1 \033[0m"
	echo -e "${server_name}_port:\t\033[32m 11211 \033[0m"
	echo -e "${server_name}_client:\t\033[32m telnet \033[0m"
	echo -e "${server_name}_username:\t\033[32m null \033[0m"
	echo -e "${server_name}_password:\t\033[32m null \033[0m"
	return 1
}


export -f zoo
function zoo(){
	local server_name="zookeeper"
	local start_cmd="/usr/local/de/zookeeper-3.4.9/bin/zkServer.sh start"
	local stop_cmd="/usr/local/de/zookeeper-3.4.9/bin/zkServer.sh stop"
	local user_name="`whoami`"
	for param; do true; done # 取最后一个参数
	# 用户权限判断
	if [ "fmeng" != "${user_name}" ]; then
		echo "\033[33m 请使用fmeng用户 \033[0m"
		return 0
	fi
	# 参数判断
	if [ "${param}" = "start" ]; then
		eval $start_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}\033[32m 已启动 \033[0m"
		else
	  		echo "${server_name}\033[31m 启动失败 \033[0m"
	  		return 0
		fi
	elif [ "${param}" = "stop" ]; then
		eval $stop_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}\033[32m 已停止 \033[0m"
		else
	  		echo "${server_name}\033[31m 停止失败 \033[0m"
	  		return 0
		fi
	elif [ "${param}" = "restart" ]; then
		eval $stop_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}\033[32m 已停止 \033[0m"
		else
	  		echo "${server_name}\033[31m 停止失败 \033[0m"
	  		return 0
		fi
		eval $start_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}\033[32m 已启动 \033[0m"
		else
	  		echo "${server_name}\033[31m 启动失败 \033[0m"
	  		return 0
		fi
	else
		echo "\033[31m 参数不合法 \033[0m"
		return 0
	fi
	echo -e "------------------------------"
	echo -e "${server_name}_scheme:\t\033[32m tcp \033[0m"
	echo -e "${server_name}_host:\t\t\033[32m 127.0.0.1 \033[0m"
	echo -e "${server_name}_port:\t\t\033[32m 2181 \033[0m"
	echo -e "${server_name}_client:\t\033[32m telnet \033[0m"
	echo -e "${server_name}_username:\t\033[32m null \033[0m"
	echo -e "${server_name}_password:\t\033[32m null \033[0m"
	return 1
}


export -f dubbo
function dubbo(){
	local server_name="dubbo"
	local start_cmd="/usr/local/de/dubbo-admin-tomcat/bin/catalina.sh start 2>&1 > /dev/null "
	local stop_cmd="/usr/local/de/dubbo-admin-tomcat/bin/catalina.sh stop 2>&1 > /dev/null "
	local user_name="`whoami`"
	for param; do true; done # 取最后一个参数
	# 用户权限判断
	if [ "fmeng" != "${user_name}" ]; then
		echo "\033[33m 请使用fmeng用户 \033[0m"
		return 0
	fi
	# 参数判断
	if [ "${param}" = "start" ]; then
		eval $start_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}\033[32m 已启动 \033[0m"
		else
	  		echo "${server_name}\033[31m 启动失败 \033[0m"
	  		return 0
		fi
	elif [ "${param}" = "stop" ]; then
		eval $stop_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}\033[32m 已停止 \033[0m"
		else
	  		echo "${server_name}\033[31m 停止失败 \033[0m"
	  		return 0
		fi
	elif [ "${param}" = "restart" ]; then
		eval $stop_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}\033[32m 已停止 \033[0m"
		else
	  		echo "${server_name}\033[31m 停止失败 \033[0m"
	  		return 0
		fi
		eval $start_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}\033[32m 已启动 \033[0m"
		else
	  		echo "${server_name}\033[31m 启动失败 \033[0m"
	  		return 0
		fi
	else
		echo "\033[31m 参数不合法 \033[0m"
		return 0
	fi
	echo -e "------------------------------"
	echo -e "${server_name}_scheme:\t\033[32m http \033[0m"
	echo -e "${server_name}_host:\t\033[32m 127.0.0.1 \033[0m"
	echo -e "${server_name}_port:\t\033[32m 7071 \033[0m"
	echo -e "${server_name}_client:\t\033[32m null \033[0m"
	echo -e "${server_name}_username:\t\033[32m root \033[0m"
	echo -e "${server_name}_password:\t\033[32m root \033[0m"
	return 1
}

# echo -e "\033[30m 黑色字 \033[0m"
# echo -e "\033[31m 红色字 \033[0m"
# echo -e "\033[32m 绿色字 \033[0m"
# echo -e "\033[33m 黄色字 \033[0m"
# echo -e "\033[34m 蓝色字 \033[0m"
# echo -e "\033[35m 紫色字 \033[0m"
# echo -e "\033[36m 天蓝字 \033[0m"
# echo -e "\033[37m 白色字 \033[0m"

