#!/bin/bash

# =============================
# 用户可配置区域
# =============================

# 定义 Ubuntu 版本和相应的网络配置方式
declare -A ubuntu_versions=(
    ["20.04"]="netplan"
    ["18.04"]="netplan"
    ["16.04"]="ifupdown"
)

# 原网卡名称和新网卡名称对应关系，格式为 "原网卡名称 新网卡名称"
declare -A iface_mapping=(
    ["eth0"]="ens1"
    ["eth1"]="ens2"
)

# =============================
# 结束用户可配置区域
# =============================

# 检查是否有 root 权限
if [ "$(id -u)" -ne 0 ]; then
  echo "请使用 root 权限运行此脚本。"
  exit 1
fi

# 获取当前 Ubuntu 版本
current_version=$(lsb_release -rs)

# 检查是否支持当前 Ubuntu 版本
if [[ ! ${ubuntu_versions[$current_version]} ]]; then
    echo "不支持的 Ubuntu 版本：$current_version。"
    exit 1
fi

# 备份网络配置文件
backup_file="/etc/netplan/netplan.yaml.bak"
if [[ ${ubuntu_versions[$current_version]} == "netplan" ]]; then
    sudo cp /etc/netplan/*.yaml "$backup_file"
else
    sudo cp /etc/network/interfaces "$backup_file"
fi

# 根据不同的网络配置方式修改网卡名称
if [[ ${ubuntu_versions[$current_version]} == "netplan" ]]; then
    # 使用 netplan 方式修改网卡名称
    for current_iface in "${!iface_mapping[@]}"; do
        new_iface="${iface_mapping[$current_iface]}"
        sudo sed -i "s/$current_iface/$new_iface/g" /etc/netplan/*.yaml
    done

    # 应用配置
    sudo netplan apply

    echo "网络接口名称已成功修改。"
else
    # 使用 ifupdown 方式修改网卡名称
    for current_iface in "${!iface_mapping[@]}"; do
        new_iface="${iface_mapping[$current_iface]}"
        sudo sed -i "s/$current_iface/$new_iface/g" /etc/network/interfaces
    done

    # 重启网络服务
    sudo systemctl restart networking

    echo "网络接口名称已成功修改。"
fi
