# 安装：

## 安装 Curl 支持环境

### Debian

``apt -y install curl``

### CentOS

``yum -y install curl``

## 安装 Trojan

### 原版

``source <(curl -sL https://zgcwkj.github.io/LinuxScript/Trojan/install.sh)``

### 修改版（也没修改什么就是源的修改）

``source <(curl -sL https://zgcwkj.github.io/LinuxScript/Trojan/trojan.sh)``

### 说明

安装过程有选项的直接按 1 不用回车

搭建好了之后，直接打开 自己的域名/IP 设置一个**登陆密码** 。账号**admin**，密码自己设置的

## 卸载 Trojan

### 原版

``source <(curl -sL https://zgcwkj.github.io/LinuxScript/Trojan/install.sh) --remove``

### CentOS

``source <(curl -sL https://zgcwkj.github.io/LinuxScript/Trojan/trojan.sh) --remove``

# 命令：

```
Usage:
trojan [flags]
trojan [*]

Available *s:
add 添加用户
completion 自动命令补全(支持 bash 和 zsh)
del 删除用户
help Help about any *
info 用户信息列表
restart 重启 trojan
start 启动 trojan
status 查看 trojan 状态
stop 停止 trojan
tls 证书安装
update 更新 trojan
version 显示版本号
web 以 web 方式启动

Flags:
-h, --help help for trojan
```

# 来源：

> http://yaohuo.me/bbs-812009.html