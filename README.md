# Local CI - 本地持续集成工具

> 🚀 轻量级本地CI/CD解决方案，提升代码质量和开发效率

## 📖 项目简介

Local CI 是一个基于 Makefile 的本地持续集成工具，专为 Go 项目设计。它通过自动化的代码格式化、质量检查、Git 钩子管理和分支规范，帮助开发团队在提交代码前就发现和解决问题，避免在远程 CI 环境中浪费时间。

### 🎯 解决的问题

- ❌ **代码格式不统一**：IDE 格式化差异导致 CR 时被吐槽
- ❌ **代码质量参差不齐**：复杂度过高、静态分析报错
- ❌ **分支命名混乱**：找不到对应功能的分支
- ❌ **CI 反馈周期长**：提交后才发现格式或质量问题

### ✅ 提供的解决方案

- ✅ **统一的代码格式化**：自动应用 gofmt、goimports、gofumpt 等工具
- ✅ **全面的质量检查**：圈复杂度、静态分析、综合 lint 检查
- ✅ **规范的分支管理**：强制分支命名规范，支持功能分支创建
- ✅ **自动化的 Git 钩子**：提交前自动格式化和质量检查

## 🏗️ 项目架构

```
local-ci/
├── main.go              # HTTP 服务器示例（端口 8080）
├── go.mod               # Go 模块配置
├── Makefile             # 核心构建和 CI 工具
├── Makefile-readme.md   # Makefile 详细使用文档
├── .gitignore           # Git 忽略配置
└── README.md            # 项目文档（本文件）
```

## 🚀 快速开始

### 1. 环境要求

- Go 1.24.4 或更高版本
- Git
- Make 工具
- 网络连接（用于下载 Go 工具）

### 2. 一键设置开发环境

```bash
# 克隆仓库
git clone <repository-url>
cd local-ci

# 一键设置完整开发环境
make dev-setup
```

这个命令会自动：
- 📦 安装所有代码格式化和检查工具
- 🪝 配置 Git hooks（pre-commit + commit-msg + pre-push）
- 🌿 设置分支管理策略
- 📚 显示所有可用命令

### 3. 启动示例服务

```bash
# 启动 HTTP 服务器
go run main.go

# 访问 http://localhost:8080 查看 "Hello World"
```

## 🛠️ 核心功能

### 代码格式化
```bash
make fmt          # 完整格式化（推荐）
make fmt-check    # 检查格式是否符合标准
```

### 代码质量检查
```bash
make check        # 运行所有质量检查
make check-gocyclo            # 检查圈复杂度
make check-staticcheck        # 静态分析
make check-golangci-lint      # 综合检查
```

### Git 钩子管理
```bash
make hooks-install       # 安装完整钩子（推荐）
make hooks-install-basic # 安装基础钩子（轻量）
make hooks-uninstall     # 卸载所有钩子
```

### 分支管理
```bash
# GitHub Flow 分支管理
make new-branch type=feature name=user-auth  # 创建 feature/user-auth 分支
make new-feature name=user-auth              # 快捷创建功能分支
make new-fix name=login-bug                  # 创建 fix/login-bug 分支
make check-branch                            # 检查分支命名规范
make safe-push                               # 安全推送分支
```

## 📋 完整命令列表

| 类别 | 命令 | 描述 |
|------|------|------|
| **环境设置** | `make dev-setup` | 一键设置开发环境 |
| | `make install-tools` | 安装格式化和检查工具 |
| | `make check-tools` | 检查工具安装状态 |
| **代码格式化** | `make fmt` | 完整代码格式化 |
| | `make fmt-check` | 检查代码格式 |
| **质量检查** | `make check` | 运行所有质量检查 |
| | `make check-gocyclo` | 检查圈复杂度 |
| | `make check-staticcheck` | 静态分析检查 |
| **Git 管理** | `make hooks-install` | 安装Git钩子 |
| | `make new-feature name=xxx` | 创建功能分支 |
| | `make safe-push` | 安全推送分支 |
| **帮助信息** | `make help` | 显示所有可用命令 |
| | `make info` | 显示项目信息 |

> 📚 **详细文档**：
> - [Makefile 命令文档](./Makefile-readme.md) - 完整命令说明和使用示例
> - [贡献者分支管理指南](./BRANCH-MANAGEMENT-ZH.md) - 面向贡献者的 GitHub Flow 工作流指南
> - [Contributor's Branch Management Guide](./BRANCH-MANAGEMENT-EN.md) - English guide for contributors

## 🔧 开发工具链

### 已集成的工具

| 工具 | 版本 | 用途 |
|------|------|------|
| **goimports** | latest | 导入整理和代码格式化 |
| **gofumpt** | latest | 严格的代码格式化 |
| **golines** | latest | 行长度限制（120字符） |
| **gocyclo** | latest | 圈复杂度检查（阈值：10） |
| **staticcheck** | 2025.1.1 | 静态分析和错误检测 |
| **golangci-lint** | v2.3.0 | 综合代码质量检查 |

### Git 钩子

- **pre-commit**: 提交前自动格式化和质量检查
- **commit-msg**: 验证提交信息格式（Conventional Commits）
- **pre-push**: 验证分支命名规范

### 分支命名规范 (GitHub Flow)

- `main`/`master` - 主分支，始终可部署
- `feature/<name>` - 功能分支，如 `feature/user-auth`
- `fix/<name>` - Bug修复分支，如 `fix/login-error`
- `docs/<name>` - 文档分支，如 `docs/api-guide`
- `refactor/<name>` - 重构分支，如 `refactor/cleanup`
- `test/<name>` - 测试分支，如 `test/unit-coverage`

> 📋 **详细规范**：参阅 [分支管理规范文档](./BRANCH-MANAGEMENT-ZH.md) | [Branch Management Guide (EN)](./BRANCH-MANAGEMENT-EN.md)

## 🎯 使用场景

### 场景1：新成员入职
```bash
make dev-setup  # 一键配置开发环境
```

### 场景2：日常开发
```bash
make fmt        # 格式化代码
make check      # 检查代码质量
git commit      # 自动触发钩子检查
```

### 场景3：功能开发 (GitHub Flow)
```bash
make new-feature name=payment-system  # 创建 feature/payment-system 分支
# ... 开发代码 ...
make fmt && make check                 # 格式化和质量检查
make safe-push                         # 安全推送分支
# 在GitHub上创建Pull Request进行代码审查
```

### 场景4：代码审查前
```bash
make check      # 完整质量检查
make fmt-check  # 确认格式正确
```

## 🚧 开发状态

### ✅ 已完成
- [x] 基础 HTTP 服务器实现
- [x] 完整的 Makefile 工具链
- [x] Go 代码格式化工具集成
- [x] 代码质量检查工具
- [x] Git 钩子自动化
- [x] 分支管理和命名规范
- [x] 项目文档和使用指南

### 🚧 开发中
- [ ] 单元测试框架集成
- [ ] 测试覆盖率检查
- [ ] 性能基准测试
- [ ] Docker 容器化支持

### 📋 计划中
- [ ] CI/CD 管道模板
- [ ] 代码安全扫描
- [ ] 依赖漏洞检查
- [ ] 自动化部署脚本
- [ ] 多语言支持扩展

## 🤝 贡献指南

我们欢迎任何形式的贡献！

### 如何贡献

1. **Fork 仓库**
2. **创建功能分支**：`make new-feature name=your-feature`
3. **提交代码**：确保通过 `make check` 检查
4. **创建 Pull Request**

### 代码规范

- 遵循 Go 官方代码规范
- 提交信息遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范
- 所有代码必须通过质量检查
- 为新功能添加相应文档

### 提交信息格式

```
<type>(<scope>): <description>

# 示例
feat: add unit testing framework
fix(makefile): resolve pre-push hook issue
docs: update README with new features
```

## 📚 相关资源

### 项目文档
- [贡献者分支管理指南](./BRANCH-MANAGEMENT-ZH.md) - 为想要贡献代码的开发者提供的 GitHub Flow 工作流指南
- [Contributor's Branch Management Guide](./BRANCH-MANAGEMENT-EN.md) - English guide for developers who want to contribute
- [Makefile 命令文档](./Makefile-readme.md) - 详细的命令说明
- [高级PR管理设置](./ADVANCED-PR-SETUP.md) - 高级用户功能（仅限项目维护者）

### 外部资源
- [Go 官方文档](https://golang.org/doc/)
- [GitHub Flow 官方指南](https://docs.github.com/en/get-started/quickstart/github-flow)
- [Conventional Commits 规范](https://www.conventionalcommits.org/)
- [golangci-lint 配置指南](https://golangci-lint.run/)
- [Make 工具手册](https://www.gnu.org/software/make/manual/)

## 📄 许可证

本项目采用 [MIT 许可证](LICENSE)。

## 🙋‍♂️ 联系我们

如果您有任何问题或建议，请：

- 创建 [Issue](../../issues)
- 提交 [Pull Request](../../pulls)
- 查看 [Wiki](../../wiki) 获取更多信息

---

**🎯 让本地CI成为您开发流程中的得力助手！**