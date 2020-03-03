#!/bin/bash
if [[ $(lsb_release -cs) == "xenial" ]]; then # replace 8.04 by the number of release you want
    wget https://repo.zabbix.com/zabbix/4.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.4-1+xenialll.deb
    dpkg -i zabbix-release_4.4-1+xenial_all.deb
elif [[ $(lsb_release -cs) == "bionic" ]]; then
    wget https://repo.zabbix.com/zabbix/4.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.4-1+bionic_all.deb
    dpkg -i zabbix-release_4.4-1+bionic_all.deb
else
    echo "Non-compatible release"
    exit
fi

curl "https://raw.githubusercontent.com/scv-m/linux-zabbix-agent-install-script/master/zabbix_agentd.conf" > /etc/zabbix/zabbix_agentd.conf
apt update && sudo apt -y install zabbix-agent
sudo service zabbix-agent start
