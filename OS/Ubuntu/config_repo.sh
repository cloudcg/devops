#!/bin/bash

# 备份原有的源文件
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

# 清华大学源
configure_tuna_source() {
    sudo sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
    sudo sed -i 's/security.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
}

# 阿里云源
configure_aliyun_source() {
    sudo sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
    sudo sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
}

# 中科大源
configure_ustc_source() {
    sudo sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
    sudo sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
}

# 选择配置源
echo "请选择要配置的软件源："
echo "1. 清华大学源"
echo "2. 阿里云源"
echo "3. 中科大源"
read -p "请选择 [1/2/3]: " choice

case $choice in
    1) configure_tuna_source ;;
    2) configure_aliyun_source ;;
    3) configure_ustc_source ;;
    *) echo "无效的选项。" ;;
esac

# 更新软件包列表
sudo apt update

echo "软件源配置完成。"
