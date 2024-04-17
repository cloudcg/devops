#!/bin/bash

# =============================
# 用户可配置区域
# =============================

# 定义 openSUSE 版本和相应的网络配置方式
declare -A opensuse_versions=(
    ["15.2"]="networkmanager"
    ["15.1"]="networkmanager"
    ["15.0"]="networkmanager"
    ["42.3"]="ifup"
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

# 获取当前 openSUSE 版本
current_version=$(cat /etc/os-release | grep '^VERSION_ID' | awk -F '"' '{print $2}')

# 检查是否支持当前 openSUSE 版本
if [[ ! ${opensuse_versions[$current_version]} ]]; then
    echo "不支持的 openSUSE 版本：$current_version。"
    exit 1
fi

# 备份网络配置文件
backup_file="/etc/udev/rules.d/70-persistent-net.rules.bak"
if [[ ${opensuse_versions[$current_version]} == "ifup" ]]; then
    sudo cp /etc/udev/rules.d/70-persistent-net.rules "$backup_file"
else
    echo "未找到适用于 $current_version 的网络配置方式。"
    exit 1
fi

# 根据不同的网络配置方式修改网卡名称
if [[ ${opensuse_versions[$current_version]} == "ifup" ]]; then
    # 使用 ifup 方式修改网卡名称
    for current_iface in "${!iface_mapping[@]}"; do
        new_iface="${iface_mapping[$current_iface]}"
        sudo sed -i "s/$current_iface/$new_iface/g" /etc/udev/rules.d/70-persistent-net.rules
    done

    echo "网络接口名称已成功修改，请重启系统使修改生效。"
else
    echo "当前 openSUSE 版本与配置的版本不匹配。"
    exit 1
fi
