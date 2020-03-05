#!/bin/sh
if [ $(lsb_release -cs) = "xenial" ]
then
    curl -O https://repo.zabbix.com/zabbix/4.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.4-1+xenial_all.deb
    dpkg -i zabbix-release_4.4-1+xenial_all.deb
elif [ $(lsb_release -cs) = "bionic" ]
then
    curl -O https://repo.zabbix.com/zabbix/4.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.4-1+bionic_all.deb
    dpkg -i zabbix-release_4.4-1+bionic_all.deb
elif [ $(lsb_release -cs) = "stretch" ]
    curl -O http://repo.zabbix.com/zabbix/4.4/debian/pool/main/z/zabbix-release/zabbix-release_4.4-1+stretch_all.deb
    dpkg -i zabbix-release_4.4-1+stretch_all.deb
else
    echo "Non-compatible release"
    exit
fi



apt update && apt -y install zabbix-agent
curl "https://raw.githubusercontent.com/scv-m/linux-zabbix-agent-install-script/master/zabbix_agentd.conf" > /tmp/zabbix_agentd.conf
mv /tmp/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf

if service zabbix-agent restart
then
    systemctl status zabbix-agent
fi
