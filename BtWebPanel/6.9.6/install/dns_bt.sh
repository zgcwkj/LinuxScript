#!/bin/bash
_api_path='/www/server/panel/plugin/dns/dns_main.py'
if [ ! -f $_api_path ];then
        _err "未安装dns云解析插件!"
        exit;
fi

dns_bt_add() {
  fulldomain=$1
  txtvalue=$2
  _info "Using bt-dns"
  _debug fulldomain "$fulldomain"
  _debug txtvalue "$txtvalue"
  result=`python /www/server/panel/plugin/dns/dns_main.py add_txt $fulldomain $txtvalue`
  if [ "$result" = "True" ];then
	return 0
  fi 
  return 1
}

dns_bt_rm() {
  fulldomain=$1
  txtvalue=$2
  _info "Using bt-dns"
  _debug fulldomain "$fulldomain"
  _debug txtvalue "$txtvalue"
  result=`python /www/server/panel/plugin/dns/dns_main.py remove_txt $fulldomain $txtvalue`
  if [ "$result" = "True" ];then
        return 0
  fi
  return 1
}
