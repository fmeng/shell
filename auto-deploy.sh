#!/bin/bash
# set -m

# JVM参数 
# 参数配置说明 http://www.ibm.com/support/knowledgecenter/zh/SSEP7J_10.2.0/com.ibm.swg.ba.cognos.ig_rtm.10.2.0.doc/t_jvm_cnfg.html
# 8G内存配置如下
export JAVA_OPTS="-server -Xms6144M -Xmx6144M -XX:NewSize=1536M -XX:MaxNewSize=1536M -Dfile.encoding=UTF-8 -Djava.awt.headless=true -Djava.NET.preferIPv4Stack=true -Djava.Net.preferIPv4Addresses=true"

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

# 杀死java虚拟机
pkill -9 java

# svn 更新
cd /usr/local/homicode
sh svn_update.sh
echo "-------------------------------------------"
echo "svn  更新完毕"
echo "-------------------------------------------"
echo "按任意键扫描本机端口"
char=`any_key_go`
nmap 127.0.0.1
echo "按任意键继续……"
char=`any_key_go`

# rmd 部署
#cd /usr/local/tomcat8/roome/tomcat-rmd/bin
#sh shutdown.sh
rm -rf /usr/local/tomcat8/roome/tomcat-rmd/webapps/rmd-web*
rm -rf /usr/local/tomcat8/roome/tomcat-rmd/work/Catalina
cd /usr/local/homicode/rmd
mvn clean install -e -Dmaven.test.skip=true
cp /usr/local/homicode/rmd/rmd-web/target/rmd-web-1.0.0.war /usr/local/tomcat8/roome/tomcat-rmd/webapps/rmd-web.war
sh /usr/local/tomcat8/roome/tomcat-rmd/bin/startup.sh
echo "-------------------------------------------"
echo "rmd  部署完毕"
echo "-------------------------------------------"
echo "按任意键扫描本机端口"
char=`any_key_go`
nmap 127.0.0.1
echo "按任意键继续……"
char=`any_key_go`

# rmc 部署
#cd /usr/local/tomcat8/roome/tomcat-rmc/bin
#sh shutdown.sh
# 杀死netty进程
#ps -aux |grep 'tomcat'|grep -v 'grep' |egrep "rmc"|awk '{system("echo "$2)}'
rm -rf /usr/local/tomcat8/roome/tomcat-rmc/webapps/rmc-web*
rm -rf /usr/local/tomcat8/roome/tomcat-rmc/work/Catalina
cd /usr/local/homicode/rmc
mvn clean install -e -Dmaven.test.skip=true
cp /usr/local/homicode/rmc/rmc-web/target/rmc-web-1.0.0.war /usr/local/tomcat8/roome/tomcat-rmc/webapps/rmc-web.war
sh /usr/local/tomcat8/roome/tomcat-rmc/bin/startup.sh
echo "-------------------------------------------"
echo "rmc  部署完毕"
echo "-------------------------------------------"
echo "按任意键扫描本机端口"
char=`any_key_go`
nmap 127.0.0.1
echo "按任意键继续……"
char=`any_key_go`

# rmadmin 部署
#cd /usr/local/tomcat8/roome/tomcat-rmadmin/bin
#sh shutdown.sh
rm -rf /usr/local/tomcat8/roome/tomcat-rmadmin/webapps/rmadmin-web*
rm -rf /usr/local/tomcat8/roome/tomcat-rmadmin/work/Catalina
cd /usr/local/homicode/rmadmin
mvn clean install -e -Dmaven.test.skip=true
cp /usr/local/homicode/rmadmin/rmadmin-web/target/rmadmin-web-1.0.0.war /usr/local/tomcat8/roome/tomcat-rmadmin/webapps/rmadmin-web.war
sh /usr/local/tomcat8/roome/tomcat-rmadmin/bin/startup.sh
echo "-------------------------------------------"
echo "rmadmin  部署完毕"
echo "-------------------------------------------"
echo "按任意键扫描本机端口"
char=`any_key_go`
nmap 127.0.0.1
echo "按任意键继续……"
char=`any_key_go`

# rmf 部署
#cd /usr/local/tomcat8/roome/tomcat-rmf/bin
#sh shutdown.sh
rm -rf /usr/local/tomcat8/roome/tomcat-rmf/webapps/rmf-web*
rm -rf /usr/local/tomcat8/roome/tomcat-rmf/work/Catalina
cd /usr/local/homicode/rmf
mvn clean install -e -Dmaven.test.skip=true
cp /usr/local/homicode/rmf/rmf-web/target/rmf-web-1.0.0.war /usr/local/tomcat8/roome/tomcat-rmf/webapps/rmf-web.war
sh /usr/local/tomcat8/roome/tomcat-rmf/bin/startup.sh
echo "-------------------------------------------"
echo "rmf  部署完毕"
echo "-------------------------------------------"
echo "按任意键扫描本机端口"
char=`any_key_go`
nmap 127.0.0.1
echo "部署完成,请测试部署结果"


