#!/bin/bash

# 网卡名称
INTERFACE="eth0"

# IP 地址
IPADDR="192.168.1.100"

# 子网掩码
NETMASK="255.255.255.0"

# 网关地址
GATEWAY="192.168.1.1"

# DNS 服务器地址
DNS1="8.8.8.8"
DNS2="8.8.4.4"

# 配置文件路径
CONFIG_FILE="/etc/sysconfig/network/ifcfg-$INTERFACE"

# 检查配置文件是否存在，不存在则创建
if [ ! -f "$CONFIG_FILE" ]; then
    echo "BOOTPROTO='static'" > "$CONFIG_FILE"
    echo "STARTMODE='auto'" >> "$CONFIG_FILE"
    echo "NAME='$INTERFACE'" >> "$CONFIG_FILE"
fi

# 更新配置文件中的参数值
sed -i "s/^IPADDR=.*/IPADDR='$IPADDR'/" "$CONFIG_FILE"
sed -i "s/^NETMASK=.*/NETMASK='$NETMASK'/" "$CONFIG_FILE"
sed -i "s/^GATEWAY=.*/GATEWAY='$GATEWAY'/" "$CONFIG_FILE"

# 设置 DNS 服务器
echo "DNS1='$DNS1'" >> "$CONFIG_FILE"
echo "DNS2='$DNS2'" >> "$CONFIG_FILE"

# 重启网络服务
if systemctl restart network.service; then
    echo "网络配置已更新并重启成功。"
else
    echo "网络配置更新失败，请手动重启网络服务。"
fi
