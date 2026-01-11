#!/usr/bin/env bash
# 初始化 git 配置以支持同步脚本

set -e

echo "=== 配置 Git 同步设置 ==="
echo ""

# 检查是否已配置
if git config --get pull.ff &>/dev/null; then
  current_config=$(git config --get pull.ff)
  echo "✅ pull.ff 已配置为: $current_config"
else
  echo "⚙️  配置 pull.ff 为 false (允许非快进合并)..."
  git config pull.ff false
  echo "✅ 已配置"
fi

# 可选：配置全局设置
read -p "是否配置全局 git 设置？(y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "⚙️  配置全局 pull.ff..."
  git config --global pull.ff false
  echo "✅ 全局配置完成"
fi

echo ""
echo "=== 配置完成 ==="
echo ""
echo "现在可以运行: bash scripts/sync-upstream.sh"
