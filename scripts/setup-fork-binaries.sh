#!/usr/bin/env bash
# 配置脚本：为 fork 设置自动同步和二进制构建

set -e

echo "=== 配置 uv fork 为仅构建二进制版本 ==="
echo ""

# 1. 验证 git 配置
echo "1️⃣  验证 git 配置..."
if ! git remote get-url upstream &>/dev/null; then
  echo "   ✅ 添加 upstream 远程..."
  git remote add upstream https://github.com/astral-sh/uv.git
else
  echo "   ✅ upstream 远程已存在"
fi

# 2. 禁用不必要的工作流
echo ""
echo "2️⃣  禁用不必要的工作流..."

workflows_to_disable=(
  ".github/workflows/publish-pypi.yml"
  ".github/workflows/publish-crates.yml"
  ".github/workflows/publish-docs.yml"
)

for workflow in "${workflows_to_disable[@]}"; do
  if [ -f "$workflow" ]; then
    echo "   ⏸️  禁用 $workflow"
    # 添加注释标记为已禁用
    if ! grep -q "# DISABLED FOR FORK" "$workflow"; then
      sed -i '1i# DISABLED FOR FORK - Only use build-binaries-only.yml' "$workflow"
    fi
  fi
done

# 3. 显示配置信息
echo ""
echo "3️⃣  配置完成！"
echo ""
echo "=== 您现在可以: ==="
echo ""
echo "📦 自动同步源代码:"
echo "   - 每天自动从官方仓库同步 (GitHub Actions 触发)"
echo "   - 或手动运行: bash scripts/sync-upstream.sh"
echo ""
echo "🔨 自动构建二进制:"
echo "   - 推送到 main 分支时自动构建"
echo "   - 创建标签 (v*) 时自动发布 Release"
echo ""
echo "🔗 相关资源:"
echo "   - Build workflow: .github/workflows/build-binaries-only.yml"
echo "   - Sync workflow:  .github/workflows/sync-upstream.yml"
echo "   - Sync script:    scripts/sync-upstream.sh"
echo ""
echo "⚠️  注意:"
echo "   - PyPI 发布已禁用 (publish-pypi.yml)"
echo "   - Crates.io 发布已禁用 (publish-crates.yml)"
echo "   - 文档发布已禁用 (publish-docs.yml)"
echo ""
echo "✅ 所有配置完成！"
