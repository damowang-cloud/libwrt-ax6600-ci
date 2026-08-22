#!/bin/bash
# 在 openwrt 源码根目录执行
set -e
echo "===== DIY extra packages ====="

clone_pkg() {
  local url="$1" dest="$2"
  if [ ! -d "$dest" ]; then
    git clone --depth 1 "$url" "$dest" || echo "WARN: clone failed $url"
  fi
}

# 一键分区扩容挂载（64G eMMC → Docker）
clone_pkg https://github.com/sirpdboy/luci-app-partexp.git package/luci-app-partexp

# 雅典娜点阵屏（失败不中断）
if [ ! -d package/luci-app-athena-led ]; then
  git clone --depth 1 https://github.com/unraveloop/JDC-AX6600-Athena-LED-Controller.git /tmp/athena-led || true
  if [ -d /tmp/athena-led/luci-app-athena-led ]; then
    cp -a /tmp/athena-led/luci-app-athena-led package/
  fi
  if [ -d /tmp/athena-led/athena-led ]; then
    cp -a /tmp/athena-led/athena-led package/
  fi
  rm -rf /tmp/athena-led
fi

# 默认主题 argon（源码自带则跳过）
if [ ! -d feeds/luci/themes/luci-theme-argon ] && [ ! -d package/luci-theme-argon ]; then
  git clone --depth 1 -b master https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon || true
fi

sed -i "s/hostname='ImmortalWrt'/hostname='LibWrt'/g" package/base-files/files/bin/config_generate 2>/dev/null || true
sed -i "s/hostname='OpenWrt'/hostname='LibWrt'/g" package/base-files/files/bin/config_generate 2>/dev/null || true

echo "DIY done"
