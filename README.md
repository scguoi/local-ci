# Local CI - 多语言本地持续集成工具

> 🚀 企业级多语言本地CI/CD解决方案，支持Go、TypeScript、Java、Python四大主流技术栈

## 📖 项目简介

Local CI 是一个基于模块化 Makefile 的本地持续集成工具链，**支持 Go、TypeScript、Java (Maven)、Python 四种编程语言**。它通过统一的代码格式化、质量检查、Git 钩子管理和分支规范，帮助多技术栈团队在提交代码前就发现和解决问题，大幅提升代码质量和开发效率。

### 🎯 解决的问题

- ❌ **多技术栈格式不统一**：Go、TypeScript、Java、Python各自的格式化标准冲突
- ❌ **质量检查工具分散**：每种语言都需要单独配置静态分析工具
- ❌ **跨语言项目管理混乱**：微服务架构中多语言项目缺乏统一的CI/CD流程
- ❌ **开发环境配置复杂**：新成员需要分别安装配置各语言的开发工具

### ✅ 提供的解决方案

- ✅ **统一的多语言格式化**：Go (gofmt/goimports/gofumpt)、TypeScript (Prettier)、Java (Spotless)、Python (black/isort)
- ✅ **全面的质量检查矩阵**：静态分析、类型检查、代码规范、复杂度分析覆盖所有语言
- ✅ **一致的分支管理策略**：GitHub Flow工作流，支持多语言混合项目
- ✅ **零配置开发环境**：一条命令完成所有语言工具安装和Git钩子配置

## 🏗️ 项目架构

```
local-ci/
├── Makefile                 # 主Makefile入口，聚合所有语言模块
├── makefiles/               # 模块化Makefile目录
│   ├── common.mk            # 通用变量和函数
│   ├── go.mk                # Go语言工具链
│   ├── typescript.mk        # TypeScript工具链  
│   ├── java.mk              # Java工具链
│   ├── python.mk            # Python工具链
│   └── git.mk               # Git管理和钩子
├── backend-go/              # Go后端示例项目
│   ├── main.go              # HTTP服务器(端口8080)
│   └── go.mod               # Go模块配置
├── frontend-ts/             # TypeScript前端示例项目
│   ├── src/                 # TypeScript源码
│   ├── package.json         # npm配置
│   └── tsconfig.json        # TypeScript配置
├── backend-java/            # Java后端示例项目(Maven)
│   ├── pom.xml              # Maven配置
│   └── src/main/java/       # Java源码
├── backend-python/          # Python后端示例项目
│   ├── main.py              # Python应用入口
│   └── requirements.txt     # Python依赖
└── README.md                # 项目文档（本文件）
```

## 🚀 快速开始

### 1. 环境要求

#### 必需工具
- **Git** - 版本控制
- **Make** - 构建工具 
- **网络连接** - 用于下载各语言开发工具

#### 支持的语言环境（根据项目需要安装）
- **Go** 1.24.4+ - 用于Go项目开发
- **Node.js** 18+ - 用于TypeScript项目开发
- **Java** 17+ & **Maven** 3.8+ - 用于Java项目开发  
- **Python** 3.9+ - 用于Python项目开发

### 2. 一键设置开发环境

```bash
# 克隆仓库
git clone <repository-url>
cd local-ci

# 一键设置完整开发环境（自动检测已安装的语言）
make dev-setup
```

这个命令会自动：
- 🔍 **检测已安装的语言环境**（Go/TypeScript/Java/Python）
- 📦 **安装对应语言的开发工具**（格式化器、静态分析器、代码检查器）
- 🪝 **配置统一的Git hooks**（pre-commit + commit-msg + pre-push）
- 🌿 **设置分支管理策略**
- 📊 **显示项目状态和可用命令**

### 3. 验证安装结果

```bash
# 查看检测到的项目和已安装的工具
make project-status
make check-tools

# 示例输出：
# ✓ Go Backend       (backend-go/)
# ✓ TypeScript Frontend (frontend-ts/)  
# ✓ Java Backend      (backend-java/)
# ✓ Python Backend    (backend-python/)
```

### 4. 启动示例服务（可选）

```bash
# Go HTTP服务器
cd backend-go && go run main.go
# 访问 http://localhost:8080

# TypeScript应用
cd frontend-ts && npm run dev

# Java应用  
cd backend-java && mvn exec:java

# Python应用
cd backend-python && python main.py
```

## 🛠️ 核心功能

### 🎨 统一代码格式化
```bash
# 格式化所有检测到的项目
make fmt                    # 自动格式化所有语言代码
make fmt-check              # 检查格式是否符合标准（不修改）

# 分语言格式化
make fmt-go                 # Go: gofmt + goimports + gofumpt + golines
make fmt-typescript         # TypeScript: prettier + import organization  
make fmt-java               # Java: maven spotless
make fmt-python             # Python: black + isort
```

### 🔍 全面代码质量检查
```bash
# 检查所有检测到的项目
make check                  # 运行所有质量检查
make check-tools           # 验证开发工具安装状态

# Go质量检查
make check-go              # Go项目完整检查
make check-gocyclo         # 圈复杂度检查（阈值：10）
make check-staticcheck     # 静态分析检查
make check-golangci-lint   # 综合lint检查

# TypeScript质量检查  
make check-typescript      # TypeScript项目完整检查
make check-eslint-typescript   # ESLint语法和风格检查
make check-tsc-typescript      # TypeScript类型检查

# Java质量检查
make check-java            # Java项目完整检查（含阿里巴巴P3C规范）
make check-checkstyle-java # Checkstyle代码风格检查
make check-pmd-java        # **阿里巴巴P3C代码质量检查**
make check-spotbugs-java   # SpotBugs静态分析

# Python质量检查
make check-python          # Python项目完整检查
make check-pylint-python   # pylint静态分析
make check-mypy-python     # mypy类型检查
```

### 🪝 Git钩子管理
```bash
make hooks-install         # 安装完整钩子（推荐，格式化+质量检查）
make hooks-install-basic   # 安装基础钩子（仅格式化，轻量级）
make hooks-uninstall       # 卸载所有钩子
```

### 🌿 分支管理（GitHub Flow）
```bash
make new-feature name=user-auth     # 创建feature/user-auth分支
make new-fix name=login-bug         # 创建fix/login-bug分支  
make check-branch                   # 检查分支命名规范
make safe-push                      # 验证分支名后安全推送
```

## 📋 命令快速索引

### 🚀 环境管理
| 命令 | 描述 |
|------|------|
| `make dev-setup` | 一键设置多语言开发环境 |
| `make install-tools` | 安装所有语言开发工具 |
| `make check-tools` | 检查工具安装状态 |
| `make project-status` | 显示检测到的项目 |

### 🎨 代码格式化
| 命令 | 描述 |
|------|------|
| `make fmt` | 格式化所有语言代码 |
| `make fmt-check` | 检查格式（不修改） |
| `make fmt-go` / `fmt-typescript` / `fmt-java` / `fmt-python` | 分语言格式化 |

### 🔍 质量检查
| 命令 | 描述 |
|------|------|
| `make check` | 运行所有质量检查 |
| `make check-go` / `check-typescript` / `check-java` / `check-python` | 分语言检查 |

### 🪝 Git管理
| 命令 | 描述 |
|------|------|
| `make hooks-install` | 安装完整Git钩子 |
| `make hooks-install-basic` | 安装轻量级钩子 |
| `make new-feature name=xxx` | 创建功能分支 |
| `make safe-push` | 安全推送分支 |

### ℹ️ 帮助信息
| 命令 | 描述 |
|------|------|
| `make help` | 显示所有可用命令 |
| `make branch-help` | 分支管理帮助 |

> 📚 **详细文档**：
> - [Makefile 命令文档](./Makefile-readme.md) - 完整命令说明和使用示例
> - [贡献者分支管理指南](./BRANCH-MANAGEMENT-ZH.md) - 面向贡献者的 GitHub Flow 工作流指南
> - [Contributor's Branch Management Guide](./BRANCH-MANAGEMENT-EN.md) - English guide for contributors

## 🔧 多语言开发工具链

### 🐹 Go 工具链
| 工具 | 版本 | 用途 |
|------|------|------|
| **goimports** | latest | 导入整理和代码格式化 |
| **gofumpt** | latest | 严格的代码格式化 |
| **golines** | latest | 行长度限制（120字符） |
| **gocyclo** | latest | 圈复杂度检查（阈值：10） |
| **staticcheck** | 2025.1.1 | 静态分析和错误检测 |
| **golangci-lint** | v2.3.0 | 综合代码质量检查 |

### 📜 TypeScript 工具链
| 工具 | 版本 | 用途 |
|------|------|------|
| **prettier** | latest | 代码格式化 |
| **eslint** | latest | 语法和风格检查 |
| **typescript** | latest | 类型检查和编译 |

### ☕ Java 工具链  
| 工具 | 版本 | 用途 |
|------|------|------|
| **spotless** | maven-plugin | 代码格式化（Google Java Format） |
| **checkstyle** | maven-plugin | 代码风格检查 |
| **p3c-pmd** | 2.1.1 | **阿里巴巴P3C代码规范**（基于《阿里巴巴Java开发手册》） |
| **spotbugs** | maven-plugin | 静态分析和Bug检测 |
| **slf4j + logback** | latest | 标准日志框架（替代System.out） |

### 🐍 Python 工具链
| 工具 | 版本 | 用途 |
|------|------|------|
| **black** | latest | 代码格式化 |
| **isort** | latest | import语句排序 |
| **pylint** | latest | 静态分析和代码质量 |
| **mypy** | latest | 静态类型检查 |

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

## 🎯 典型使用场景

### 场景1：新成员加入多语言团队
```bash
# 一键配置完整多语言开发环境
make dev-setup

# 查看检测到的项目和安装的工具
make project-status
# 输出：✓ Go Backend ✓ TypeScript Frontend ✓ Java Backend ✓ Python Backend
```

### 场景2：跨语言日常开发
```bash
# 统一格式化所有语言代码
make fmt        # 自动格式化Go、TS、Java、Python代码

# 统一质量检查
make check      # 运行所有语言的静态分析、类型检查等

# Git提交（自动触发钩子检查）
git commit -m "feat: add multi-language user service"
```

### 场景3：微服务架构开发（多语言混合）
```bash
# 创建功能分支
make new-feature name=user-microservice

# 开发Go服务
cd backend-go && vim main.go
make fmt-go && make check-go

# 开发TypeScript前端
cd frontend-ts && vim src/app.ts  
make fmt-typescript && make check-typescript

# 开发Java服务
cd backend-java && vim src/main/java/App.java
make fmt-java && make check-java

# 统一检查所有项目后推送
make check && make safe-push
```

### 场景4：持续集成前的本地验证
```bash
# 全面质量检查（模拟CI环境）
make check-all     # 检查所有语言项目

# 格式验证（确保CI不会因格式问题失败）
make fmt-check     # 验证所有代码格式正确
```

## 🚧 开发状态

### ✅ 已完成
- [x] **多语言工具链**：Go、TypeScript、Java、Python四种语言完整支持
- [x] **模块化架构**：基于模块化Makefile的可扩展设计
- [x] **统一格式化**：各语言最佳实践的格式化工具集成
- [x] **全面质量检查**：静态分析、类型检查、代码规范检查
- [x] **Git工作流管理**：统一的分支管理和钩子系统
- [x] **零配置环境**：一键安装所有开发工具
- [x] **完整文档体系**：多语言使用指南和最佳实践

### 🚧 开发中  
- [ ] **测试框架集成**：各语言单元测试、集成测试支持
- [ ] **覆盖率报告**：统一的测试覆盖率收集和展示
- [ ] **性能基准测试**：跨语言性能监控工具
- [ ] **容器化支持**：Docker多阶段构建模板

### 📋 计划中
- [ ] **CI/CD模板**：GitHub Actions、GitLab CI等模板
- [ ] **安全扫描**：依赖漏洞检查、静态安全分析
- [ ] **更多语言支持**：Rust、C++、PHP等语言扩展
- [ ] **IDE集成**：VSCode、IntelliJ等IDE插件
- [ ] **云原生支持**：Kubernetes、Helm等部署工具

## 🤝 贡献指南

我们欢迎为多语言CI/CD工具链做出贡献！

### 如何贡献

1. **Fork 仓库并克隆**
2. **设置开发环境**：`make dev-setup`
3. **创建功能分支**：`make new-feature name=your-feature`
4. **开发和测试**：
   - 添加新语言支持：在`makefiles/`目录创建新的`.mk`文件
   - 修改现有功能：确保向后兼容
   - 运行质量检查：`make check`
5. **提交和推送**：`make safe-push`
6. **创建 Pull Request**

### 多语言代码规范

- **Go**：遵循官方规范，通过`gofumpt`和`golangci-lint`
- **TypeScript**：使用Prettier格式化，ESLint规则检查
- **Java**：Google Java Format，**阿里巴巴P3C代码规范**，Checkstyle规则
- **Python**：Black格式化，pylint和mypy类型检查
- **提交信息**：遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范

### 扩展新语言支持

添加新语言支持的步骤：
1. 在`makefiles/`创建`{language}.mk`文件
2. 在主Makefile中include新模块
3. 实现格式化、质量检查、工具安装等标准目标
4. 添加项目检测逻辑到`common.mk`
5. 更新文档和示例

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

## 🤝 社区行为准则

我们致力于营造一个开放、友好、多元化、包容的社区环境。请阅读我们的 [行为准则](./.github/code_of_conduct.md) 了解社区标准和价值观。

## 🙋‍♂️ 联系我们

如果您有任何问题或建议，请：

- 创建 [Issue](../../issues)
- 提交 [Pull Request](../../pulls)
- 查看 [Wiki](../../wiki) 获取更多信息

---

**🎯 让本地CI成为您开发流程中的得力助手！**