#!/bin/bash

# 检测操作系统
if [ -f /etc/debian_version ]; then
    # Debian/Ubuntu 系统
    echo "Detected Debian/Ubuntu system."
    sudo apt update
    sudo apt install -y fail2ban

    # 创建本地配置文件
    sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

    # 配置SSH保护
    echo "[sshd]" | sudo tee -a /etc/fail2ban/jail.local
    echo "enabled = true" | sudo tee -a /etc/fail2ban/jail.local
    echo "port = ssh" | sudo tee -a /etc/fail2ban/jail.local
    echo "filter = sshd" | sudo tee -a /etc/fail2ban/jail.local
    echo "logpath = /var/log/auth.log" | sudo tee -a /etc/fail2ban/jail.local
    echo "maxretry = 5" | sudo tee -a /etc/fail2ban/jail.local
    echo "bantime = -1" | sudo tee -a /etc/fail2ban/jail.local

elif [ -f /etc/redhat-release ]; then
    # CentOS/RHEL 系统
    echo "Detected CentOS/RHEL system."
    sudo yum install -y epel-release
    sudo yum install -y fail2ban

    # 创建本地配置文件
    sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

    # 配置SSH保护
    echo "[sshd]" | sudo tee -a /etc/fail2ban/jail.local
    echo "enabled = true" | sudo tee -a /etc/fail2ban/jail.local
    echo "port = ssh" | sudo tee -a /etc/fail2ban/jail.local
    echo "filter = sshd" | sudo tee -a /etc/fail2ban/jail.local
    echo "logpath = /var/log/secure" | sudo tee -a /etc/fail2ban/jail.local
    echo "maxretry = 3" | sudo tee -a /etc/fail2ban/jail.local
    echo "bantime = 86400" | sudo tee -a /etc/fail2ban/jail.local

else
    echo "Unsupported operating system."
    exit 1
fi

# 启动并设置为开机自启
sudo systemctl enable --now fail2ban

echo "fail2ban has been installed and configured successfully."
