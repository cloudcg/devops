#!/bin/bash

# 备份原有的源文件
sudo cp /etc/zypp/repos.d/zypp.conf /etc/zypp/repos.d/zypp.conf.bak

# 清华大学源
configure_tuna_source() {
    sudo zypper ar -f -n "TUNA" http://mirrors.tuna.tsinghua.edu.cn/opensuse/distribution/leap/15.3/repo/oss/ TUNA
    sudo zypper ar -f -n "TUNA Updates" http://mirrors.tuna.tsinghua.edu.cn/opensuse/distribution/leap/15.3/repo/updates/ TUNA_Updates
}

# 阿里云源
configure_aliyun_source() {
    sudo zypper ar -f -n "Aliyun" http://mirrors.aliyun.com/opensuse/distribution/leap/15.3/repo/oss/ Aliyun
    sudo zypper ar -f -n "Aliyun Updates" http://mirrors.aliyun.com/opensuse/distribution/leap/15.3/repo/updates/ Aliyun_Updates
}

# 中科大源
configure_ustc_source() {
    sudo zypper ar -f -n "USTC" http://mirrors.ustc.edu.cn/opensuse/distribution/leap/15.3/repo/oss/ USTC
    sudo zypper ar -f -n "USTC Updates" http://mirrors.ustc.edu.cn/opensuse/distribution/leap/15.3/repo/updates/ USTC_Updates
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
sudo zypper refresh

echo "软件源配置完成。"
