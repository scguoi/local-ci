# 📋 贡献者分支管理指南

> 🎯 **面向贡献者**: 本文档专为想要为项目贡献代码的开发者编写

欢迎你想要为这个项目贡献代码！本指南将帮助你了解如何正确地创建分支、提交代码，以及与项目团队协作。

## 🚀 开始贡献前必读

### 为什么要遵循分支规范？
作为贡献者，遵循项目的分支规范可以：
- ✅ 让你的代码更容易被项目维护者理解和接受
- ✅ 避免你的Pull Request因为格式问题被拒绝
- ✅ 让整个项目保持整洁，方便所有贡献者协作
- ✅ 确保你的贡献能够顺利通过自动化检查

### 本项目使用的工作流程
我们使用 **GitHub Flow** - 这是一个简单、新手友好的工作流程：
- **一个主分支**: `main` 分支包含可以直接部署的代码
- **功能分支**: 每个新功能或修复都在单独的分支上开发
- **Pull Request**: 所有代码都通过PR提交，经过代码审查后合并

## 🏷️ 如何为你的贡献命名分支

### 第一次贡献？先了解主分支
- `main` - 这是项目的主分支，包含稳定的代码
- 你**不需要直接修改**主分支，只需要从它创建你的功能分支

### 为你的贡献选择合适的分支名

作为贡献者，你需要为你的工作创建一个描述性的分支名。格式很简单：`<类型>/<你要做什么>`

#### 常见的贡献类型和示例

| 你想做什么 | 使用类型 | 分支名示例 | 何时使用 |
|------------|----------|------------|----------|
| 添加新功能 | `feature` | `feature/add-user-login` | 当你要添加全新的功能时 |
| 修复Bug | `fix` | `fix/button-click-error` | 当你发现并修复了一个问题时 |
| 更新文档 | `docs` | `docs/improve-readme` | 当你要改进文档、说明时 |
| 重构代码 | `refactor` | `refactor/clean-database-code` | 当你要改进代码结构但不改变功能时 |
| 添加测试 | `test` | `test/add-login-tests` | 当你要为现有功能添加测试时 |

#### 简单描述性命名（推荐新手使用）
如果你觉得上面的格式太复杂，也可以用简单的描述：
- `add-dark-mode` - 添加暗色模式
- `fix-memory-leak` - 修复内存泄漏
- `update-dependencies` - 更新依赖

### ❌ 避免这些分支名（会被拒绝）
- `my_branch` - 包含下划线
- `temp` - 太模糊，看不出要做什么
- `fix` - 太泛泛，修复什么？
- `test branch` - 包含空格
- `dev` - 容易与开发分支混淆

## 🔄 贡献代码的完整流程

### 第一步：Fork 项目并克隆到本地

如果你是第一次贡献，需要先 Fork 这个项目：

1. 在 GitHub 上点击 "Fork" 按钮
2. 克隆你的 Fork 到本地：
```bash
git clone https://github.com/你的用户名/local-ci.git
cd local-ci
```

3. 添加原项目为上游仓库：
```bash
git remote add upstream https://github.com/原作者/local-ci.git
```

### 第二步：创建你的功能分支

```bash
# 确保你在主分支并获取最新代码
git checkout main
git pull upstream main

# 现在创建你的功能分支
# 如果项目有 Makefile 工具（推荐）：
make new-feature name=你的功能名

# 或者手动创建：
git checkout -b feature/你的功能名
```

**新手提示**：如果你不确定用什么名字，看看你要解决的问题或要添加的功能，用简单的英文描述即可。

### 第三步：开发你的功能

现在你可以开始编写代码了！

```bash
# 编写你的代码...
# 修改文件、添加功能、修复Bug等

# 在提交前，运行项目的格式化工具（这很重要！）
make fmt          # 自动格式化代码
make check        # 检查代码质量

# 如果上面的命令有错误，请先修复再继续

# 提交你的更改
git add .
git commit -m "feat: 添加用户登录功能"
```

**⚠️ 重要提示**：
- 本项目有自动化的代码检查，提交前务必运行 `make fmt` 和 `make check`
- 如果检查失败，你的 PR 可能会被拒绝
- 提交信息请使用项目要求的格式（见下文）

### 第四步：提交你的贡献

```bash
# 推送到你的 Fork
git push origin feature/你的功能名

# 如果项目提供了安全推送命令（推荐）：
make safe-push
```

然后：
1. 打开 GitHub，找到你的 Fork
2. 你会看到一个绿色的 "Compare & pull request" 按钮
3. 点击它，填写 PR 描述
4. 提交 Pull Request

**PR 描述建议**：
- 简单说明你做了什么
- 如果修复了 Bug，描述原来的问题
- 如果添加了功能，解释这个功能的用途

### 第五步：响应代码审查

项目维护者会审查你的代码，可能会：
- ✅ 直接接受你的 PR
- 💬 提出修改建议
- ❌ 要求你修复某些问题

**如果需要修改**：
```bash
# 在你的功能分支上继续修改
git checkout feature/你的功能名

# 修改代码...
# 再次运行检查
make fmt && make check

# 提交修改
git add .
git commit -m "fix: 根据审查意见修复问题"
git push origin feature/你的功能名
```

修改会自动更新到你的 PR 中。

### 第六步：PR 被接受后

恭喜！你的代码被合并了。现在可以清理本地分支：

```bash
# 切换回主分支
git checkout main
git pull upstream main

# 删除你的功能分支
git branch -d feature/你的功能名
```

## 🛠️ 项目提供的快捷命令（可选）

本项目可能提供了一些 Makefile 命令来简化你的贡献流程。你可以用 `make help` 查看所有可用命令。

### 对贡献者有用的命令

#### 创建分支（推荐新手使用）
```bash
# 一键创建功能分支
make new-feature name=你的功能名

# 创建修复分支
make new-fix name=你要修复的问题

# 高级用法（如果你熟悉流程）
make new-branch type=feature name=具体功能名
```

#### 代码质量检查（非常重要！）
```bash
make fmt         # 自动格式化你的代码
make check       # 检查代码是否符合项目标准
make fmt-check   # 检查格式但不修改文件
```

#### 安全推送
```bash
make check-branch  # 检查你的分支名是否符合规范
make safe-push     # 检查后安全推送
```

### 如果没有 Makefile 命令怎么办？

如果项目没有这些命令，也没关系！你可以手动操作：

```bash
# 手动创建分支
git checkout -b feature/你的功能名

# 手动推送
git push origin feature/你的功能名
```

### 高级PR管理命令（可选）

> ⚠️ **警告**: 这些命令仅适用于有仓库写权限的高级用户，详见 `ADVANCED-PR-SETUP.md`

```bash
make push-and-pr      # 推送分支并创建PR
make pr-status        # 查看当前分支PR状态
make pr-list          # 列出所有开放的PR
make pr-merge         # 合并当前分支的PR
make switch-to-main   # 切换到主分支并拉取最新代码
```

## 📏 分支命名检查

系统会自动检查分支名是否符合规范：

### ✅ 符合规范的分支名
```
✅ main
✅ master
✅ feature/user-authentication
✅ fix/login-bug
✅ docs/api-guide
✅ refactor/cleanup-code
✅ test/unit-coverage
✅ add-logging
✅ improve-performance
```

### ❌ 不符合规范的分支名
```
❌ my_branch          # 下划线
❌ feature-name       # 连字符分隔类型和名称
❌ temp               # 不明确的临时分支
❌ fix                # 类型太泛泛
❌ user auth          # 包含空格
```

## 🚫 Git Hooks 自动检查

系统配置了以下自动检查：

### Pre-push Hook
推送前自动检查：
- 分支命名规范
- 如果不符合规范会提示建议的分支名
- 阻止不规范的分支推送

### Pre-commit Hook
提交前自动执行：
- 代码格式化 (`make fmt`)
- 代码质量检查 (`make check`)
- 自动添加格式化后的文件

### Commit-msg Hook
提交信息格式检查：
- 遵循 Conventional Commits 规范
- 格式: `<type>(<scope>): <description>`
- 类型: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

## 💡 最佳实践

### ✅ 推荐做法

1. **保持分支小而专注**
   - 每个分支只做一件事
   - 避免大型、长期存在的分支

2. **及时合并和删除**
   - 功能完成后立即创建PR
   - 合并后立即删除分支

3. **使用描述性名称**
   ```bash
   # 好的例子
   feature/oauth2-integration
   fix/null-pointer-exception
   docs/deployment-guide
   
   # 不好的例子
   feature/stuff
   fix/bug
   docs/update
   ```

4. **定期同步主分支**
   ```bash
   git checkout main
   git pull origin main
   git checkout feature/my-feature
   git merge main  # 或 git rebase main
   ```

5. **遵循提交信息规范**
   ```bash
   # 好的提交信息
   feat: add user authentication system
   fix(auth): resolve token validation issue
   docs: update API documentation
   
   # 不好的提交信息
   update
   fix bug
   changes
   ```

### ❌ 避免的做法

1. **不要直接推送到主分支**
   - 始终通过PR合并代码
   - 主分支应该受到保护

2. **不要创建长期分支**
   - 避免类似 `develop` 的长期分支
   - 功能分支应该短期存在

3. **不要忽略命名规范**
   - 系统会阻止不规范的分支名推送
   - 遵循团队约定的命名格式

4. **不要跳过代码审查**
   - 所有代码变更都应该经过PR审查
   - 即使是小的修改也要经过流程

## 🔧 配置说明

### 自动化设置
运行以下命令来配置完整的开发环境：

```bash
make dev-setup
```

这个命令会：
- 安装所有语言的开发工具
- 配置Git hooks
- 设置分支管理工具

### 自定义配置
如果需要修改分支命名规范，请编辑：
- `makefiles/git.mk` - 分支检查逻辑
- `.git/hooks/pre-push` - 推送前检查规则

## 🆘 常见问题

### Q: 分支名不符合规范怎么办？
```bash
# 重命名当前分支
git branch -m new-branch-name

# 或者基于当前分支创建新分支
make new-branch type=feature name=correct-name
```

### Q: 如何清理已合并的分支？
```bash
make clean-branches
```

### Q: 如何查看团队的远程分支？
```bash
make list-remote-branches
```

### Q: 提交被钩子阻止怎么办？
```bash
# 查看具体错误信息
make check

# 修复格式问题
make fmt

# 如果紧急需要跳过（不推荐）
git commit --no-verify
```

### Q: 如何禁用某个钩子？
```bash
# 卸载所有钩子
make hooks-uninstall

# 只卸载特定钩子
make hooks-uninstall-pre  # 卸载pre-commit
make hooks-uninstall-msg  # 卸载commit-msg
```

## 📖 相关文档

- `ADVANCED-PR-SETUP.md` - 高级PR管理功能设置指南
- `Makefile-readme.md` - 完整的Makefile命令文档
- `CLAUDE.md` - 项目架构和开发指南

## 🤝 团队协作建议

1. **新成员入职**
   - 确保理解GitHub Flow概念
   - 练习使用Makefile命令
   - 熟悉分支命名规范

2. **代码审查**
   - 关注分支命名是否合理
   - 检查提交信息质量
   - 确保遵循最佳实践

3. **持续改进**
   - 定期回顾分支管理效果
   - 根据团队需求调整规范
   - 分享经验和最佳实践

---

📝 **文档版本**: v1.0  
📅 **最后更新**: 2024年  
👥 **维护团队**: 开发团队