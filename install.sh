#!/bin/bash

# Ensure the script is running with Bash version 4 or higher
if (( BASH_VERSINFO[0] < 4 )); then
    echo "This script requires Bash version 4 or higher. Please upgrade your Bash."
    exit 1
fi

declare -A zabbix_releases

# Define Zabbix release URLs for Ubuntu
zabbix_releases=(
    ["xenial"]="https://repo.zabbix.com/zabbix/4.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.4-1+xenial_all.deb"
    ["bionic"]="https://repo.zabbix.com/zabbix/4.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.4-1+bionic_all.deb"
    ["focal"]="https://repo.zabbix.com/zabbix/5.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.2-1+ubuntu20.04_all.deb"
    ["jammy"]="https://repo.zabbix.com/zabbix/5.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.2-1+ubuntu20.04_all.deb"
    ["jammy"]="https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4+ubuntu22.04_all.deb"
    ["lunar"]="https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-6+ubuntu24.04_all.deb"
)

# Define Zabbix release URLs for Debian
zabbix_releases+=(
    ["stretch"]="https://repo.zabbix.com/zabbix/4.0/debian/pool/main/z/zabbix-release/zabbix-release_4.0-3+stretch_all.deb"
    ["buster"]="https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_6.0-4+debian10_all.deb"
    ["bullseye"]="https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_6.0-4+debian11_all.deb"
    ["bookworm"]="https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_6.0-5+debian12_all.deb"
)

# Define Zabbix release URL for Sangoma Linux 7
sangoma_release="https://repo.zabbix.com/zabbix/5.2/rhel/7/x86_64/zabbix-agent-5.2.7-1.el7.x86_64.rpm"

# Detect OS and version
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VERSION=$VERSION_ID
else
    OS=$(uname -s)
    VERSION=$(uname -r)
fi

# Install Zabbix agent based on the OS and version
if [ "$OS" = "ubuntu" ] || [ "$OS" = "debian" ]; then
    DISTRO_CODENAME=$(lsb_release -cs)
    ZABBIX_URL=${zabbix_releases[$DISTRO_CODENAME]}

    if [ -n "$ZABBIX_URL" ]; then
        curl -O "$ZABBIX_URL"
        DEB_PACKAGE=$(basename "$ZABBIX_URL")
        dpkg -i "$DEB_PACKAGE"
        apt update && apt -y install zabbix-agent
    else
        echo "Non-compatible $OS release"
        exit 1
    fi

elif [ "$OS" = "sangoma" ] && [ "$VERSION" = "7" ]; then
    rpm -ivh "$sangoma_release"
    yum -y install zabbix-agent

else
    echo "Non-compatible OS release"
    exit 1
fi

# Reload systemd to recognize any changes
systemctl daemon-reload

# Create Zabbix agent configuration directory
mkdir -p /etc/zabbix/zabbix_agent.d

# Download Zabbix agent configuration files
curl "https://raw.githubusercontent.com/scv-m/linux-zabbix-agent-install-script/master/zabbix_agentd.conf" > /tmp/zabbix_agentd.conf
curl "https://raw.githubusercontent.com/itmicus/zabbix/master/Templates/Operating%20Systems/Linux/os_linux_disk_performance.conf" > /etc/zabbix/zabbix_agent.d/os_linux_disk_performance.conf
curl "https://raw.githubusercontent.com/itmicus/zabbix/master/Templates/Operating%20Systems/Linux/os_linux_memory.conf" > /etc/zabbix/zabbix_agent.d/os_linux_memory.conf
curl "https://raw.githubusercontent.com/itmicus/zabbix/master/Templates/Operating%20Systems/Linux/os_linux_network.conf" > /etc/zabbix/zabbix_agent.d/os_linux_network.conf

# Create a timestamped backup of the existing Zabbix agent configuration file
if [ -f /etc/zabbix/zabbix_agentd.conf ]; then
    timestamp=$(date +%Y%m%d%H%M%S)
    cp /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.bak.$timestamp
fi

# Move the main Zabbix agent configuration file
mv /tmp/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf

# Restart the Zabbix agent service and check its status
if service zabbix-agent restart; then
    systemctl status zabbix-agent
fi
