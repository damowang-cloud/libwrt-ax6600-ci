# LibWrt 雅典娜 AX6600 云编译

京东云无线宝 **RE-CS-02（雅典娜 AX6600）** 固件，源码 [LiBwrt/LibWrt](https://github.com/LiBwrt/LibWrt) 分支 `25.12-nss`（满血 NSS）。

预装：**dae、HomeProxy、Tailscale、OpenList、ddns-go、Docker（跑青龙）、分区扩容 partexp（64G）**。  
不含 OpenClash / PassWall。已开 dae 所需内核 BTF / XDP / BPF。


## 使用（GitHub Actions）

1. 新建一个 **Public** 仓库（免费额度够用），把本目录全部文件上传进去（不要套一层多余文件夹）。
2. 仓库 **Settings → Actions → General**：
   - Actions 选 **Allow all actions**
   - Workflow permissions 选 **Read and write permissions**，保存
3. 打开 **Actions** → 选 **Build AX6600** → **Run workflow**
4. 等 3～6 小时。成功后：
   - **Artifacts** 里下 zip
   - 或 **Releases** 里下 `*-squashfs-sysupgrade.bin`
5. 已在 OpenWrt 上：系统 → 备份/升级 → 刷 **sysupgrade.bin**（可保留配置）

首次从原厂刷入用 `*-squashfs-factory.bin`，并确认已刷第三方 U-Boot / 足够大的 rootfs 分区。

## 刷完自检

```sh
uname -r
ls -l /sys/kernel/btf/vmlinux          # 必须存在，dae 才可用
apk list --installed | grep -E 'dae|homeproxy|tailscale|openlist|ddns-go|dockerd'
```

## 64G 分区（等刷好再做）

固件里已带 **分区扩容（luci-app-partexp）**。  
**先不要自己格式化。** 刷好后 SSH 执行下面两条，把输出发回来，再按你机器的实际分区一步步点：

```sh
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT,LABEL
df -h
```

乱点有可能把系统分区清掉导致变砖。Docker 数据目录默认 `/opt/docker`，扩容后会改挂到新分区。

## 青龙面板（Docker）

LuCI → Docker → 确认 Docker 已运行，数据目录默认 `/opt/docker`。

SSH：

```sh
docker run -d \
  --name qinglong \
  --hostname qinglong \
  --restart unless-stopped \
  -p 5700:5700 \
  -v /opt/docker/qinglong:/ql/data \
  whyour/qinglong:latest
```

浏览器打开 `http://路由IP:5700`。

## 改插件

编辑 `config/re-cs-02.config` 后重新 Run workflow。  
`=y` 编进固件，`is not set` 去掉。

## 说明

- 包管理是 **apk**（25.12），不是 opkg
- dae 用 ImmortalWrt 官方 `luci-app-dae`（和 kenzo 同源 eBPF，少一层 feed 冲突）
- Tailscale 用 `luci-app-tailscale-community`
- 点阵屏驱动会尽量编进；编不过不影响开机
