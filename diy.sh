#!/bin/bash
# diy.sh - OpenWrt 25.12.2 自定义配置脚本
# 注意：25.12 起包管理器从 opkg 改为 apk

# ===== 修改默认后台 IP =====
sed -i 's/192.168.1.1/192.168.8.1/g' package/base-files/files/bin/config_generate

# ===== 修改默认主机名 =====
sed -i 's/OpenWrt/MyRouter/g' package/base-files/files/bin/config_generate

# ===== 添加 OpenClash 源 =====
# OpenClash 官方仓库，master 分支兼容 25.12
echo "src-git openclash https://github.com/vernesong/OpenClash.git;master" \
  >> feeds.conf.default

# ===== 更新并安装 OpenClash =====
./scripts/feeds update openclash
./scripts/feeds install -a -p openclash

# ===== 下载 Clash 核心（可选，也可运行后在 UI 下载）=====
# 若网络不通可注释掉以下几行
CLASH_CORE_DIR="package/luci-app-openclash/root/etc/openclash/core"
mkdir -p "$CLASH_CORE_DIR"
ARCH="linux-amd64"
CLASH_URL="https://github.com/vernesong/OpenClash/releases/download/Clash/clash-${ARCH}.tar.gz"
echo "尝试下载 Clash 核心: $CLASH_URL"
curl -fsSL "$CLASH_URL" | tar xz -C "$CLASH_CORE_DIR" && \
  chmod +x "$CLASH_CORE_DIR/clash" && \
  echo "✅ Clash 核心下载成功" || \
  echo "⚠️  Clash 核心下载失败，请运行后在 OpenClash 界面手动更新"

echo "✅ diy.sh 执行完毕"
