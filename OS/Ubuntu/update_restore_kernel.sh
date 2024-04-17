#!/bin/bash

# 自定义内核版本
custom_kernel_version="5.15.7"

# 备份当前内核版本
backup_kernel() {
    sudo cp /boot/vmlinuz-$(uname -r) /boot/vmlinuz-$(uname -r).bak
}

# 恢复备份的内核版本
restore_kernel() {
    sudo mv /boot/vmlinuz-$(uname -r).bak /boot/vmlinuz-$(uname -r)
}

# 更新内核
update_kernel() {
    sudo apt update && \
    sudo apt upgrade -y && \
    sudo apt install -y linux-image-$custom_kernel_version linux-headers-$custom_kernel_version
}

# 更新 GRUB 引导菜单
update_grub() {
    sudo update-grub
}

# 检查内核是否更新成功
check_kernel_updated() {
    new_kernel=$(uname -r)
    if [ "$new_kernel" == "$custom_kernel_version" ]; then
        echo "内核已成功更新到版本：$new_kernel"
        return 0
    else
        echo "内核更新失败，正在回滚..."
        return 1
    fi
}

# 检查是否需要更新内核
current_kernel=$(uname -r)
echo "当前内核版本：$current_kernel"

# 更新内核
backup_kernel
update_kernel && update_grub

# 检查内核是否更新成功
if check_kernel_updated; then
    echo "内核更新成功。"
else
    echo "内核更新失败，正在恢复备份..."
    restore_kernel && update_grub
    echo "已成功恢复到原内核版本。"
fi
