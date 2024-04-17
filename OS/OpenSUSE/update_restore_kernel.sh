#!/bin/bash

# 自定义内核版本
custom_kernel_version="5.15.7"

# 备份当前内核版本
backup_kernel() {
    sudo cp /boot/vmlinuz /boot/vmlinuz.bak
}

# 恢复备份的内核版本
restore_kernel() {
    sudo mv /boot/vmlinuz.bak /boot/vmlinuz
}

# 更新内核
update_kernel() {
    sudo zypper refresh && \
    sudo zypper update && \
    sudo zypper install -y kernel-default-$custom_kernel_version
}

# 配置 GRUB 引导菜单
configure_grub() {
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg && \
    sudo grub2-set-default 0
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
update_kernel && configure_grub

# 检查内核是否更新成功
if check_kernel_updated; then
    echo "内核更新成功。"
else
    echo "内核更新失败，正在恢复备份..."
    restore_kernel && configure_grub
    echo "已成功恢复到原内核版本。"
fi
