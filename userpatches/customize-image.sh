#!/bin/bash

# customize-image.sh – 在生成的 Armbian 镜像中安装 CUPS 打印服务

log() {
    echo "[customize] $*"
}

log "Starting post-build customization..."

export DEBIAN_FRONTEND=noninteractive

# 挂载虚拟文件系统（chroot 环境需要）
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs none /dev

# 更新软件源并安装 CUPS 及常用打印机驱动
apt-get update
apt-get install -y \
    cups \
    cups-client \
    cups-filters \
    printer-driver-all \
    printer-driver-gutenprint \
    hplip \          # HP 打印机驱动，可按需移除
    network-manager   # 可选，便于管理无线网络

# 启用 CUPS 远程管理
cupsctl --remote-admin --remote-any --share-printers

# 创建默认用户（可选），并加入 lpadmin 组
if ! id "pi" &>/dev/null; then
    useradd -m -G lpadmin -s /bin/bash pi
    echo "pi:armbian" | chpasswd
日志"已创建用户 'pi'，密码为 'armbian'"
else
    usermod -a -G lpadmin pi
fi

# 清理缓存
apt-get clean

# 卸载虚拟文件系统
卸载 /proc
卸载 /sys
卸载 /dev

日志“定制完成。”
