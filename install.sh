#!/bin/sh
if [ $(lsb_release -cs) = "xenial" ]
then
    curl -O https://repo.zabbix.com/zabbix/4.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.4-1+xenial_all.deb
    dpkg -i zabbix-release_4.4-1+xenial_all.deb
elif [ $(lsb_release -cs) = "bionic" ]
then
    curl -O https://repo.zabbix.com/zabbix/4.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.4-1+bionic_all.deb
    dpkg -i zabbix-release_4.4-1+bionic_all.deb
else
    echo "Non-compatible release"
    exit
fi

curl "https://raw.githubusercontent.com/scv-m/linux-zabbix-agent-install-script/master/zabbix_agentd.conf" > /etc/zabbix/zabbix_agentd.conf
apt update && sudo apt -y install zabbix-agent
sudo service zabbix-agent start

if sudo service zabbix-agent start
then
    systemctl status zabbix-agent
fi