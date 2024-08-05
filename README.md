
# Zabbix Agent Installation Script

This script automates the installation and configuration of the Zabbix agent on Ubuntu, Debian, and Sangoma systems. It checks the system's distribution and version, downloads the appropriate Zabbix agent package, installs it, and configures the system with the provided agent config.

## Prerequisites

Before running this script, ensure that your system is one of the supported Ubuntu, Debian, or Sangoma releases:

- Ubuntu 16.04 (Xenial)
- Ubuntu 18.04 (Bionic)
- Ubuntu 20.04 (Focal)
- Ubuntu 22.04 (Jammy)
- Ubuntu 24.04 (Lunar)
- Debian 9 (Stretch)
- Debian 10 (Buster)
- Debian 11 (Bullseye)
- Debian 12 (Bookworm)
- Sangoma Linux 7

You must have superuser privileges to execute the installation commands successfully. This typically means running the script as root or with `sudo`.

## One-liner

```sh
sudo apt update; sudo apt -y install curl; curl -sL https://github.com/McKinnonIT/linux-zabbix-agent-install-script/blob/master/install.sh | sudo bash
```

## Installation

1. Download the script to your local machine. You can do this by creating a new file and copying the content of the script into it or by using the `wget` or `curl` command to download the script directly from a repository.

    ```sh
    curl -O https://github.com/McKinnonIT/linux-zabbix-agent-install-script/blob/master/install.sh
    ```

2. Make the script executable:

    ```sh
    chmod +x install.sh
    ```

3. Run the script with superuser privileges:

    ```sh
    sudo ./install.sh
    ```

The script will automatically detect your system version, download the correct Zabbix agent package, install it, and configure it with basic monitoring templates. It concludes by restarting the Zabbix agent service to apply the new configurations.

## Post-installation

After installation, the Zabbix agent will be running and configured to start on boot. You can check the status of the Zabbix agent service with:

```sh
systemctl status zabbix-agent
```
