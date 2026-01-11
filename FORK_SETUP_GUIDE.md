# uv Fork - 二进制构建配置指南

## 概述

这是一个 uv 的 fork，优化用于：
- ✅ **自动从官方仓库同步源代码**
- ✅ **专注于构建多平台独立二进制**
- ✅ **使用 GitHub Actions 实现完全自动化**

## 架构设计

```
┌─────────────────────────────────┐
│   astral-sh/uv (官方仓库)        │
│   (upstream)                    │
└────────────┬────────────────────┘
             │ 每日自动同步
             ↓
┌─────────────────────────────────┐
│   你的 Fork (chinario/uv)        │
│                                 │
│  - 自动同步 upstream 代码        │
│  - 构建多平台二进制              │
│  - 发布 GitHub Releases          │
└─────────────────────────────────┘
```

## 工作流程

### 1. 自动同步流程

**触发方式：**
- ⏰ 每天 UTC 02:00 自动触发
- 🎯 手动触发：GitHub Actions 界面

**工作流：** `.github/workflows/sync-upstream.yml`

**流程：**
```
git fetch upstream/main
    ↓
比较本地与 upstream
    ↓
自动合并 (成功) → 直接 push
    ↓
合并冲突 → 自动处理 (保留 upstream，保留本地 workflows)
    ↓
复杂冲突 → 创建 PR 等待手动审查
```

### 2. 二进制构建流程

**触发方式：**
- 📌 推送到 `main` 分支
- 🏷️ 创建标签 `v*` (发布 Release)
- 🎯 手动触发：GitHub Actions 界面
- 📝 修改构建配置文件时

**工作流：** `.github/workflows/build-binaries-only.yml`

**构建矩阵：**
| 平台 | 架构 | 系统 |
|-----|------|------|
| Linux | x86_64 | ubuntu-latest |
| Linux | ARM64 | ubuntu-latest |
| macOS | x86_64 | macos-13 |
| macOS | ARM64 | macos-14 |
| Windows | x86_64 | windows-latest |

**输出：**
- 每个平台的独立二进制 (uv 和 uvx)
- 上传为 GitHub Artifacts (7 天保留期)
- 标签发布时：创建 Release 并上传所有二进制

## 初始设置

### 步骤 1: 克隆并配置

```bash
git clone https://github.com/your-username/uv.git
cd uv

# 配置 git (重要：解决 "divergent branches" 错误)
bash scripts/init-git-config.sh

# 或手动配置:
git config pull.ff false

# 运行自动配置脚本
bash scripts/setup-fork-binaries.sh
```

**⚠️ 重要：Git 配置**

如果手动同步时出现以下错误：
```
fatal: Need to specify how to reconcile divergent branches.
```

解决方法：
```bash
# 方法 1: 单个仓库配置
git config pull.ff false

# 方法 2: 全局配置（推荐）
git config --global pull.ff false

# 方法 3: 自动配置脚本
bash scripts/init-git-config.sh
```

这个配置告诉 git 使用 merge 而不是 rebase，允许非快进合并。

### 步骤 2: 配置 GitHub (可选)

如需自动发布 Release，确保有适当的权限：

1. 进入 **Settings** → **Actions**
2. 确保 "Read and write permissions" 已启用

### 步骤 3: 验证工作流

```bash
# 检查远程配置
git remote -v
# 应该显示:
# origin    https://github.com/your-username/uv.git
# upstream  https://github.com/astral-sh/uv.git

# 手动同步测试
bash scripts/sync-upstream.sh
```

## 日常使用

### 手动同步源代码

```bash
bash scripts/sync-upstream.sh
```

这个脚本会：
1. 从官方仓库获取最新代码
2. 本地所有改动会被暂存
3. 合并 upstream 改动
4. 恢复本地改动

### 触发二进制构建

**方式 1: 推送到 main**
```bash
git push origin main
# 自动触发构建，约 15-30 分钟完成
```

**方式 2: 创建发布标签**
```bash
git tag v0.9.23
git push origin v0.9.23
# 构建完成后自动创建 GitHub Release
```

**方式 3: 手动触发**
- 进入 GitHub 仓库
- Actions → "Build release binaries (Fork)" → Run workflow

### 查看构建结果

1. **Artifacts (临时，7天)**
   - GitHub 仓库 → Actions → 选择工作流 → 下载 artifacts

2. **Release (永久)**
   - GitHub 仓库 → Releases → 下载二进制
   - 仅在创建版本标签时生成

## 文件说明

```
.github/workflows/
├── sync-upstream.yml              # 自动同步工作流 (每日)
└── build-binaries-only.yml        # 二进制构建工作流

scripts/
├── sync-upstream.sh               # 手动同步脚本
└── setup-fork-binaries.sh         # 初始配置脚本

README.md                          # 包含 fork 配置说明
```

## 配置定制

### 修改同步频率

编辑 `.github/workflows/sync-upstream.yml`：

```yaml
on:
  schedule:
    # 改为其他频率 (cron 语法)
    - cron: "0 2 * * *"  # 每天 UTC 02:00
    # 或者: "0 */6 * * *"  # 每 6 小时
```

### 修改构建平台

编辑 `.github/workflows/build-binaries-only.yml`：

```yaml
strategy:
  matrix:
    include:
      # 在这里添加/删除平台
      - os: ubuntu-latest
        target: x86_64-unknown-linux-gnu
```

### 重新启用 CI/发布

如果需要运行完整的 CI 或发布：

1. 撤销 `setup-fork-binaries.sh` 的禁用标记
2. 或恢复原始工作流：
   ```bash
   git checkout origin/main -- .github/workflows/
   ```

## 故障排除

### 同步失败

**问题：** 合并冲突导致同步失败

**解决：**
```bash
# 查看冲突
git status

# 手动解决冲突，然后:
git add -A
git commit -m "resolve sync conflicts"
git push origin main
```

### 构建失败

**问题：** 特定平台的构建失败

**排查：**
1. 查看 GitHub Actions 的构建日志
2. 本地重现：
   ```bash
   cargo build --release --target <target> --bin uv
   ```

### 同步丢失改动

**预防：**
- `sync-upstream.sh` 自动保存本地改动
- 如果有冲突，改动会被暂存并显示：
  ```bash
  git stash list
  ```

## 最佳实践

1. **定期同步**
   - 至少每周手动检查或让自动同步运行
   - 及时处理冲突

2. **版本标签规范**
   ```bash
   git tag -a v0.9.23 -m "Release v0.9.23"
   git push origin v0.9.23
   ```

3. **监控工作流**
   - 定期检查 Actions 选项卡
   - 订阅工作流失败通知

4. **维护记录**
   - 在 CHANGELOG 中记录 fork 特定的改动
   - 标注哪些是 fork 专有的

## 常见问题

**Q: 为什么我的改动在同步后消失了？**
A: 它们会被保存在 git stash 中。使用 `git stash pop` 恢复。

**Q: 能否同步特定的官方版本？**
A: 可以，手动检出特定标签：
```bash
git fetch upstream
git checkout upstream/tags/v0.9.20
```

**Q: 如何只在特定平台构建？**
A: 编辑 `.github/workflows/build-binaries-only.yml` 中的 `matrix` 部分。

**Q: 构建需要多长时间？**
A: 通常 15-30 分钟，取决于并行度和平台数。

## 后续支持

- 🔗 官方 uv: https://github.com/astral-sh/uv
- 📚 文档: https://docs.astral.sh/uv
- 💬 Discord: https://discord.gg/astral-sh
