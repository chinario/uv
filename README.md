# uv

[![uv](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/astral-sh/uv/main/assets/badge/v0.json)](https://github.com/astral-sh/uv)
[![image](https://img.shields.io/pypi/v/uv.svg)](https://pypi.python.org/pypi/uv)
[![image](https://img.shields.io/pypi/l/uv.svg)](https://pypi.python.org/pypi/uv)
[![image](https://img.sh.io/pypi/pyversions/uv.svg)](https://pypi.python.org/pypi/uv)
[![Actions status](https://github.com/astral-sh/uv/actions/workflows/ci.yml/badge.svg)](https://github.com/astral-sh/uv/actions)
[![Discord](https://img.shields.io/badge/Discord-%235865F2.svg?logo=discord&logoColor=white)](https://discord.gg/astral-sh)

**语言:** [简体中文](README.md) | [English](README.en.md)

一个极其快速的 Python 包和项目管理器，用 Rust 编写。

<p align="center">
  <picture align="center">
    <source media="(prefers-color-scheme: dark)" srcset="https://github.com/astral-sh/uv/assets/1309177/03aa9163-1c79-4a87-a31d-7a9311ed9310">
    <source media="(prefers-color-scheme: light)" srcset="https://github.com/astral-sh/uv/assets/1309177/629e59c0-9c6e-4013-9ad4-adb2bcf5080d">
    <img alt="Shows a bar chart with benchmark results." src="https://github.com/astral-sh/uv/assets/1309177/629e59c0-9c6e-4013-9ad4-adb2bcf5080d">
  </picture>
</p>

<p align="center">
  <i>使用预热缓存安装 <a href="https://trio.readthedocs.io/">Trio</a> 的依赖项。</i>
</p>

## Fork 信息

这是 [astral-sh/uv](https://github.com/astral-sh/uv) 的 fork，优化用于构建独立二进制文件，同时与上游保持同步。

### 🔄 自动同步

本 fork 会自动与官方 uv 仓库同步：

1. **自动日常同步**（GitHub Actions）
   - 每天 UTC 02:00 运行
   - 自动从 `astral-sh/uv` 拉取最新变化
   - 复杂合并时创建 PR 进行手动审查
   - 手动触发：进入 Actions → "Sync from Upstream" → 运行工作流

2. **手动同步**
   ```bash
   bash scripts/sync-upstream.sh
   ```

### 🔨 二进制构建系统

本 fork 专注于跨多个平台构建独立二进制文件：

- **触发方式：** 推送到 `main` 或创建版本标签 (`v*`)
- **平台支持：** Linux (x86_64、ARM64)、macOS (x86_64、ARM64)、Windows (x86_64)
- **输出内容：** GitHub Releases 中的预编译二进制文件
- **工作流：** `.github/workflows/build-binaries-only.yml`

### 📦 禁用的功能

为了保持本 fork 的轻量级并专注于二进制构建，以下功能已禁用：

- ❌ PyPI 包发布（`publish-pypi.yml`）
- ❌ Crates.io 发布（`publish-crates.yml`）
- ❌ 文档发布（`publish-docs.yml`）
- ❌ CI 测试（如需可重新启用）

### 🚀 快速设置

首次设置：
```bash
bash scripts/init-git-config.sh
bash scripts/setup-fork-binaries.sh
bash scripts/sync-upstream.sh
```

这将：
1. 配置 git 以正确处理合并
2. 配置 upstream 远程
3. 标记发布工作流为已禁用
4. 显示配置摘要

### 本地构建

```bash
# 构建发布二进制
cargo build --release --bin uv --bin uvx

# 二进制文件将在：target/release/
```

## 安装

使用我们的独立安装程序安装 uv：

```bash
# 在 macOS 和 Linux 上
curl -LsSf https://astral.sh/uv/install.sh | sh
```

```bash
# 在 Windows 上
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

或从 [PyPI](https://pypi.org/project/uv/) 安装：

```bash
# 使用 pip
pip install uv
```

```bash
# 或 pipx
pipx install uv
```

如果通过独立安装程序安装，uv 可以自我更新到最新版本：

```bash
uv self update
```

详见[安装文档](https://docs.astral.sh/uv/getting-started/installation/)了解详情和其他安装方法。

## 文档

uv 的文档可在 [docs.astral.sh/uv](https://docs.astral.sh/uv) 获得。

另外，命令行参考文档可通过 `uv help` 查看。

### Fork 特定文档

- [FORK_SETUP_GUIDE.md](FORK_SETUP_GUIDE.md) - 详细的设置和配置指南
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - 故障排除和常见问题
- [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - 常见任务的快速参考

## 功能特性

### 项目管理

uv 管理项目依赖和环境，支持锁文件、工作区等功能，类似于 `rye` 或 `poetry`：

```console
$ uv init example
Initialized project `example` at `/home/user/example`

$ cd example

$ uv add ruff
Creating virtual environment at: .venv
Resolved 2 packages in 170ms
   Built example @ file:///home/user/example
Prepared 2 packages in 627ms
Installed 2 packages in 1ms
 + example==0.1.0 (from file:///home/user/example)
 + ruff==0.5.0

$ uv run ruff check
All checks passed!

$ uv lock
Resolved 2 packages in 0.33ms

$ uv sync
Resolved 2 packages in 0.70ms
Audited 1 package in 0.02ms
```

详见[项目文档](https://docs.astral.sh/uv/guides/projects/)了解如何开始。

uv 也支持构建和发布项目，即使它们不是用 uv 管理的。详见[发布指南](https://docs.astral.sh/uv/guides/publish/)了解更多信息。

### 脚本

uv 管理单文件脚本的依赖和环境。

创建新脚本并添加内联元数据声明其依赖：

```console
$ echo 'import requests; print(requests.get("https://astral.sh"))' > example.py

$ uv add --script example.py requests
Updated `example.py`
```

然后在隔离的虚拟环境中运行脚本：

```console
$ uv run example.py
Reading inline script metadata from: example.py
Installed 5 packages in 12ms
 + pycowsay==0.0.0.2
<Response [200]>
```

详见[脚本文档](https://docs.astral.sh/uv/guides/scripts/)了解如何开始。

### 工具

uv 执行和安装 Python 包提供的命令行工具，类似于 `pipx`。

使用 `uvx` (是 `uv tool run` 的别名) 在临时环境中运行工具：

```console
$ uvx pycowsay 'hello world!'
Resolved 1 package in 167ms
Installed 1 package in 9ms
 + pycowsay==0.0.0.2
  """

  ------------
< hello world! >
  ------------
   \   ^__^
    \  (oo)\_______
       (__)\       )\/\
           ||----w |
           ||     ||
```

使用 `uv tool install` 安装工具：

```console
$ uv tool install ruff
Resolved 1 package in 6ms
Installed 1 package in 2ms
 + ruff==0.5.0
Installed 1 executable: ruff

$ ruff --version
ruff 0.5.0
```

详见[工具文档](https://docs.astral.sh/uv/guides/tools/)了解如何开始。

### Python 版本

uv 安装 Python 并允许在不同版本之间快速切换。

安装多个 Python 版本：

```console
$ uv python install 3.12 3.13 3.14
Installed 3 versions in 972ms
 + cpython-3.12.12-macos-aarch64-none (python3.12)
 + cpython-3.13.9-macos-aarch64-none (python3.13)
 + cpython-3.14.0-macos-aarch64-none (python3.14)

```

按需下载 Python 版本：

```console
$ uv venv --python 3.12.0
Using Python 3.12.0
Creating virtual environment at: .venv
Activate with: source .venv/bin/activate

$ uv run --python pypy@3.8 -- python --version
Python 3.8.16 (a9dbdca6fc3286b0addd2240f11d97d8e8de187a, Dec 29 2022, 11:45:30)
[PyPy 7.3.11 with GCC Apple LLVM 13.1.6 (clang-1316.0.21.2.5)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>>>
```

在当前目录使用特定的 Python 版本：

```console
$ uv python pin 3.11
Pinned `.python-version` to `3.11`
```

详见 [Python 安装文档](https://docs.astral.sh/uv/guides/install-python/)了解如何开始。

### pip 接口

uv 为常见的 `pip`、`pip-tools` 和 `virtualenv` 命令提供完全兼容的替代品。

uv 通过依赖版本覆盖、平台独立解析、可重现解析、替代解析策略等高级功能扩展了它们的接口。

使用 `uv pip` 接口在不改变现有工作流的情况下迁移到 uv——并体验 10-100 倍的速度提升。

将需求编译为平台独立的需求文件：

```console
$ uv pip compile docs/requirements.in \
   --universal \
   --output-file docs/requirements.txt
Resolved 43 packages in 12ms
```

创建虚拟环境：

```console
$ uv venv
Using Python 3.12.3
Creating virtual environment at: .venv
Activate with: source .venv/bin/activate
```

安装锁定的需求：

```console
$ uv pip sync docs/requirements.txt
Resolved 43 packages in 11ms
Installed 43 packages in 208ms
 + babel==2.15.0
 + black==24.4.2
 + certifi==2024.7.4
 ...
```

详见 [pip 接口文档](https://docs.astral.sh/uv/pip/index/)了解如何开始。

## 贡献

我们热衷于支持各种经验水平的贡献者，希望看到您参与项目。详见[贡献指南](https://github.com/astral-sh/uv?tab=contributing-ov-file#contributing)了解如何开始。

## 常见问题

#### uv 怎么发音？

发音为 "you - vee" ([`/juː viː/`](https://en.wikipedia.org/wiki/Help:IPA/English#Key))

#### uv 应该如何风格化？

仅为 "uv"。详见[风格指南](./STYLE.md#styling-uv)。

#### uv 支持哪些平台？

详见 uv 的[平台支持](https://docs.astral.sh/uv/reference/platforms/)文档。

#### uv 已经可用于生产吗？

是的，uv 是稳定的，被广泛用于生产。详见 uv 的[版本化政策](https://docs.astral.sh/uv/reference/versioning/)文档。

## 致谢

uv 的依赖解析器在底层使用 [PubGrub](https://github.com/pubgrub-rs/pubgrub)。我们感谢 PubGrub 的维护者，特别是 [Jacob Finkelman](https://github.com/Eh2406) 的支持。

uv 的 Git 实现基于 [Cargo](https://github.com/rust-lang/cargo)。

uv 的一些优化受到了 [pnpm](https://pnpm.io/)、[Orogene](https://github.com/orogene/orogene) 和 [Bun](https://github.com/oven-sh/bun) 的启发。我们也从 Nathaniel J. Smith 的 [Posy](https://github.com/njsmith/posy) 学到了很多，并为 Windows 支持改编了其[蹦床](https://github.com/njsmith/posy/tree/main/src/trampolines/windows-trampolines/posy-trampoline)。

## 许可证

uv 是在以下任一许可证下授权的

- Apache 许可证 2.0 版本 ([LICENSE-APACHE](LICENSE-APACHE) 或 <https://www.apache.org/licenses/LICENSE-2.0>)
- MIT 许可证 ([LICENSE-MIT](LICENSE-MIT) 或 <https://opensource.org/licenses/MIT>)

由您选择。

除非您明确说明，否则任何有意提交至 uv 的贡献，如 Apache-2.0 许可证定义，应以上述方式双重许可，不带任何附加条款或条件。

<div align="center">
  <a target="_blank" href="https://astral.sh" style="background:none">
    <img src="https://raw.githubusercontent.com/astral-sh/uv/main/assets/svg/Astral.svg" alt="Made by Astral">
  </a>
</div>