#!/bin/bash
#set -x
set -m
# TODO     : 查找指定路径下的class，默认为本地maven仓库
# AUTHER   : fmeng
# DATE     : 2017/06/04

# 全局变量(不要修改)
readonly str_null="str_null"
readonly hold_space="[HOLDSPACE]"
readonly array_element_separator="\n"
readonly linux_os_name="linux"
readonly mac_os_name="macos"
readonly maven_path="/Users/fmeng/.m2/repository"
func_res="$str_null" # 用于接受函数返回值
readonly inputs=("$@") # 使用[space]分割输入参数，存储到inputs数组

# 业务变量(根据业务修改)
params=(
	"参数名	 			默认值 						解释信息" 	# 第1条信息为菜单信息(建议不要修改)
	"--help             帮助信息                     帮助信息" 	# 第2条信息为帮助信息(建议不要修改)
	"-p           		$maven_path                 被查找的路径"
	"-i                 fuzzy					    不区分大小写"
	"-s      			java						文件后缀名"
	"-n  				$str_null					要查询的文件名"
)
# echo -e "\033[30m 黑色字 \033[0m"
# echo -e "\033[31m 红色字 \033[0m"
# echo -e "\033[32m 绿色字 \033[0m"
# echo -e "\033[33m 黄色字 \033[0m"
# echo -e "\033[34m 蓝色字 \033[0m"
# echo -e "\033[35m 紫色字 \033[0m"
# echo -e "\033[36m 天蓝字 \033[0m"
# echo -e "\033[37m 白色字 \033[0m"
# 业务变量
function main(){
	local path=$str_null
	local fuzzy=$str_null
	local suffix=$str_null
	local name=$str_null

	#错误处理（公共部分）
	checkAndFillParamsSucc ;
	if [[ $? -eq 0 ]]; then
		outErrorMsg ;
		outHelpMsg	;
	fi

	# 获得业务变量
	fillBizVar ;

	# 直接查找文件
	echo "正在查找非压缩文件……"
	files=()
	if [ "$fuzzy" = "$str_null" ] ; then
		while IFS=  read -r -d $'\0'; do
	    	files+=("$REPLY")
		done < <(find ${path} -type f -name "*${name}.${suffix}" -print0)
	else
		while IFS=  read -r -d $'\0'; do
	    	files+=("$REPLY")
		done < <(find ${path} -type f -iname "*${name}.${suffix}" -print0)
	fi
	arrToStringFunRes "${files[@]}"
	if [[ ${#files[@]} -eq 0 ]]; then
		echo "非压缩文件查找为0，是否查找压缩文件？"
	else
		echo "非压缩文件查找结果如下，是否查找压缩文件？"
		echo -e "$func_res"
	fi
	func_res=$str_null
	anyKeyGo ;

	# 从压缩包中查找文件
	echo "正在查找压缩文件……"
	jar_files=()
	if [ "$suffix" = "java" ] ; then
		while IFS=  read -r -d $'\0'; do
	    	jar_files+=("$REPLY")
		done < <(find ${path} -name "*sources.jar" -print0)
	else
		while IFS=  read -r -d $'\0'; do
	    	jar_files+=("$REPLY")
		done < <(find ${path} -regex "(!.*sources.jar)&(.*.jar)" -print0)
	fi
	jar_files_length="${#jar_files[@]}"

	if [[ ${jar_files_length} -eq 0 ]]; then
		echo "查找到压缩文件0个，是否解压查找?"
		exit 1
	else
		echo "查找到压缩文件${jar_files_length}个，是否解压查找?"
	fi
	anyKeyGo ;

	# 解压缩找单个jar
	local res_array=()
	local res_array_index=0
	for i in ${!jar_files[*]}; do
		local jar_name=${jar_files[$i]}
		local temp_array=$str_null
		if [ "$fuzzy" = "$str_null" ] ; then
			temp_array=( $(jar -tvf ${jar_name} | grep "${name}.${suffix}") )
		else
			temp_array=( $(jar -tvf ${jar_name} | grep -i "${name}.${suffix}") )
		fi
		if [[ ${#temp_array[@]} -eq 0 ]]; then
			continue
		fi
		local temp_array_max_index=`expr ${#temp_array[@]} - 1`
		local pkg_path_name=${temp_array[$temp_array_max_index]}
		local res="$jar_name/$pkg_path_name"
		local one_arr=( "$res" )
		res_array=( "${res_array[@]}" "${one_arr[@]}" )
		printPercentBar $jar_files_length $i
	done
	# 数组-->字符串
	arrToStringFunRes "${res_array[@]}"
	echo -e "$func_res"
	func_res=$str_null
	exit 
}

function printPercentBar(){
	total=$1
	count=$2
	local percent=$(awk "BEGIN { pc=100*${count}/${total}; i=int(pc); print (pc-i<0.5)?i:i+1 }")
	case $percent in
		1)   echo -ne '#                     (01%)\r'
	    ;;
	    10)  echo -ne '##                    (10%)\r'
	    ;;
	    20)  echo -ne '####                  (20%)\r'
	    ;;
	    33)  echo -ne '######                (30%)\r'
	    ;;
	    40)  echo -ne '########              (40%)\r'
		;;
 		50)  echo -ne '##########            (50%)\r'
	    ;;
	    60)  echo -ne '############          (60%)\r'
	    ;;
	    70)  echo -ne '##############        (70%)\r'
	    ;;
	    80)  echo -ne '################      (80%)\r'
	    ;;
	    90)  echo -ne '##################    (90%)\r'
	    ;;
	    99)  echo -ne '####################  (99%)\r'
	    ;;
	    # *)  echo 'You do not select a number between 1 to 10'
	    # ;;
	esac
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

function fillBizVar(){
	getValueByParamNameFunRes "-p" ;
	if [[ $? -eq 1 ]]; then
		path=$func_res
		func_res=$str_null
	fi
	getValueByParamNameFunRes "-i" ;
	if [[ $? -eq 1 ]]; then
		fuzzy=$func_res
		func_res=$str_null
	fi
	getValueByParamNameFunRes "-s" ;
	if [[ $? -eq 1 ]]; then
		suffix=$func_res
		func_res=$str_null
	fi
	getValueByParamNameFunRes "-n" ;
	if [[ $? -eq 1 ]]; then
		name=$func_res
		func_res=$str_null
	fi
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
		local next=`expr $i + 1`
		local input_next_var=${inputs[$next]}	# 输入的值
		if [[ "${input_var}" =~ ^[-]{1,2}.* ]]; then # 是否为参数，参数以“-”开头
			# echo "input_var:$input_var"
			# echo "input_next_var:$input_next_var"
			local match_param_name=0 # 未匹配到参数
			for (( j = 0; j < $params_len; j++ )); do #自定义数组遍历
				local param_str=${params[$j]}
				local param_arr=(${param_str})
				local param_name=${param_arr[0]}
				local param_value=${param_arr[1]}
				if [ $param_name = $input_var ] ; then
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
		local param_arr=($param_str)
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
	if [[ "${get_param_name}" =~ ^[-]{1,2}.* ]]; then
		for i in ${!params[@]}; do
			local param_str=${params[$i]}
			local param_arr=(${param_str})
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
		local param_arr=($param_str)
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
		local param_arr=($param_str)
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