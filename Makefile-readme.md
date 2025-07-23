# 🤔 为什么需要这套工具？

在日常的代码开发中，你是不是碰到过以下的场景？

1. **打开一个工程后，虽然只修改了一点点，但是却被IDE格式化工具修改了一大堆，CR的时候被吐槽。**
2. **维护代码的时候，碰到一些多层循环嵌套的函数或方法，逻辑复杂到你内心问候之前的作者无数次。**
3. **想捞一下某个需求的代码看看，发现一堆的乱七八糟分支名，完全找不到你想要的。**
4. **吭哧吭哧写完了代码，提交后跑CI，静测一堆的报错，还被别人吐槽这家伙的代码不行。**

仔细想想，我们的代码为什么会有类似的问题呢？

其实问题的根源不复杂：
- **没有统一的规则；**
- **有规则但没人执行；**
- **有人执行但靠自觉；**
- **靠自觉就注定不靠谱。**

试想一下，有没有什么轻量级的方法，让我在commit之前能够非常快的，跑完所有的格式化、lint检查、静态分析、格式检查、复杂度分析，甚至判断你是不是没规范地起分支名以及你的commit-msg是否合法。

本文介绍了一种**基于makefile执行本地ci/cd的方法**，让你更方面的落地管理要求，提升基础的代码质量。当然看标题这是第一期，后续还会有其他内容。

---

# 📖 Make 工具简介

## 什么是 Make？

**Make** 是一个强大的构建自动化工具，最初由 Stuart Feldman 在 1976 年开发。它通过读取 `Makefile` 文件中的规则来自动化各种任务，如编译代码、运行测试、部署应用等。

## 核心概念

- **目标 (Target)**: 你想要执行的任务名称
- **依赖 (Dependencies)**: 执行目标前需要完成的前置条件
- **命令 (Commands)**: 实际执行的操作
- **规则 (Rules)**: 目标、依赖和命令的组合

## 基本语法

```makefile
目标: 依赖1 依赖2
	命令1
	命令2
```

## 使用方式

```bash
# 执行默认目标
make

# 执行指定目标
make <目标名称>

# 查看所有可用目标
make help
```

---

# 🚀 本项目 Makefile 使用指南

本项目的 Makefile 为 Go 语言 TTS 项目提供了完整的开发工具链，包含代码格式化、质量检查、Git 管理和分支规范等功能。

# 📋 命令分类索引

## 🛠️ 环境设置
- `make dev-setup` - 一键设置完整开发环境（推荐首次使用）
- `make install-tools` - 安装所有格式化和检查工具
- `make check-tools` - 检查工具是否正确安装

## 🎨 代码格式化
- `make fmt` - 完整代码格式化（推荐）
- `make fmt-gofmt` - 使用 go fmt 格式化
- `make fmt-goimports` - 整理导入并格式化
- `make fmt-gofumpt` - 严格格式化
- `make fmt-golines` - 限制行长度
- `make fmt-check` - 检查格式是否符合标准

## 🔍 代码质量检查
- `make check` - 运行所有质量检查（推荐）
- `make check-gocyclo` - 检查代码复杂度
- `make check-staticcheck` - 静态分析检查
- `make check-golangci-lint` - 综合代码检查
- `make explain-staticcheck code=XXX` - 解释错误代码

## 🪝 Git Hooks 管理
### 安装命令
- `make hooks-install` - 安装完整 hooks（推荐）
- `make hooks-install-basic` - 安装基础 hooks（轻量）
- `make hooks-check-all` - 仅 pre-commit（全量检查）
- `make hooks-fmt` - 仅 pre-commit（格式化）
- `make hooks-commit-msg` - 仅 commit-msg 验证

### 卸载命令
- `make hooks-uninstall` - 卸载所有 hooks
- `make hooks-uninstall-pre` - 卸载 pre-commit hook
- `make hooks-uninstall-msg` - 卸载 commit-msg hook

## 🌿 分支管理
- `make branch-setup` - 设置分支管理策略
- `make new-feature name=功能名` - 创建功能分支
- `make new-hotfix name=修复名` - 创建热修复分支
- `make clean-branches` - 清理已合并分支
- `make check-branch` - 检查分支命名规范
- `make safe-push` - 安全推送分支
- `make list-remote-branches` - 列出远程分支
- `make branch-help` - 分支管理帮助

## ℹ️ 信息查询
- `make help` - 显示所有可用命令
- `make info` - 显示项目信息

---

# 🎯 常用场景和使用示例

## 场景 1: 新团队成员环境设置

```bash
# 一键设置完整开发环境
make dev-setup
```

这个命令会：
- 安装所有格式化和检查工具
- 配置 Git hooks（pre-commit + commit-msg）
- 设置分支管理策略
- 显示所有可用命令说明

## 场景 2: 日常开发流程

```bash
# 开发前：格式化代码
make fmt

# 提交前：检查代码质量
make check

# 创建功能分支
make new-feature name=user-auth

# 安全推送
make safe-push
```

## 场景 3: 代码审查前检查

```bash
# 完整的质量检查
make check

# 如果有 staticcheck 错误，查看详细说明
make explain-staticcheck code=ST1008

# 检查分支命名是否规范
make check-branch
```

## 场景 4: Git Hooks 管理

```bash
# 安装完整的 Git hooks（推荐）
make hooks-install

# 如果觉得检查太严格，可以使用轻量版本
make hooks-install-basic

# 临时禁用所有 hooks
make hooks-uninstall

# 重新启用
make hooks-install
```

## 场景 5: 分支管理

```bash
# 创建新功能分支
make new-feature name=payment-integration

# 创建热修复分支  
make new-hotfix name=critical-bug-fix

# 清理已合并的分支
make clean-branches

# 查看远程分支
make list-remote-branches
```

---

# ⚙️ 详细命令说明

## 环境设置命令

### `make dev-setup`
**功能**: 一键设置完整的开发环境  
**执行内容**:
- 安装格式化工具: goimports, gofumpt, golines
- 安装检查工具: gocyclo, staticcheck, golangci-lint  
- 安装完整的 Git hooks
- 配置分支管理策略

### `make install-tools`
**功能**: 安装所有代码格式化和质量检查工具  
**安装的工具**:
- `goimports` - 导入整理和格式化
- `gofumpt` - 严格的代码格式化
- `golines` - 行长度限制
- `gocyclo` - 圈复杂度检查
- `staticcheck@2025.1.1` - 静态分析
- `golangci-lint@v2.3.0` - 综合代码检查

## 代码格式化命令

### `make fmt`
**功能**: 运行所有格式化工具  
**执行顺序**:
1. `go fmt` - 基础格式化
2. `goimports` - 整理导入
3. `gofumpt` - 严格格式化  
4. `golines -m 120` - 限制行长度为120字符

### `make fmt-check`
**功能**: 检查代码格式是否符合标准（不修改文件）  
**用途**: CI/CD 环境或提交前验证

## 代码质量检查命令

### `make check` / `make check-all`
**功能**: 运行所有代码质量检查  
**检查项目**:
1. 代码格式验证
2. 圈复杂度检查（阈值: 10）
3. 静态分析检查
4. golangci-lint 综合检查

### `make check-gocyclo`
**功能**: 检查代码圈复杂度  
**阈值**: 10（函数复杂度超过10会报错）  
**用途**: 识别过于复杂的函数，提醒重构

### `make explain-staticcheck code=XXX`
**功能**: 解释 staticcheck 错误代码  
**示例**: `make explain-staticcheck code=ST1008`  
**用途**: 理解静态分析工具的具体错误含义

## Git Hooks 详解

### Pre-commit Hooks

**完整模式 (`hooks-check-all`)**:
- 自动格式化代码
- 检查圈复杂度
- 运行静态分析
- 执行 golangci-lint
- 所有检查通过才允许提交

**轻量模式 (`hooks-fmt`)**:
- 仅自动格式化代码
- 快速提交，减少等待时间
- 适合频繁提交的开发模式

### Commit-msg Hook (`hooks-commit-msg`)

**验证规则**: 遵循 Conventional Commits 规范  
**支持的类型**:
- `feat` - 新功能
- `fix` - 修复 bug
- `docs` - 文档更新
- `style` - 代码格式化
- `refactor` - 重构
- `test` - 测试相关
- `chore` - 构建/工具更新

**格式要求**:
```
<type>(<scope>): <description>

# 示例
feat: 添加用户认证功能
fix(auth): 修复登录验证问题  
docs: 更新 API 文档
```

## 分支管理详解

### 分支命名规范
- `master` - 主分支
- `develop` - 开发分支  
- `feature-*` - 功能分支
- `hotfix-*` - 热修复分支

### `make new-feature name=功能名`
**功能**: 创建规范的功能分支  
**命名**: `feature-<name>`  
**示例**: `make new-feature name=user-auth` → `feature-user-auth`

### `make safe-push`  
**功能**: 安全推送分支到远程  
**检查项目**:
- 验证分支名是否符合规范
- 符合规范才允许推送
- 防止污染远程仓库

---

# 🎨 定制化配置

## 修改复杂度阈值

如果需要调整代码复杂度阈值，可以编辑 Makefile 中的 `check-gocyclo` 目标：

```makefile
# 当前设置: 阈值为 10
@$(GOCYCLO) -over 10 $(GOFILES)

# 修改为其他值，如 15
@$(GOCYCLO) -over 15 $(GOFILES)
```

## 修改行长度限制

调整 `golines` 的行长度限制：

```makefile
# 当前设置: 120 字符
@$(GOLINES) -w -m 120 $(GOFILES)

# 修改为 100 字符
@$(GOLINES) -w -m 100 $(GOFILES)
```

## 自定义 Commit 类型

编辑 `hooks-commit-msg` 目标中的正则表达式：

```makefile
# 添加新的 commit 类型，如 perf, ci
commit_regex="^(feat|fix|docs|style|refactor|test|chore|perf|ci)(\(.+\))?: .{1,50}"
```

---

# ❓ 常见问题解答

## Q: 工具安装失败怎么办？
**A**: 检查 Go 环境和网络连接，确保可以访问 `proxy.golang.org`。可以设置 Go 代理：
```bash
go env -w GOPROXY=https://goproxy.cn,direct
make install-tools
```

## Q: Git hooks 太严格，影响开发效率？
**A**: 可以使用轻量版本或临时禁用：
```bash
# 使用轻量版本（仅格式化）
make hooks-install-basic

# 临时禁用所有 hooks
make hooks-uninstall
```

## Q: 如何跳过某次 commit 的 hook 检查？
**A**: 使用 `--no-verify` 参数：
```bash
git commit --no-verify -m "emergency fix"
```

## Q: staticcheck 报错看不懂？
**A**: 使用解释命令：
```bash
make explain-staticcheck code=ST1008
```

## Q: 代码复杂度检查失败？
**A**: 
1. 查看具体哪个函数复杂度过高
2. 考虑重构，拆分复杂函数
3. 临时调整阈值（不推荐）

---

# 🔧 故障排除

## 工具检查失败
```bash
# 检查哪些工具缺失
make check-tools

# 重新安装
make install-tools
```

## Git hooks 不工作
```bash
# 检查 hooks 文件权限
ls -la .git/hooks/

# 重新安装 hooks
make hooks-install
```

## 分支管理命令失败
```bash
# 重新设置分支管理
make branch-setup

# 检查辅助脚本是否存在
ls -la .git/git-branch-helpers.sh
```

---

# 📚 参考资源

- [Go 官方文档](https://golang.org/doc/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [golangci-lint 配置](https://golangci-lint.run/usage/configuration/)
- [Make 官方手册](https://www.gnu.org/software/make/manual/)

---

# 🤝 贡献指南

如果您想改进这个 Makefile 或添加新功能：

1. 遵循现有的命名规范
2. 为新命令添加帮助说明
3. 更新这份使用手册
4. 确保向后兼容性

---

# 📦 代码仓库

项目源码托管地址：[https://code.iflytek.com/osc/_source/CBG_OpenSource/local-ci/-/tree/heads%2Fmaster](https://code.iflytek.com/osc/_source/CBG_OpenSource/local-ci/-/tree/heads%2Fmaster)

欢迎访问仓库：
- 🔍 查看最新代码
- 📝 提交Issue和建议  
- 🤝 参与项目贡献
- 📚 获取更新和发布信息

---

*本手册最后更新于 2025年*