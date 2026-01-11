# 快速参考 - uv Fork 操作指南

## 🚀 首次使用

```bash
# 1. 初始化配置
bash scripts/setup-fork-binaries.sh

# 2. 配置 git
bash scripts/init-git-config.sh

# 3. 手动同步测试
bash scripts/sync-upstream.sh
```

## 📋 日常操作

### 同步源代码
```bash
# 手动同步
bash scripts/sync-upstream.sh

# 或等待每日自动同步 (UTC 02:00)
```

### 构建二进制
```bash
# 本地构建
cargo build --release --bin uv --bin uvx

# 自动构建 (GitHub Actions)
# - 推送到 main: git push origin main
# - 创建版本标签: git tag v0.9.23 && git push origin v0.9.23
```

### 创建版本发布
```bash
# 创建版本标签
git tag v0.9.23
git push origin v0.9.23

# GitHub 自动:
# 1. 构建所有平台的二进制
# 2. 创建 Release
# 3. 上传二进制文件
```

## 📂 重要文件

| 文件 | 用途 |
|------|------|
| `scripts/sync-upstream.sh` | 手动同步源代码 |
| `scripts/init-git-config.sh` | 配置 git 合并策略 |
| `scripts/setup-fork-binaries.sh` | 首次初始化 |
| `.github/workflows/sync-upstream.yml` | 自动日同步 |
| `.github/workflows/build-binaries-only.yml` | 构建二进制 |
| `FORK_SETUP_GUIDE.md` | 完整配置指南 |
| `TROUBLESHOOTING.md` | 问题排除 |

## ⚡ 常用命令

```bash
# 查看当前状态
git status
git log --oneline -10

# 检查远程
git remote -v

# 查看最近推送
git push -u origin main

# 查看工作流运行状态
# GitHub → Actions → 选择工作流

# 下载构建产物
# GitHub → Actions → 选择运行 → 下载 artifacts
```

## 🔧 快速修复

### Git 配置错误
```bash
git config pull.ff false
```

### 合并冲突
```bash
git merge --abort
# 编辑冲突文件
git add .
git commit -m "resolve conflicts"
```

### 取消最后一个提交
```bash
git reset --soft HEAD~1
```

### 查看 stashed 改动
```bash
git stash list
git stash pop
```

## 📊 架构一览

```
官方仓库 (astral-sh/uv)
         ↓ (每日自动同步)
    你的 Fork
         ↓
   推送 main 或创建标签
         ↓
   GitHub Actions 构建
         ↓
   5 个平台的二进制
         ↓
   GitHub Releases
```

## ✅ 检查清单

初次设置：
- [ ] 克隆仓库
- [ ] 运行 `bash scripts/setup-fork-binaries.sh`
- [ ] 运行 `bash scripts/init-git-config.sh`
- [ ] 运行 `bash scripts/sync-upstream.sh` 测试

日常维护：
- [ ] 定期检查同步状态 (Actions)
- [ ] 定期同步源代码
- [ ] 监控构建状态 (Actions)
- [ ] 检查 Release 是否成功

## 📚 文档导航

- **快速开始** → README.md
- **详细配置** → FORK_SETUP_GUIDE.md
- **问题解决** → TROUBLESHOOTING.md
- **本文件** → QUICK_REFERENCE.md

## 🔗 相关链接

- 官方仓库: https://github.com/astral-sh/uv
- 官方文档: https://docs.astral.sh/uv
- 官方Discord: https://discord.gg/astral-sh

## 💡 提示

1. **自动同步**：GitHub Actions 每天自动同步，无需手动干预
2. **手动同步**：如需立即同步，运行 `bash scripts/sync-upstream.sh`
3. **构建触发**：推送到 main 或创建标签都会自动触发构建
4. **版本发布**：标签发布时自动创建 Release 并上传二进制

---

**最后更新**: 2024 年
