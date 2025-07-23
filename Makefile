# Makefile for Go code formatting and development tasks

# Go相关变量
GO := go
GOFILES := $(shell find . -name "*.go" -not -path "./vendor/*" -not -path "./.git/*")
GOMODULES := $(shell $(GO) list -m)

# 格式化工具
GOIMPORTS := goimports
GOFUMPT := gofumpt
GOLINES := golines

# 代码检查工具
GOCYCLO := gocyclo
STATICCHECK := staticcheck
GOLANGCI_LINT := golangci-lint

# 颜色输出
RED := \033[31m
GREEN := \033[32m
YELLOW := \033[33m
BLUE := \033[34m
RESET := \033[0m

.PHONY: help install-tools check-tools fmt fmt-gofmt fmt-goimports fmt-gofumpt fmt-golines fmt-all fmt-check check-gocyclo check-staticcheck explain-staticcheck check-golangci-lint check-all check hooks-check-all hooks-fmt hooks-commit-msg hooks-uninstall hooks-uninstall-pre hooks-uninstall-msg hooks-install hooks-install-basic branch-setup new-feature new-hotfix clean-branches list-remote-branches branch-help check-branch safe-push

# 默认目标
help: ## 显示帮助信息
	@echo "$(BLUE)Available targets:$(RESET)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-20s$(RESET) %s\n", $$1, $$2}'

# 工具安装
install-tools: ## 安装所有格式化和检查工具
	@echo "$(YELLOW)Installing formatting and checking tools...$(RESET)"
	@$(GO) install golang.org/x/tools/cmd/goimports@latest
	@$(GO) install mvdan.cc/gofumpt@latest
	@$(GO) install github.com/segmentio/golines@latest
	@$(GO) install github.com/fzipp/gocyclo/cmd/gocyclo@latest
	@$(GO) install honnef.co/go/tools/cmd/staticcheck@2025.1.1
	@$(GO) install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v2.3.0
	@echo "$(GREEN)All tools installed successfully!$(RESET)"

# 检查工具是否可用
check-tools: ## 检查所有格式化和检查工具是否已安装
	@echo "$(YELLOW)Checking formatting and checking tools...$(RESET)"
	@command -v $(GO) >/dev/null 2>&1 || (echo "$(RED)go is not installed$(RESET)" && exit 1)
	@command -v $(GOIMPORTS) >/dev/null 2>&1 || (echo "$(RED)goimports is not installed. Run 'make install-tools'$(RESET)" && exit 1)
	@command -v $(GOFUMPT) >/dev/null 2>&1 || (echo "$(RED)gofumpt is not installed. Run 'make install-tools'$(RESET)" && exit 1)
	@command -v $(GOLINES) >/dev/null 2>&1 || (echo "$(RED)golines is not installed. Run 'make install-tools'$(RESET)" && exit 1)
	@command -v $(GOCYCLO) >/dev/null 2>&1 || (echo "$(RED)gocyclo is not installed. Run 'make install-tools'$(RESET)" && exit 1)
	@command -v $(STATICCHECK) >/dev/null 2>&1 || (echo "$(RED)staticcheck is not installed. Run 'make install-tools'$(RESET)" && exit 1)
	@command -v $(GOLANGCI_LINT) >/dev/null 2>&1 || (echo "$(RED)golangci-lint is not installed. Run 'make install-tools'$(RESET)" && exit 1)
	@echo "$(GREEN)All tools are available!$(RESET)"

# 单独的格式化工具
fmt-gofmt: ## 使用go fmt格式化代码
	@echo "$(YELLOW)Running go fmt...$(RESET)"
	@$(GO) fmt ./...
	@echo "$(GREEN)go fmt completed$(RESET)"

fmt-goimports: check-goimports ## 使用goimports格式化代码并整理导入
	@echo "$(YELLOW)Running goimports...$(RESET)"
	@$(GOIMPORTS) -w $(GOFILES)
	@echo "$(GREEN)goimports completed$(RESET)"

fmt-gofumpt: check-gofumpt ## 使用gofumpt进行更严格的格式化
	@echo "$(YELLOW)Running gofumpt...$(RESET)"
	@$(GOFUMPT) -w $(GOFILES)
	@echo "$(GREEN)gofumpt completed$(RESET)"

fmt-golines: check-golines ## 使用golines限制行长度
	@echo "$(YELLOW)Running golines...$(RESET)"
	@$(GOLINES) -w -m 120 $(GOFILES)
	@echo "$(GREEN)golines completed$(RESET)"

# 检查单个工具
check-goimports:
	@command -v $(GOIMPORTS) >/dev/null 2>&1 || (echo "$(RED)goimports is not installed. Run 'make install-tools'$(RESET)" && exit 1)

check-gofumpt:
	@command -v $(GOFUMPT) >/dev/null 2>&1 || (echo "$(RED)gofumpt is not installed. Run 'make install-tools'$(RESET)" && exit 1)

check-golines:
	@command -v $(GOLINES) >/dev/null 2>&1 || (echo "$(RED)golines is not installed. Run 'make install-tools'$(RESET)" && exit 1)

# 完整格式化流程
fmt-all: fmt-gofmt fmt-goimports fmt-gofumpt fmt-golines ## 使用所有工具进行完整的代码格式化
	@echo "$(GREEN)All formatting tools completed!$(RESET)"

# 简化的格式化命令
fmt: fmt-all ## 格式化代码（fmt-all的别名）

# 验证格式化
fmt-check: ## 检查代码格式是否符合标准（不修改文件）
	@echo "$(YELLOW)Checking code formatting...$(RESET)"
	@if [ -n "$$($(GO) fmt ./...)" ]; then \
		echo "$(RED)Code is not formatted. Run 'make fmt' to fix.$(RESET)"; \
		exit 1; \
	fi
	@echo "$(GREEN)Code formatting is correct$(RESET)"

# 代码质量检查工具
check-gocyclo: check-gocyclo-tool ## 检查代码圈复杂度
	@echo "$(YELLOW)Running gocyclo check...$(RESET)"
	@$(GOCYCLO) -over 10 $(GOFILES) || (echo "$(RED)High cyclomatic complexity detected$(RESET)" && exit 1)
	@echo "$(GREEN)Cyclomatic complexity check passed$(RESET)"

check-staticcheck: check-staticcheck-tool ## 运行静态分析检查
	@echo "$(YELLOW)Running staticcheck...$(RESET)"
	@$(STATICCHECK) ./...
	@echo "$(GREEN)Staticcheck passed$(RESET)"

explain-staticcheck: check-staticcheck-tool ## 解释staticcheck错误代码 (用法: make explain-staticcheck code=ST1008)
	@if [ -z "$(code)" ]; then \
		echo "$(RED)请提供错误代码，例如: make explain-staticcheck code=ST1008$(RESET)"; \
		exit 1; \
	fi
	@echo "$(YELLOW)解释staticcheck错误代码 $(code):$(RESET)"
	@$(STATICCHECK) -explain $(code)

check-golangci-lint: check-golangci-lint-tool ## 运行golangci-lint综合检查
	@echo "$(YELLOW)Running golangci-lint...$(RESET)"
	@$(GOLANGCI_LINT) run ./...
	@echo "$(GREEN)Golangci-lint check passed$(RESET)"

# 检查单个工具（代码质量工具）
check-gocyclo-tool:
	@command -v $(GOCYCLO) >/dev/null 2>&1 || (echo "$(RED)gocyclo is not installed. Run 'make install-tools'$(RESET)" && exit 1)

check-staticcheck-tool:
	@command -v $(STATICCHECK) >/dev/null 2>&1 || (echo "$(RED)staticcheck is not installed. Run 'make install-tools'$(RESET)" && exit 1)

check-golangci-lint-tool:
	@command -v $(GOLANGCI_LINT) >/dev/null 2>&1 || (echo "$(RED)golangci-lint is not installed. Run 'make install-tools'$(RESET)" && exit 1)

# 综合代码检查
check-all: fmt-check check-gocyclo check-staticcheck check-golangci-lint ## 运行所有代码质量检查
	@echo "$(GREEN)All code quality checks passed!$(RESET)"

# 代码质量检查别名
check: check-all ## 运行所有代码质量检查（check-all的别名）

# 显示项目信息
info: ## 显示项目信息
	@echo "$(BLUE)Project Information:$(RESET)"
	@echo "  Module: $(GOMODULES)"
	@echo "  Go files: $(words $(GOFILES))"
	@echo "  Go version: $$($(GO) version)"

# Git hooks集成
hooks-check-all: ## 安装pre-commit hook（格式化+代码质量棆查）
	@echo "$(YELLOW)Installing Git pre-commit hook (fmt + checks)...$(RESET)"
	@mkdir -p .git/hooks
	@echo '#!/bin/sh' > .git/hooks/pre-commit
	@echo '# Auto-format code and run quality checks before commit' >> .git/hooks/pre-commit
	@echo 'echo "$(YELLOW)Running code formatting...$(RESET)"' >> .git/hooks/pre-commit
	@echo '' >> .git/hooks/pre-commit
	@echo '# Run formatting' >> .git/hooks/pre-commit
	@echo 'make fmt' >> .git/hooks/pre-commit
	@echo '' >> .git/hooks/pre-commit
	@echo '# Check if any files were modified by formatting' >> .git/hooks/pre-commit
	@echo 'if [ -n "$$(git diff --name-only)" ]; then' >> .git/hooks/pre-commit
	@echo '    echo "$(GREEN)Code formatting completed. Adding formatted files to commit...$(RESET)"' >> .git/hooks/pre-commit
	@echo '    git add -u' >> .git/hooks/pre-commit
	@echo '    echo "$(GREEN)Formatted files added to commit.$(RESET)"' >> .git/hooks/pre-commit
	@echo 'else' >> .git/hooks/pre-commit
	@echo '    echo "$(GREEN)No formatting changes needed.$(RESET)"' >> .git/hooks/pre-commit
	@echo 'fi' >> .git/hooks/pre-commit
	@echo '' >> .git/hooks/pre-commit
	@echo '# Run code quality checks' >> .git/hooks/pre-commit
	@echo 'echo "$(YELLOW)Running code quality checks...$(RESET)"' >> .git/hooks/pre-commit
	@echo '' >> .git/hooks/pre-commit
	@echo '# Check cyclomatic complexity' >> .git/hooks/pre-commit
	@echo 'if ! make check-gocyclo >/dev/null 2>&1; then' >> .git/hooks/pre-commit
	@echo '    echo "$(RED)Cyclomatic complexity check failed. Please review your code.$(RESET)"' >> .git/hooks/pre-commit
	@echo '    exit 1' >> .git/hooks/pre-commit
	@echo 'fi' >> .git/hooks/pre-commit
	@echo '' >> .git/hooks/pre-commit
	@echo '# Run static analysis' >> .git/hooks/pre-commit
	@echo 'if ! make check-staticcheck >/dev/null 2>&1; then' >> .git/hooks/pre-commit
	@echo '    echo "$(RED)Static analysis check failed. Please fix the issues.$(RESET)"' >> .git/hooks/pre-commit
	@echo '    echo "$(YELLOW)Tip: Use '\''make explain-staticcheck code=XXXX'\'' to understand specific errors$(RESET)"' >> .git/hooks/pre-commit
	@echo '    exit 1' >> .git/hooks/pre-commit
	@echo 'fi' >> .git/hooks/pre-commit
	@echo '' >> .git/hooks/pre-commit
	@echo '# Run comprehensive lint check' >> .git/hooks/pre-commit
	@echo 'if ! make check-golangci-lint >/dev/null 2>&1; then' >> .git/hooks/pre-commit
	@echo '    echo "$(RED)Golangci-lint check failed. Please fix the issues.$(RESET)"' >> .git/hooks/pre-commit
	@echo '    exit 1' >> .git/hooks/pre-commit
	@echo 'fi' >> .git/hooks/pre-commit
	@echo '' >> .git/hooks/pre-commit
	@echo 'echo "$(GREEN)All pre-commit checks passed!$(RESET)"' >> .git/hooks/pre-commit
	@chmod +x .git/hooks/pre-commit
	@echo "$(GREEN)Git pre-commit hook (fmt + checks) installed$(RESET)"

hooks-fmt: ## 安装pre-commit hook（仅格式化）
	@echo "$(YELLOW)Installing Git pre-commit hook (fmt only)...$(RESET)"
	@mkdir -p .git/hooks
	@echo '#!/bin/sh' > .git/hooks/pre-commit
	@echo '# Auto-format code before commit (no quality checks)' >> .git/hooks/pre-commit
	@echo 'echo "$(YELLOW)Running code formatting...$(RESET)"' >> .git/hooks/pre-commit
	@echo '' >> .git/hooks/pre-commit
	@echo '# Run formatting' >> .git/hooks/pre-commit
	@echo 'make fmt' >> .git/hooks/pre-commit
	@echo '' >> .git/hooks/pre-commit
	@echo '# Check if any files were modified by formatting' >> .git/hooks/pre-commit
	@echo 'if [ -n "$$(git diff --name-only)" ]; then' >> .git/hooks/pre-commit
	@echo '    echo "$(GREEN)Code formatting completed. Adding formatted files to commit...$(RESET)"' >> .git/hooks/pre-commit
	@echo '    git add -u' >> .git/hooks/pre-commit
	@echo '    echo "$(GREEN)Formatted files added to commit.$(RESET)"' >> .git/hooks/pre-commit
	@echo 'else' >> .git/hooks/pre-commit
	@echo '    echo "$(GREEN)No formatting changes needed.$(RESET)"' >> .git/hooks/pre-commit
	@echo 'fi' >> .git/hooks/pre-commit
	@echo '' >> .git/hooks/pre-commit
	@echo 'echo "$(GREEN)Pre-commit formatting completed!$(RESET)"' >> .git/hooks/pre-commit
	@echo 'echo "$(YELLOW)Note: Run '\''make check-all'\'' manually for quality checks$(RESET)"' >> .git/hooks/pre-commit
	@chmod +x .git/hooks/pre-commit
	@echo "$(GREEN)Git pre-commit hook (fmt only) installed$(RESET)"

hooks-commit-msg: ## 安装commit-msg hook验证提交信息格式
	@echo "$(YELLOW)Installing Git commit-msg hook...$(RESET)"
	@mkdir -p .git/hooks
	@echo '#!/bin/sh' > .git/hooks/commit-msg
	@echo '# Validate commit message format (Conventional Commits)' >> .git/hooks/commit-msg
	@echo '' >> .git/hooks/commit-msg
	@echo 'commit_regex="^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .{1,50}"' >> .git/hooks/commit-msg
	@echo '' >> .git/hooks/commit-msg
	@echo 'if ! grep -qE "$$commit_regex" "$$1"; then' >> .git/hooks/commit-msg
	@echo '    echo "\033[31mCommit message format error!\033[0m"' >> .git/hooks/commit-msg
	@echo '    echo "Expected format: <type>(<scope>): <description>"' >> .git/hooks/commit-msg
	@echo '    echo "Types: feat, fix, docs, style, refactor, test, chore"' >> .git/hooks/commit-msg
	@echo '    echo "Example: feat: add user authentication"' >> .git/hooks/commit-msg
	@echo '    echo "Example: fix(auth): resolve login validation issue"' >> .git/hooks/commit-msg
	@echo '    exit 1' >> .git/hooks/commit-msg
	@echo 'fi' >> .git/hooks/commit-msg
	@echo '' >> .git/hooks/commit-msg
	@echo 'echo "\033[32mCommit message format validated!\033[0m"' >> .git/hooks/commit-msg
	@chmod +x .git/hooks/commit-msg
	@echo "$(GREEN)Git commit-msg hook installed$(RESET)"

hooks-pre-push: ## 安装pre-push hook验证分支命名规范
	@echo "$(YELLOW)Installing Git pre-push hook...$(RESET)"
	@mkdir -p .git/hooks
	@echo '#!/bin/sh' > .git/hooks/pre-push
	@echo '# Validate branch naming convention before push' >> .git/hooks/pre-push
	@echo '' >> .git/hooks/pre-push
	@echo 'current_branch=$$(git branch --show-current)' >> .git/hooks/pre-push
	@echo '' >> .git/hooks/pre-push
	@echo 'if echo "$$current_branch" | grep -qE "^(master|develop|feature-.*|hotfix-.*)$$"; then' >> .git/hooks/pre-push
	@echo '    echo "\033[32m✅ 分支 $$current_branch 符合推送规范\033[0m"' >> .git/hooks/pre-push
	@echo 'else' >> .git/hooks/pre-push
	@echo '    echo "\033[31m❌ 分支 $$current_branch 不符合推送规范\033[0m"' >> .git/hooks/pre-push
	@echo '    echo "\033[33m建议重命名为: feature-$$current_branch 或 hotfix-$$current_branch\033[0m"' >> .git/hooks/pre-push
	@echo '    echo "\033[33m允许的分支格式: master, develop, feature-*, hotfix-*\033[0m"' >> .git/hooks/pre-push
	@echo '    exit 1' >> .git/hooks/pre-push
	@echo 'fi' >> .git/hooks/pre-push
	@chmod +x .git/hooks/pre-push
	@echo "$(GREEN)Git pre-push hook installed$(RESET)"

# Git hooks卸载
hooks-uninstall: ## 卸载所有Git hooks
	@echo "$(YELLOW)Uninstalling all Git hooks...$(RESET)"
	@if [ -f .git/hooks/pre-commit ]; then \
		rm -f .git/hooks/pre-commit; \
		echo "$(GREEN)✓ Removed pre-commit hook$(RESET)"; \
	else \
		echo "$(BLUE)- pre-commit hook not found$(RESET)"; \
	fi
	@if [ -f .git/hooks/commit-msg ]; then \
		rm -f .git/hooks/commit-msg; \
		echo "$(GREEN)✓ Removed commit-msg hook$(RESET)"; \
	else \
		echo "$(BLUE)- commit-msg hook not found$(RESET)"; \
	fi
	@if [ -f .git/hooks/pre-push ]; then \
		rm -f .git/hooks/pre-push; \
		echo "$(GREEN)✓ Removed pre-push hook$(RESET)"; \
	else \
		echo "$(BLUE)- pre-push hook not found$(RESET)"; \
	fi
	@echo "$(GREEN)All Git hooks uninstalled$(RESET)"

hooks-uninstall-pre: ## 卸载pre-commit hook
	@echo "$(YELLOW)Uninstalling pre-commit hook...$(RESET)"
	@if [ -f .git/hooks/pre-commit ]; then \
		rm -f .git/hooks/pre-commit; \
		echo "$(GREEN)Pre-commit hook removed$(RESET)"; \
	else \
		echo "$(BLUE)Pre-commit hook not found$(RESET)"; \
	fi

hooks-uninstall-msg: ## 卸载commit-msg hook
	@echo "$(YELLOW)Uninstalling commit-msg hook...$(RESET)"
	@if [ -f .git/hooks/commit-msg ]; then \
		rm -f .git/hooks/commit-msg; \
		echo "$(GREEN)Commit-msg hook removed$(RESET)"; \
	else \
		echo "$(BLUE)Commit-msg hook not found$(RESET)"; \
	fi

# 组合安装命令
hooks-install: hooks-check-all hooks-commit-msg hooks-pre-push ## 安装所有Git hooks（pre-commit完整模式 + commit-msg + pre-push）
	@echo "$(GREEN)All Git hooks installed!$(RESET)"

hooks-install-basic: hooks-fmt hooks-commit-msg hooks-pre-push ## 安装基础Git hooks（pre-commit轻量模式 + commit-msg + pre-push）
	@echo "$(GREEN)Basic Git hooks installed!$(RESET)"

# 分支管理
branch-setup: ## 设置分支管理策略
	@echo "$(YELLOW)Setting up branch management...$(RESET)"
	@if [ -f .git/hooks/pre-push ]; then chmod +x .git/hooks/pre-push; fi
	@if [ -f .git/git-branch-helpers.sh ]; then chmod +x .git/git-branch-helpers.sh; fi
	@echo "$(GREEN)Branch management setup completed!$(RESET)"
	@echo ""
	@echo "$(BLUE)Available branch commands:$(RESET)"
	@echo "  make new-feature name=<name>     - 创建 feature-<name> 分支"
	@echo "  make new-hotfix name=<name>      - 创建 hotfix-<name> 分支"
	@echo "  make clean-branches              - 清理已合并的分支"
	@echo "  make list-remote-branches        - 列出符合规范的远程分支"
	@echo "  make branch-help                 - 显示分支管理帮助"

new-feature: ## 创建功能分支 (用法: make new-feature name=my-feature)
	@.git/git-branch-helpers.sh new-feature $(name)

new-hotfix: ## 创建热修复分支 (用法: make new-hotfix name=critical-fix)
	@.git/git-branch-helpers.sh new-hotfix $(name)

clean-branches: ## 清理已合并的本地分支
	@.git/git-branch-helpers.sh clean-branches

list-remote-branches: ## 列出符合规范的远程分支
	@.git/git-branch-helpers.sh list-remote-branches

branch-help: ## 显示分支管理帮助
	@.git/git-branch-helpers.sh branch-help

# 检查当前分支是否可以推送
check-branch: ## 检查当前分支是否符合推送规范
	@current_branch=$$(git branch --show-current); \
	if echo "$$current_branch" | grep -qE "^(master|develop|feature-.*|hotfix-.*)$$"; then \
		echo "$(GREEN)✅ 当前分支 $$current_branch 符合推送规范$(RESET)"; \
	else \
		echo "$(RED)❌ 当前分支 $$current_branch 不符合推送规范$(RESET)"; \
		echo "$(YELLOW)建议重命名为: feature-$$current_branch 或 hotfix-$$current_branch$(RESET)"; \
	fi

# 安全推送（先检查分支名）
safe-push: check-branch ## 安全推送当前分支到远程
	@current_branch=$$(git branch --show-current); \
	if echo "$$current_branch" | grep -qE "^(master|develop|feature-.*|hotfix-.*)$$"; then \
		echo "$(GREEN)正在推送 $$current_branch 到远程...$(RESET)"; \
		git push origin $$current_branch; \
	else \
		echo "$(RED)推送被拒绝: 分支名不符合规范$(RESET)"; \
		exit 1; \
	fi

# 开发环境设置
dev-setup: install-tools hooks-install branch-setup ## 设置完整的开发环境
	@echo "$(GREEN)Development environment setup completed!$(RESET)"
	@echo ""
	@echo "$(BLUE)可用的代码检查命令:$(RESET)"
	@echo "  make check                       - 运行所有代码质量检查"
	@echo "  make check-gocyclo               - 检查代码圈复杂度"
	@echo "  make check-staticcheck           - 运行静态分析检查"
	@echo "  make explain-staticcheck code=XX - 解释staticcheck错误代码"
	@echo "  make check-golangci-lint         - 运行综合lint检查"
	@echo ""
	@echo "$(BLUE)可用的Git Hook命令:$(RESET)"
	@echo "  安装命令:"
	@echo "    make hooks-install       - 安装所有hooks（推荐）"
	@echo "    make hooks-install-basic - 安装基础hooks（轻量）"
	@echo "    make hooks-check-all     - 仅pre-commit（全量检查）"
	@echo "    make hooks-fmt           - 仅pre-commit（格式化）"
	@echo "    make hooks-commit-msg    - 仅commit-msg验证"
	@echo "  卸载命令:"
	@echo "    make hooks-uninstall     - 卸载所有hooks"
	@echo "    make hooks-uninstall-pre - 卸载pre-commit hook"
	@echo "    make hooks-uninstall-msg - 卸载commit-msg hook"