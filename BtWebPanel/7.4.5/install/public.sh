#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
pyenv_bin=/www/server/panel/pyenv/bin
rep_path=${pyenv_bin}:$PATH
if [ -d "$pyenv_bin" ];then
	PATH=$rep_path
fi
export PATH
export LANG=en_US.UTF-8
export LANGUAGE=en_US:en

get_node_url(){
	NODE_URL='https://zgcwkj.github.io/LinuxScript/BtWebPanel/7.4.5';
}

GetCpuStat(){
	time1=$(cat /proc/stat |grep 'cpu ')
	sleep 1
	time2=$(cat /proc/stat |grep 'cpu ')
	cpuTime1=$(echo ${time1}|awk '{print $2+$3+$4+$5+$6+$7+$8}')
	cpuTime2=$(echo ${time2}|awk '{print $2+$3+$4+$5+$6+$7+$8}')
	runTime=$((${cpuTime2}-${cpuTime1}))
	idelTime1=$(echo ${time1}|awk '{print $5}')
	idelTime2=$(echo ${time2}|awk '{print $5}')
	idelTime=$((${idelTime2}-${idelTime1}))
	useTime=$(((${runTime}-${idelTime})*3))
	[ ${useTime} -gt ${runTime} ] && cpuBusy="true"
	if [ "${cpuBusy}" == "true" ]; then
		cpuCore=$((${cpuInfo}/2))
	else
		cpuCore=$((${cpuInfo}-1))
	fi
}
GetPackManager(){
	if [ -f "/usr/bin/yum" ] && [ -f "/etc/yum.conf" ]; then
		PM="yum"
	elif [ -f "/usr/bin/apt-get" ] && [ -f "/usr/bin/dpkg" ]; then
		PM="apt-get"		
	fi
}

bt_check(){
	p_path=/www/server/panel/class/panelPlugin.py
	if [ -f $p_path ];then
		is_ext=$(cat $p_path|grep btwaf)
		if [ "$is_ext" != "" ];then
			send_check
		fi
	fi
	
	p_path=/www/server/panel/BTPanel/templates/default/index.html
	if [ -f $p_path ];then
		is_ext=$(cat $p_path|grep fbi)
		if [ "$is_ext" != "" ];then
			send_check
		fi
	fi
}

send_check(){
	chattr -i /etc/init.d/bt
	chmod +x /etc/init.d/bt
	p_path2=/www/server/panel/class/common.py
	p_version=$(cat $p_path2|grep "version = "|awk '{print $3}'|tr -cd [0-9.])
	curl -sS --connect-timeout 3 -m 60 http://www.bt.cn/api/panel/notpro?version=$p_version
	NODE_URL=""
	exit 0;
}
init_check(){
	CRACK_URL=(oss.yuewux.com);
	for url in ${CRACK_URL[@]};
	do
		CRACK_INIT=$(cat /etc/init.d/bt |grep ${url})
		if [ "${CRACK_INIT}" ];then
			rm -rf /www/server/panel/class/*
			chattr +i /www/server/panel/class
			chattr -R +i /www/server/panel
			chattr +i /www 
		fi
	done
}
GetSysInfo(){
	if [ "${PM}" = "yum" ]; then
		SYS_VERSION=$(cat /etc/redhat-release)
	elif [ "${PM}" = "apt-get" ]; then
		SYS_VERSION=$(cat /etc/issue)
	fi
	SYS_INFO=$(uname -msr)
	SYS_BIT=$(getconf LONG_BIT)
	MEM_TOTAL=$(free -m|grep Mem|awk '{print $2}')
	CPU_INFO=$(getconf _NPROCESSORS_ONLN)
	GCC_VER=$(gcc -v 2>&1|grep "gcc version"|awk '{print $3}')
	CMAKE_VER=$(cmake --version|grep version|awk '{print $3}')

	echo -e ${SYS_VERSION}
	echo -e Bit:${SYS_BIT} Mem:${MEM_TOTAL}M Core:${CPU_INFO} gcc:${GCC_VER} cmake:${CMAKE_VER}
	echo -e ${SYS_INFO}
}
cpuInfo=$(getconf _NPROCESSORS_ONLN)
if [ "${cpuInfo}" -ge "4" ];then
	GetCpuStat
else
	cpuCore="1"
fi
GetPackManager

if [ -d "/www/server/phpmyadmin/pma" ];then
	rm -rf /www/server/phpmyadmin/pma
	EN_CHECK=$(cat /www/server/panel/config/config.json |grep English)
	if [ "${EN_CHECK}" ];then
		curl https://zgcwkj.github.io/LinuxScript/BtWebPanel/7.4.5/install/update6_en.sh|bash
	else
		curl https://zgcwkj.github.io/LinuxScript/BtWebPanel/7.4.5/install/update6.sh|bash
	fi
	echo > /www/server/panel/data/restart.pl
fi

if [ ! $NODE_URL ];then
	EN_CHECK=$(cat /www/server/panel/config/config.json |grep English)
	if [ -z "${EN_CHECK}" ];then
		echo '正在选择下载节点...';
	else
		echo "selecting download node...";
	fi
	get_node_url
	bt_check
fi

