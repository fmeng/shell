#!/bin/bash
#set -x
# TODO     : 接受命令行输入的参数值,根据业务做相应的操作
# AUTHER   : fmeng
# DATE     : 2017/06/04

# 全局变量(不要修改)
readonly str_null="str_null"
readonly hold_space="[HOLDSPACE]"
readonly array_element_separator="\n"
readonly linux_os_name="linux"
readonly mac_os_name="macos"
func_res="$str_null" # 用于接受函数返回值
readonly inputs=("$@") # 使用[space]分割输入参数，存储到inputs数组

# 业务变量(根据业务修改)
params=(
	"参数名	 			默认值 						解释信息" 	# 第1条信息为菜单信息(建议不要修改)
	"--help             帮助信息                     帮助信息" 	# 第2条信息为帮助信息(建议不要修改)
	"-h                	$str_null                   远端主机"
	"--port             22							端口"
	"-u 				root						用户"
	"-p 				$str_null					密码"
	"-v 				1.1.1						版本"
)
# (  "${confs[@]}" )
confs=(
	"[mariadb]"
	"name = MariaDB"
	"baseurl = http://yum.mariadb.org/10.1/centos7-amd64$hold_space"
	"gpgkey = https://yum.mariadb.org/RPM-GPG-KEY-MariaDB"
	"gpgcheck = 1"
)
# echo -e "\033[30m 黑色字 \033[0m"
# echo -e "\033[31m 红色字 \033[0m"
# echo -e "\033[32m 绿色字 \033[0m"
# echo -e "\033[33m 黄色字 \033[0m"
# echo -e "\033[34m 蓝色字 \033[0m"
# echo -e "\033[35m 紫色字 \033[0m"
# echo -e "\033[36m 天蓝字 \033[0m"
# echo -e "\033[37m 白色字 \033[0m"
#######################################
# 在main函数中使用						 ##
#######################################
# # 数组-->字符串
# arrToStringFunRes "${confs[@]}"
# conf_str=$func_res
# echo -e "$conf_str"
# func_res=$str_null
# # 字符-->数组
# stringToArrFunRes $conf_str
# arr=func_res
# # do something
# func_res=$str_null
# 程序入口
function main(){
	#错误处理（公共部分）
	checkAndFillParamsSucc ;
	if [[ $? -eq 0 ]]; then
		outErrorMsg ;
		outHelpMsg	;
	fi
	# 业务处理(获得函数返回值)
	# getValueByParamNameFunRes "-v" ;
	# if [[ $? -eq 1 ]]; then
	# 	version=$func_res
	# 	echo "业务信息$version"
	# fi
}

# 敲任意键继续函数
function anyKeyGo(){
	SAVEDSTTY=`stty -g`
	stty -echo
	stty cbreak
	dd if=/dev/tty bs=1 count=1 2> /dev/null
	stty -raw
	stty echo
	stty $SAVEDSTTY
}

# 执行成功返回1,失败返回0
function checkAndFillParamsSucc(){
	local inputs_len=${#inputs[*]} # 输入参数的长度
	local params_len=${#params[*]} # 自定义的数组长度
	# 帮助信息
	getHelpParamNameFunRes ;
	if [ $inputs_len -eq 0 ]; then
		outHelpMsg ;
	elif [ "${inputs[0]}" = "${func_res}" ]; then
		outHelpMsg ;
	fi
	# 填充数据
	for (( i = 0; i < $inputs_len; i++ )); do # 输入参数loop
		# 最大索引值，防止下标越界
		local max_index=( $inputs_len - 1 )
		if [ $i -ge  $max_index ] ; then 
			break ; # 遍历完所有的参数址
		fi
		local input_var=${inputs[$i]} # 输入的参数
		local input_next_var=${inputs[$i+1]}	# 输入的值
		if [ `echo "$input_var" | grep -Ec "^[-]{1,2}.*"` -gt 0 ] && [ `echo "$input_next_var" | grep -Ec "^[-]{1,2}.*"` -le 0 ] && [ -n "$input_next_var" ]; then # 是否为参数，参数以“-”开头
			local match_param_name=0 # 未匹配到参数
			for (( j = 0; j < $params_len; j++ )); do #自定义数组遍历
				local param_str=${params[$j]}
				read -ra param_arr <<< "$param_str"
				local param_name="${param_arr[0]}"
				local param_value="${param_arr[1]}"
				if [[ $param_name = $input_var ]] ; then
					params[$j]="${param_str/$param_value/$input_next_var}"
					match_param_name=1 # 匹配到参数
					break ;
				fi
			done
			if [[ $match_param_name -eq 0 ]]; then
				echo "\"${input_var}\" 参数不合法"
				outHelpMsg ;
				exit
			fi
		fi
	done

	# 校验参数是否已经全部填充
	for i in ${!params[*]}; do
		local param_str=${params[$i]}
		read -ra param_arr <<< "$param_str"
		local param_value=${param_arr[1]}
		if [ "$str_null" = "$param_value" ]; then
			outErrorMsg ;
			outHelpMsg ;
			return 0
		fi
	done
	
	return 1
}

# 得到参数值返回1，未得到返回0
# 返回值从func_res取
function getValueByParamNameFunRes(){
	local get_param_name=$1
	if [[ `echo "$get_param_name" | grep -Ec "^[-]{1,2}.*"` -gt 0 ]]; then
		for i in ${!params[*]}; do
			local param_str=${params[$i]}
			read -ra param_arr <<< "$param_str"
			local param_name=${param_arr[0]}
			local param_value=${param_arr[1]}
			if [[ "$get_param_name" = "$param_name" ]]; then
				func_res=$param_value
				return 1
			fi
		done
	fi
	return 0
}

# 得到参数值返回1，未得到返回0
# 返回值从func_res取
function getHelpParamNameFunRes(){
	local param_arr=(${params[1]})
	func_res="${param_arr[0]}"
	return 1
}

function outErrorMsg(){
	for i in ${!params[*]}; do
		param_str=${params[$i]}
		read -ra param_arr <<< "$param_str"
		local param_name=${param_arr[0]}
		local param_value=${param_arr[1]}
		local param_dsp=${param_arr[2]}
		if [ "$str_null" = "$param_value" ]; then
			echo  "参数: \"${param_name}\" 不能为空"
		fi
	done
	return 1
}

function outHelpMsg(){
	echo "Help:"
	for i in ${!params[*]}; do
		param_str=${params[$i]}
		read -ra param_arr <<< "$param_str"
		local param_name=${param_arr[0]}
		local param_default_value=${param_arr[1]}
		local param_dsp=${param_arr[2]}
		if [ "$str_null" = "$param_default_value" ] || [ $i -eq 0 ] || [ $i -eq 1 ]; then
			echo "${param_name}	${param_dsp}"
		else
			echo "${param_name}	${param_dsp}(默认:${param_default_value})"
		fi
	done
	exit # 每次显示帮助信息，就退出程序
}

function existCommand(){
    local command=$1
    if which $command 2>&1 | grep -Eq ".*[Nn]ot*[[:space:]]([Ii]n)|([Ff]ound).*" ; then
       return 0
    fi
    return 1 
 }

function getOSNameFunRes(){
    if uname -a | grep -qi "linux"; then
    	func_res="$linux_os_name"
        return 1
    elif uname -a | grep -qi "Darwin"; then
        func_res="$mac_os_name"
        return 1
    fi  
    return 0
}

# var1, var2, string(数组以字符串的形式传入) 
function fillArrToStringFunRes(){
	local input_strs=("$@")
	local inputs_len=$#

	local replace_strs=()
	local target_str=""

	local res_str=""

	for (( i = 0; i < $input_len; i++ )); do
		local max_index=`expr inputs_len - 1`
		if [[ $i -lt $max_index ]]; then
			replace_strs[$i]="${input_strs[$i]}"
		else
			target_str="${input_strs[$i]}"
		fi
	done

	local target_num=$(grep -o "$hold_space" <<< "$target_str" | wc -l)
	if [[ $target_name -ne ${#replace_strs[*]} ]]; then
		echo "输入参数和被替换的值不相等"
		exit
	fi

	for rpVar in ${replace_strs[*]}; do
		res_str=`echo $target_str | sed 's/$hold_space/$rpVar/p'`
	done
	
	func_res=$res_str
	return 1
}

function yumInstallPkg(){
	local package_name="$1"
    echo "脚本执行需要${package_name}的支持，安装${packageName} [y/n]?"
    read
    if [ $1="y" ]; then
        yum install -y "${packageName}"
        return 1
    else
        exit
    fi
}

function brewInstallPkg(){
	local package_name="$1"
    echo "脚本执行需要${package_name}的支持，安装${packageName} [y/n]?"
    read
    if [ $1="y" ]; then
        brew install -y "${packageName}"
        return 1
    else
        exit
    fi
}

# 使用方式 ( "${arr[@]}" )
function arrToStringFunRes(){
	local input_arr=("$@")
	local res_str=""
	for (( i = 0; i < ${#input_arr[*]}; i++ )); do
		local var=${input_arr[i]}
		res_str="${res_str}${array_element_separator}${var}"
	done
	func_res="${res_str}"
	return 1
}

function stringToArrFunRes(){
	
	local fun_res_index=0
	for var in ${array[@]}; do
		if [[ -n $var ]]; then
			func_res[$fun_res_index]=$var
			fun_res_index=`expr $fun_res_index + 1`
		fi
	done
	return 1
}

main ;