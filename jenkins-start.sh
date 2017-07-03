#!/bin/bash
function jenkins(){
	local server_name="jenkins"
	local start_cmd="sudo launchctl load /Library/LaunchDaemons/org.jenkins-ci.plist 2>&1 > /dev/null"
	local stop_cmd="sudo launchctl unload /Library/LaunchDaemons/org.jenkins-ci.plist 2>&1 > /dev/null"
	local user_name="`whoami`"
	for param; do true; done # 取最后一个参数
	# 用户权限判断
	if [ "root" != "${user_name}" ]; then
		echo "请切换root，或使用sudo"
		return 0
	fi
	# 参数判断
	if [ "${param}" = "start" ]; then
		eval $start_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}已启动"
		else
	  		echo "${server_name}启动失败"
		fi
	elif [ "${param}" = "stop" ]; then
		eval $stop_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}已停止"
		else
	  		echo "${server_name}停止失败"
		fi
	elif [ "${param}" = "restart" ]; then
		eval $stop_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}已停止"
		else
	  		echo "${server_name}停止失败"
		fi
		eval $start_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}已启动"
		else
	  		echo "${server_name}启动失败"
		fi
	else
		echo "参数不合法"
		return 0
	fi
	echo -e "------------------------------"
	echo -e "${server_name}_scheme:\t\thttps"
	echo -e "${server_name}_host:\t\t127.0.0.1"
	echo -e "${server_name}_port:\t\t7070"
	echo -e "${server_name}_username:\tfmeng"
	echo -e "${server_name}_password:\tfmeng**##"
	return 1
}


function mysql(){
	local server_name="mysql"
	local start_cmd="mysql.server start 2>&1 > /dev/null"
	local stop_cmd="mysql.server stop 2>&1 > /dev/null"
	local user_name="`whoami`"
	for param; do true; done # 取最后一个参数
	# 用户权限判断
	if [ "fmeng" != "${user_name}" ]; then
		echo "使用fmeng启动服务"
		exit 0
	fi
	# 参数判断
	if [ "${param}" = "start" ]; then
		eval $start_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}已启动"
		else
	  		echo "${server_name}启动失败"
		fi
	elif [ "${param}" = "stop" ]; then
		eval $stop_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}已停止"
		else
	  		echo "${server_name}停止失败"
		fi
	elif [ "${param}" = "restart" ]; then
		eval $stop_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}已停止"
		else
	  		echo "${server_name}停止失败"
		fi
		eval $start_cmd
		if [ $? -eq 0 ]; then
			echo "${server_name}已启动"
		else
	  		echo "${server_name}启动失败"
		fi
	else
		echo "参数不合法"
		return 0
	fi
	echo -e "------------------------------"
	echo -e "${server_name}_scheme:\tjdbc:mysql"
	echo -e "${server_name}_host:\t127.0.0.1"
	echo -e "${server_name}_port:\t3306"
	echo -e "${server_name}_client:\tmysql -u root -p"
	echo -e "${server_name}_username:\troot"
	echo -e "${server_name}_password:\tfmeng123"
	return 1
}

mysql restart;
