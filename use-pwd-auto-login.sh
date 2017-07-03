#!/bin/bash

# TODO     : 使用except无需输入密码自动登录ssh
# Author   : fmeng
# Date     : 2016/01/14

#服务器配置项
CONFIGS=(
    "host               port        user   password            描述"
    "47.94.138.22       22          root   password        fmeng阿里云"
    "192.168.31.249     22          root   fmengpwdpwd         公司阿里云"
)
# 程序入口
function main(){
    checkAndInstallExpect ;
    loginMenu ;
    chooseServer ; 
}

function checkCommand(){
    command=$1
    if which "$command" | grep -e ".*[Nn]ot*[[:space:]]([Ii]n)|([Ff]ound).*"; then
        echo "0"
    else
        echo "1"
    fi
 }
#expect是否安装
function checkAndInstallExpect(){
    # linux OS
    if [ `uname -a | grep -ic linux` -gt 0 ] && [  `expect -v 2>&1 /dev/null | grep -ic version` -eq 0 ]; then
        echo "脚本需要Expect的支持，安装Expect [y/n]?"
        read
        if [ $1="y" ]; then
            yum install -y "expect"
        fi
    fi
    # mac OS
    if [ `uname -a | grep -ic Darwin` -gt 0 ] && [  `expect -v 2>&1 /dev/null | grep -ic version` -eq 0 ]; then
        echo "脚本需要Expect的支持，安装Expect [y/n]?"
        read
        if [ $1="y" ]; then
            brew install -y "homebrew/dupes/expect"
        fi
    fi
} 
#登录菜单
function loginMenu(){
    
    echo "-------请输入登录的服务器序号---------"
    local conf_len=${#CONFIGS[*]}
    for ((i=0;i<${conf_len};i++));  
    do  
        CONFIG=(${CONFIGS[$i]}) #将一维sites字符串赋值到数组
        if [[ i -eq 0 ]]; then
            local serverNum="编号"
        else
            local serverNum=$i
        fi
        echo  "${serverNum}\t${CONFIG[4]}"
    done  
    echo "请输入您选择登录的服务器序号: "
}

#选择登录的服务器
function chooseServer(){
    
    read serverNum
    local conf_len=${#CONFIGS[*]}
    if [ $serverNum -gt $conf_len ] && [ $serverNum -lt 1 ];
    then
        echo "输入的序号不正确，请重新输入:"
        ChooseServer ;
        return ;
    fi
    autoLogin $serverNum;
}  

#自动登录
function autoLogin(){
    num=$1 
    CONFIG=(${CONFIGS[$num]})  
    echo "正在登录【${CONFIG[4]}】"
    expect -c "
        spawn ssh -p ${CONFIG[1]} ${CONFIG[2]}@${CONFIG[0]}
        expect {
            \"*assword\" {
                set timeout 6000; 
                send \"${CONFIG[3]}\n\";
                exp_continue ; sleep 2;
            }
            \"yes/no\" {
                send \"yes\n\";
                exp_continue;
            }
            \"Last*\" {
                send_user \"\n成功登录【${CONFIG[4]}】\n\";
            }
        }
   interact"
   if [ which tmux ]; then
       #statements
   fi
   echo "您已退出【${CONFIG[4]}】"
    
}

main ;
