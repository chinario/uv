# uv Fork - 故障排除指南

## 常见问题与解决方案

### 1. Git Pull 错误: "Need to specify how to reconcile divergent branches"

**错误信息：**
```
fatal: Need to specify how to reconcile divergent branches.
```

**原因：**
Git 2.37+ 版本要求明确指定合并策略。

**解决方案：**

**方法 A: 快速修复（推荐）**
```bash
bash scripts/init-git-config.sh
```

**方法 B: 手动配置**
```bash
# 仅当前仓库
git config pull.ff false

# 所有仓库（全局）
git config --global pull.ff false
```

**方法 C: 每次使用时指定**
```bash
git pull upstream main --no-rebase
```

---

### 2. 同步脚本失败：合并冲突无法自动解决

**症状：**
脚本运行时卡住或失败

**解决方案：**
```bash
# 1. 中止当前操作
git merge --abort

# 2. 手动检查冲突
git status

# 3. 解决冲突文件
# 编辑有冲突的文件，移除 <<<<<<, ======, >>>>>> 标记

# 4. 标记为已解决
git add <文件>

# 5. 完成合并
git commit -m "resolve merge conflicts"

# 6. 再次运行同步脚本
bash scripts/sync-upstream.sh
```

---

### 3. Upstream 远程未配置

**错误信息：**
```
fatal: 'upstream' does not appear to be a 'git' repository
```

**解决方案：**
```bash
# 添加 upstream 远程
git remote add upstream https://github.com/astral-sh/uv.git

# 验证
git remote -v
```

---

### 4. 本地改动在同步时丢失

**症状：**
运行同步后本地改动消失

**原因：**
脚本会将本地改动暂存，但可能在合并后无法自动应用

**恢复方法：**
```bash
# 查看所有 stashes
git stash list

# 应用最新的 stash
git stash pop

# 如果需要特定的 stash
git stash pop stash@{N}  # N 是 stash 的编号
```

---

### 5. GitHub Actions 工作流不运行

**检查清单：**

1. ✅ 确保工作流文件存在：
   ```bash
   ls -la .github/workflows/
   ```

2. ✅ 检查工作流是否启用：
   - 进入仓库 → Actions → 查看工作流状态

3. ✅ 检查触发条件：
   ```bash
   # 查看 push 事件是否会触发
   git push origin main
   ```

4. ✅ 查看工作流日志：
   - GitHub 仓库 → Actions → 选择工作流 → 查看日志

---

### 6. 构建二进制失败

**检查日志：**
```bash
# GitHub Actions 工作流日志
# 仓库 → Actions → Build release binaries (Fork) → 选择运行 → 查看详细日志
```

**常见原因：**
- Rust 工具链未正确安装
- 缺少必要的依赖
- 目标平台不支持

**解决方案：**
```bash
# 本地测试构建
cargo build --release --bin uv --bin uvx

# 如果失败，检查 Rust 版本
rustc --version
cargo --version

# 更新 Rust
rustup update
```

---

### 7. 标签发布不创建 Release

**检查点：**

1. ✅ 标签格式是否正确：
   ```bash
   # ✓ 正确
   git tag v0.9.23
   git tag v1.0.0
   
   # ✗ 错误
   git tag 0.9.23      # 缺少 v
   git tag release-0.9.23
   ```

2. ✅ 标签是否已推送：
   ```bash
   git push origin v0.9.23
   
   # 或推送所有标签
   git push origin --tags
   ```

3. ✅ 工作流权限：
   - 仓库 Settings → Actions → "Read and write permissions"

---

### 8. 权限错误：无法推送

**错误信息：**
```
Permission denied (publickey)
或
fatal: could not read from remote repository
```

**解决方案：**

**方法 A: 使用 HTTPS（推荐用于 Actions）**
```bash
git remote set-url origin https://github.com/your-username/uv.git
```

**方法 B: 配置 SSH**
```bash
# 生成 SSH 密钥
ssh-keygen -t ed25519 -C "your-email@example.com"

# 将公钥添加到 GitHub Settings → SSH Keys

# 使用 SSH 远程
git remote set-url origin git@github.com:your-username/uv.git
```

---

### 9. 工作流日志无法查看

**解决方案：**
1. 进入仓库首页
2. 点击 "Actions" 选项卡
3. 左侧选择工作流名称
4. 选择最近的运行
5. 点击具体的 job 查看日志

**如果日志被截断：**
- 工作流输出超过 GitHub 限制（每个 step 64KB）
- 查看原始日志：点击 "Download logs"

---

### 10. 修复后验证配置

**完整验证流程：**

```bash
# 1. 检查 git 配置
git config --list | grep pull

# 2. 检查远程配置
git remote -v

# 3. 测试同步脚本
bash scripts/sync-upstream.sh

# 4. 检查工作流
ls -la .github/workflows/

# 5. 验证脚本
ls -la scripts/

# 6. 查看最近提交
git log --oneline -5
```

---

## 获取帮助

如果问题仍未解决：

1. 📖 查看完整指南：`FORK_SETUP_GUIDE.md`
2. 🔍 搜索 GitHub Issues
3. 💬 查看官方文档：https://docs.astral.sh/uv
4. 🤝 联系官方社区：https://discord.gg/astral-sh

---

## 额外资源

- **Sync 脚本：** `scripts/sync-upstream.sh`
- **初始化脚本：** `scripts/init-git-config.sh`
- **配置指南：** `FORK_SETUP_GUIDE.md`
- **官方仓库：** https://github.com/astral-sh/uv
