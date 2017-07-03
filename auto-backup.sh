#!/bin/bash
function bak(){
	local max_bak_num=3
	local orig_file_name=$1
	if [ "${orig_file_name}" = "\/*" ] || [ "${orig_file_name}" = "~\/*" ] ; then
		local orig_full_path_name=$orig_file_name
	elif [ "${orig_file_name}" == "." ]; then
		local orig_full_path_name="`pwd`"
	else
		local orig_full_path_name="`pwd`\/$orig_file_name"
	fi
	if [ ! -e $orig_file_name ]; then
		echo "\"$orig_file_name\" 不存在"
		return 0
	fi
	for (( i = 0; i < $max_bak_num; i++ )); do
		local now=`date +%Y%m%d`
		local dest_file_name="$orig_file_name.bak.$i.$now"
		local dest_full_path_name="${orig_full_path_name/$orig_file_name/$dest_file_name}"
		local dir_name=`dirname $dest_full_path_name`
		if ls -al $dir_name | grep -qv "${dest_file_name/$now/}" ; then
			echo "orig_full_path_name:$orig_full_path_name"
			echo "dest_full_path_name:dest_full_path_name"
			cp -R $orig_full_path_name $dest_full_path_name
			return 1
		fi
	done
	echo "\"$orig_file_name\" 备份文件超过$max_bak_num个"
	return 0
}

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
	if ! [ -e $orig_full_path_name ]; then
		echo "\"$orig_file_name\" 不存在"
		return 0
	fi
	find $orig_full_path_name -type d -exec chmod 755 {} \;
	find $orig_full_path_name -type f -exec chmod 644 {} \;
	find $orig_full_path_name -name "*.sh" -exec chmod u+x {} \;
}


