#!/bin/bash

red='\e[91m'
green='\e[92m'
none='\e[0m'

echo "----------------------------------------------------------------"
echo "                  V2ray 一键搭建脚本 v1.0                       "
echo "       Author：花语                Blog：https://ihuayu8.cn     "
echo "----------------------------------------------------------------"

echo "1.安装程序"
echo "2.卸载程序"
echo "3.启动v2ray"
echo "4.停止v2ray"
echo "5.重启v2ray"
echo "6.查看路径"

read -p "请输入序号：" num

if test $[num] -eq 1 
then
    echo "开始安装依赖..."
    yum -y install wget unzip screen 
    rm -rf /usr/local/v2ray
    mkdir /usr/local/v2ray
 
    echo "开始安装主程序"
    wget "https://zgcwkj.github.io/LinuxScript/V2ray/v2ray-linux-64.zip"
    unzip v2ray-linux-64.zip -d /usr/local/v2ray
    chmod 777 /usr/local/v2ray/*
    chmod 777 /var/run/screen
    
    cp $0 /usr/local/v2ray/hcaas.sh
    
    #创建快捷方式
    ln -s /usr/local/v2ray/hcaas.sh /usr/local/sbin/v2ray
    chmod 777 /usr/local/sbin/v2ray
    
    rm -rf v2ray-linux-64.zip
    
    echo "正在启动v2ary..."
    screen_name=$"v2ray"
    cmd=$"cd /usr/local/v2ray"
    cmd2=$"./v2ray"
    screen -dmS $screen_name
    screen -x -S $screen_name -p 0 -X stuff "$cmd"
    screen -x -S $screen_name -p 0 -X stuff $'\n'
    screen -x -S $screen_name -p 0 -X stuff "$cmd2"
    screen -x -S $screen_name -p 0 -X stuff $'\n'
    
    echo "-------------------------------------------------------------------------------------------------------"
    echo "                                    程序安装完成,v2ray已启动！                                         "
    echo "                              剪贴板导入后请自行修改IP地址为容器的公网IP                               "
    echo "                                ***使用v2ray命令即可调出管理菜单***                                    "
    echo "-------------------------------------------------------------------------------------------------------"
elif test $[num] -eq 2
then 
      if  screen -ls | grep -q "v2ray"
      then
          echo "正在停止v2ray..."
          screen_name=$"v2ray"
          screen -S $screen_name -X quit
      fi
      rm -rf /usr/local/v2ray
      rm -rf /usr/local/sbin/v2ray
      echo "----------------------------------------------------------------"
      echo "                    程序卸载完成！                              "
      echo "----------------------------------------------------------------"
elif test $[num] -eq 3
then
      if  screen -ls | grep -q "v2ray"
      then
          echo 'v2ray已启动，请先停止后再启动！'
      else
      echo "正在启动v2ray..."
      screen_name=$"v2ray"
      cmd=$"cd /usr/local/v2ray"
      cmd2=$"./v2ray"
      screen -dmS $screen_name
      screen -x -S $screen_name -p 0 -X stuff "$cmd"
      screen -x -S $screen_name -p 0 -X stuff $'\n'
      screen -x -S $screen_name -p 0 -X stuff "$cmd2"
      screen -x -S $screen_name -p 0 -X stuff $'\n'
      echo "----------------------------------------------------------------"
      echo "                    v2ray已成功启动！                           "
      echo "----------------------------------------------------------------"
      fi
elif test $[num] -eq 4
then
      if  screen -ls | grep -q "v2ray"
      then
          echo "正在停止v2ray..."
          screen_name=$"v2ray"
          screen -S $screen_name -X quit
          echo "----------------------------------------------------------------"
          echo "                     v2ray已停止！                              "
          echo "----------------------------------------------------------------"            
      else
          echo "v2ray未启动！"
      fi
elif test $[num] -eq 5
then
      echo "正在重启v2ray..." 
      screen_name=$"v2ray"
      cmd=$"cd /usr/local/v2ray"
      cmd2=$"./v2ray"
      screen -S $screen_name -X quit
      screen -dmS $screen_name
      screen -x -S $screen_name -p 0 -X stuff "$cmd"
      screen -x -S $screen_name -p 0 -X stuff $'\n'
      screen -x -S $screen_name -p 0 -X stuff "$cmd2"
      screen -x -S $screen_name -p 0 -X stuff $'\n'   
      echo "----------------------------------------------------------------"
      echo "                     v2ray重启完成！                            "
      echo "----------------------------------------------------------------"          
elif test $[num] -eq 6
then
      echo "----------------------------------------------------------------"
      echo "                路径为：/usr/local/v2ray                        "
      echo "----------------------------------------------------------------"   
else
    echo "输入错误！"
fi

