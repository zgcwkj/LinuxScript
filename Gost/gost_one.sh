#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

clear
echo

echo

#Current folder
cur_dir=`pwd`

# Make sure only root can run our script
function rootness(){
    if [[ $EUID -ne 0 ]]; then
       echo "Error:This script must be run as root!" 1>&2
       exit 1
    fi
}

# Check OS
function checkos(){
    if [ -f /etc/redhat-release ];then
        OS='CentOS'
    elif [ ! -z "`cat /etc/issue | grep bian`" ];then
        OS='Debian'
    elif [ ! -z "`cat /etc/issue | grep Ubuntu`" ];then
        OS='Ubuntu'
    else
        echo "Not support OS, Please reinstall OS and retry!"
        exit 1
    fi
}

# Get version
function getversion(){
    if [[ -s /etc/redhat-release ]];then
        grep -oE  "[0-9.]+" /etc/redhat-release
    else    
        grep -oE  "[0-9.]+" /etc/issue
    fi    
}

# CentOS version
function centosversion(){
    local code=$1
    local version="`getversion`"
    local main_ver=${version%%.*}
    if [ $main_ver == $code ];then
        return 0
    else
        return 1
    fi        
}


# Pre-installation settings
function pre_install(){
    # Not support CentOS 5
    if centosversion 5; then
        echo "Not support CentOS 5, please change OS to CentOS 6+/Debian 7+/Ubuntu 12+ and retry."
        exit 1
    fi
    # Set gost password
    echo "输入gost的密码（请只使用数字和字母组合，不要用点，中下划线等特殊字符，以免出现兼容性问题）:"
    read -p "(默认密码: supppig):" gostpwd
    [ -z "$gostpwd" ] && gostpwd="supppig"
    echo
    echo "---------------------------"
    echo "password = $gostpwd"
    echo "---------------------------"
    echo
	
    echo "选择下载源，1是国内源（TaoCode），2是国外源（github）。按照vps所处的地理位置选择，可以加快下载速度。"
    read -p "(默认国内源):" xzy
    [ -z "$xzy" ] && xzy="1"
    echo
    echo "---------------------------"
    echo "下载源 = $xzy"
    echo "---------------------------"
    echo	
		
	if [ "$xzy" == "2" ];then
	    xzy="https://zgcwkj.github.io/LinuxScript/Gost/gost_2.3_linux_amd64.tar.gz"
    else
	    xzy="https://zgcwkj.github.io/LinuxScript/Gost/gost_2.3_linux_amd64.tar.gz"
	fi
	
	# Install necessary dependencies
    if [ "$OS" == 'CentOS' ]; then
        yum install -y psmisc
    else
        apt-get -y psmisc
    fi

}

# Download files
function download_files(){
	cd $cur_dir
    if ! wget --no-check-certificate $xzy -O gost_2.3_linux_amd64.tar.gz; then
        echo "文件下载失败!"
        exit 1
    fi
	
	killall -w gost
	rm -rf /usr/local/gost 
	tar -zxf gost_2.3_linux_amd64.tar.gz -C /usr/local
	mv /usr/local/gost_2.3_linux_amd64 /usr/local/gost 
}

# firewall set
function firewall_set(){
    echo "配置防火墙..."
	gostport="6688"
    if centosversion 6; then
        /etc/init.d/iptables status > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            iptables -L -n | grep '${gostport}' | grep 'ACCEPT' > /dev/null 2>&1
            if [ $? -ne 0 ]; then
                iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport ${gostport} -j ACCEPT
                iptables -I INPUT -m state --state NEW -m udp -p udp --dport ${gostport} -j ACCEPT
                /etc/init.d/iptables save
                /etc/init.d/iptables restart
            else
                echo "port ${gostport} has been set up."
            fi
        else
            echo "WARNING: iptables looks like shutdown or not installed, please manually set it if necessary."
        fi
    elif centosversion 7; then
        systemctl status firewalld > /dev/null 2>&1
        if [ $? -eq 0 ];then
            firewall-cmd --permanent --zone=public --add-port=${gostport}/tcp
            firewall-cmd --permanent --zone=public --add-port=${gostport}/udp
            firewall-cmd --reload
        else
            echo "Firewalld looks like not running, try to start..."
            systemctl start firewalld
            if [ $? -eq 0 ];then
                firewall-cmd --permanent --zone=public --add-port=${gostport}/tcp
                firewall-cmd --permanent --zone=public --add-port=${gostport}/udp
                firewall-cmd --reload
            else
                echo "WARNING: Try to start firewalld failed. please enable port ${gostport} manually if necessary."
            fi
        fi
    fi
    echo "firewall set completed..."
}

# Config
function config_gost(){
    cd /usr/local/gost
    cat > ./gost.json<<-EOF
{
    "ServeNodes": [
        "socks://supppig:${gostpwd}@:6688"
    ]
}

EOF

chmod +x ./gost
nohup ./gost -C ./gost.json >/dev/null &


}

checkos
rootness
pre_install
download_files
config_gost
if [ "$OS" == 'CentOS' ]; then
    firewall_set
fi

cd $cur_dir
rm -f gost_2.3_linux_amd64.tar.gz
rm -f gost.sh

echo ""
echo "服务器端已经搞定~"


