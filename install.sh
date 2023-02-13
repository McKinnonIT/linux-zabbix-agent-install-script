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
then
    curl -O https://repo.zabbix.com/zabbix/4.0/debian/pool/main/z/zabbix-release/zabbix-release_4.0-3+stretch_all.deb
    dpkg -i zabbix-release_4.0-3+stretch_all.deb
elif [ $(lsb_release -cs) = "focal" ]
then
    curl -O https://repo.zabbix.com/zabbix/5.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.2-1+ubuntu20.04_all.deb
    dpkg -i zabbix-release_5.2-1+ubuntu20.04_all.deb
elif
then [ $(lsb_release -cs) = "jammy" ]
    curl -O https://repo.zabbix.com/zabbix/5.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.2-1+ubuntu20.04_all.deb
    dpkg -i zabbix-release_5.2-1+ubuntu20.04_all.deb
else
    echo "Non-compatible release"
    exit
fi



apt update && apt -y install zabbix-agent
mkdir /etc/zabbix/zabbix_agent.d

curl "https://raw.githubusercontent.com/scv-m/linux-zabbix-agent-install-script/master/zabbix_agentd.conf" > /tmp/zabbix_agentd.conf
curl "https://raw.githubusercontent.com/itmicus/zabbix/master/Templates/Operating%20Systems/Linux/os_linux_disk_performance.conf" > /etc/zabbix/zabbix_agent.d/os_linux_disk_performance.conf
curl "https://raw.githubusercontent.com/itmicus/zabbix/master/Templates/Operating%20Systems/Linux/os_linux_memory.conf" > /etc/zabbix/zabbix_agent.d/os_linux_memory.conf
curl "https://raw.githubusercontent.com/itmicus/zabbix/master/Templates/Operating%20Systems/Linux/os_linux_network.conf" > /etc/zabbix/zabbix_agent.d/os_linux_network.conf

mv /tmp/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf

if service zabbix-agent restart
then
    systemctl status zabbix-agent
fi
