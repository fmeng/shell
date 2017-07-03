# 增加5G交换分区
dd if=/dev/zero of=/var/swap bs=1024 count=`echo "1024000*5" | bc`
chmod 600 /var/swap
/sbin/mkswap /var/swap
/sbin/swapon /var/swap
echo"# 交换分区开机启动" >> /etc/fstab
echo "/var/swap		swap		swap		defaults		0 0" >> /etc/fstab
# 查看swap
cat /proc/swaps
