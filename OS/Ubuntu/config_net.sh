#!/bin/bash

# 检测 Ubuntu 版本
get_ubuntu_version() {
    UBUNTU_VERSION=$(lsb_release -rs | cut -d. -f1)
}

# 旧版本 Ubuntu（16.04 及更早版本）的网卡配置
configure_network_interfaces() {
    echo "auto eth0" > /etc/network/interfaces
    echo "iface eth0 inet static" >> /etc/network/interfaces
    echo "    address 192.168.1.100" >> /etc/network/interfaces
    echo "    netmask 255.255.255.0" >> /etc/network/interfaces
    echo "    gateway 192.168.1.1" >> /etc/network/interfaces
    echo "    dns-nameservers 8.8.8.8 8.8.4.4" >> /etc/network/interfaces
}

# 新版本 Ubuntu（18.04 及更新版本）的网卡配置
configure_network_netplan() {
    cat > /etc/netplan/01-netcfg.yaml <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: no
      addresses: [192.168.1.100/24]
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
EOF
    netplan apply
}

# 根据 Ubuntu 版本选择配置方式
configure_network() {
    get_ubuntu_version
    if [ $UBUNTU_VERSION -ge 18 ]; then
        configure_network_netplan
    else
        configure_network_interfaces
    fi
}

# 执行网卡配置
configure_network

echo "网卡配置完成。"