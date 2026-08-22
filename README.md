# LibWrt AX6600 云编译

京东云无线宝 **RE-CS-02（雅典娜 AX6600）**，源码 [LiBwrt/LibWrt](https://github.com/LiBwrt/LibWrt) 分支 `25.12-nss`。

预装：dae、HomeProxy、Tailscale、OpenList、ddns-go、Docker（青龙）、partexp。
不含 OpenClash / PassWall。内核已开 BTF/XDP。

## 编译

1. 仓库 **Settings → Actions → General**
   - Allow all actions
   - Workflow permissions → **Read and write permissions** → Save
2. **Actions → Build AX6600 → Run workflow**
3. 3～6 小时后在 Artifacts / Releases 下 `*-squashfs-sysupgrade.bin`
