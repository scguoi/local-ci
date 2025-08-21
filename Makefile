# Makefile for Multi-Language CI/CD Development Tasks
# Supports: Go, TypeScript, Java (Maven), Python

# =============================================================================
# Project Detection
# =============================================================================

# Detect available projects
HAS_GO := $(shell [ -d "backend-go" ] && echo "true")
HAS_TS := $(shell [ -d "frontend-ts" ] && echo "true")
HAS_JAVA := $(shell [ -d "backend-java" ] && echo "true")
HAS_PYTHON := $(shell [ -d "backend-python" ] && echo "true")

# =============================================================================
# Language-Specific Variables
# =============================================================================

# Go相关变量
GO := go
GOFILES := $(shell find backend-go -name "*.go" 2>/dev/null || true)
GOMODULES := $(shell cd backend-go && $(GO) list -m 2>/dev/null || echo "No Go module")

# TypeScript相关变量
TS_DIR := frontend-ts
TS_FILES := $(shell find frontend-ts -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" 2>/dev/null || true)
NPM := npm
PRETTIER := prettier
ESLINT := eslint
TSC := tsc

# Java/Maven相关变量
JAVA_DIR := backend-java
MVN := mvn
JAVA_FILES := $(shell find backend-java -name "*.java" 2>/dev/null || true)

# Python相关变量
PYTHON_DIR := backend-python
PYTHON_FILES := $(shell find backend-python -name "*.py" 2>/dev/null || true)
PYTHON := python3
BLACK := black
FLAKE8 := flake8
MYPY := mypy

# =============================================================================
# Tool Definitions
# =============================================================================

# Go格式化工具
GOIMPORTS := goimports
GOFUMPT := gofumpt
GOLINES := golines

# Go代码检查工具
GOCYCLO := gocyclo
STATICCHECK := staticcheck
GOLANGCI_LINT := golangci-lint

# 颜色输出
RED := \033[31m
GREEN := \033[32m
YELLOW := \033[33m
BLUE := \033[34m
RESET := \033[0m

.PHONY: help install-tools check-tools fmt fmt-all fmt-go fmt-ts fmt-java fmt-python fmt-check check check-all check-go check-ts check-java check-python project-status hooks-check-all hooks-fmt hooks-commit-msg hooks-uninstall hooks-install hooks-install-basic create-branch-helpers branch-setup new-feature new-hotfix clean-branches list-remote-branches branch-help check-branch safe-push dev-setup

# 默认目标
help: ## 显示帮助信息
	@echo "$(BLUE)Multi-Language CI/CD Development Toolchain$(RESET)"
	@echo ""
	@make --no-print-directory project-status
	@echo ""
	@echo "$(BLUE)Available targets:$(RESET)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-20s$(RESET) %s\n", $$1, $$2}'

# 项目状态检查
project-status: ## 显示检测到的项目状态
	@echo "$(BLUE)Detected Projects:$(RESET)"
	@if [ "$(HAS_GO)" = "true" ]; then echo "  $(GREEN)✓ Go Backend$(RESET)       (backend-go/)"; else echo "  $(RED)✗ Go Backend$(RESET)       (backend-go/)"; fi
	@if [ "$(HAS_TS)" = "true" ]; then echo "  $(GREEN)✓ TypeScript Frontend$(RESET) (frontend-ts/)"; else echo "  $(RED)✗ TypeScript Frontend$(RESET) (frontend-ts/)"; fi
	@if [ "$(HAS_JAVA)" = "true" ]; then echo "  $(GREEN)✓ Java Backend$(RESET)      (backend-java/)"; else echo "  $(RED)✗ Java Backend$(RESET)      (backend-java/)"; fi
	@if [ "$(HAS_PYTHON)" = "true" ]; then echo "  $(GREEN)✓ Python Backend$(RESET)    (backend-python/)"; else echo "  $(RED)✗ Python Backend$(RESET)    (backend-python/)"; fi

# =============================================================================
# Tool Installation
# =============================================================================

install-tools: ## 安装所有语言的格式化和检查工具
	@echo "$(YELLOW)Installing multi-language development tools...$(RESET)"
	@make --no-print-directory install-tools-go
	@make --no-print-directory install-tools-ts
	@make --no-print-directory install-tools-java
	@make --no-print-directory install-tools-python
	@echo "$(GREEN)All multi-language tools installation completed!$(RESET)"

install-tools-go: ## 安装Go开发工具
	@if [ "$(HAS_GO)" = "true" ]; then \
		echo "$(YELLOW)Installing Go tools...$(RESET)"; \
		$(GO) install golang.org/x/tools/cmd/goimports@latest; \
		$(GO) install mvdan.cc/gofumpt@latest; \
		$(GO) install github.com/segmentio/golines@latest; \
		$(GO) install github.com/fzipp/gocyclo/cmd/gocyclo@latest; \
		$(GO) install honnef.co/go/tools/cmd/staticcheck@2025.1.1; \
		$(GO) install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v2.3.0; \
		echo "$(GREEN)Go tools installed$(RESET)"; \
	else \
		echo "$(BLUE)Skipping Go tools (no Go project detected)$(RESET)"; \
	fi

install-tools-ts: ## 安装TypeScript开发工具
	@if [ "$(HAS_TS)" = "true" ]; then \
		echo "$(YELLOW)Installing TypeScript tools...$(RESET)"; \
		cd $(TS_DIR) && $(NPM) install --save-dev prettier eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin; \
		echo "$(GREEN)TypeScript tools installed$(RESET)"; \
	else \
		echo "$(BLUE)Skipping TypeScript tools (no TypeScript project detected)$(RESET)"; \
	fi

install-tools-java: ## 安装Java开发工具
	@if [ "$(HAS_JAVA)" = "true" ]; then \
		echo "$(YELLOW)Installing Java tools...$(RESET)"; \
		echo "$(GREEN)Java tools ready (using Maven built-in tools)$(RESET)"; \
	else \
		echo "$(BLUE)Skipping Java tools (no Java project detected)$(RESET)"; \
	fi

install-tools-python: ## 安装Python开发工具
	@if [ "$(HAS_PYTHON)" = "true" ]; then \
		echo "$(YELLOW)Installing Python tools...$(RESET)"; \
		$(PYTHON) -m pip install black flake8 mypy; \
		echo "$(GREEN)Python tools installed$(RESET)"; \
	else \
		echo "$(BLUE)Skipping Python tools (no Python project detected)$(RESET)"; \
	fi

check-tools: ## 检查所有语言的开发工具是否已安装
	@echo "$(YELLOW)Checking multi-language development tools...$(RESET)"
	@make --no-print-directory check-tools-go
	@make --no-print-directory check-tools-ts  
	@make --no-print-directory check-tools-java
	@make --no-print-directory check-tools-python
	@echo "$(GREEN)Multi-language tools check completed!$(RESET)"

check-tools-go: ## 检查Go开发工具
	@if [ "$(HAS_GO)" = "true" ]; then \
		echo "$(YELLOW)Checking Go tools...$(RESET)"; \
		command -v $(GO) >/dev/null 2>&1 || (echo "$(RED)go is not installed$(RESET)" && exit 1); \
		command -v $(GOIMPORTS) >/dev/null 2>&1 || (echo "$(RED)goimports is not installed. Run 'make install-tools-go'$(RESET)" && exit 1); \
		command -v $(GOFUMPT) >/dev/null 2>&1 || (echo "$(RED)gofumpt is not installed. Run 'make install-tools-go'$(RESET)" && exit 1); \
		command -v $(GOLINES) >/dev/null 2>&1 || (echo "$(RED)golines is not installed. Run 'make install-tools-go'$(RESET)" && exit 1); \
		command -v $(GOCYCLO) >/dev/null 2>&1 || (echo "$(RED)gocyclo is not installed. Run 'make install-tools-go'$(RESET)" && exit 1); \
		command -v $(STATICCHECK) >/dev/null 2>&1 || (echo "$(RED)staticcheck is not installed. Run 'make install-tools-go'$(RESET)" && exit 1); \
		command -v $(GOLANGCI_LINT) >/dev/null 2>&1 || (echo "$(RED)golangci-lint is not installed. Run 'make install-tools-go'$(RESET)" && exit 1); \
		echo "$(GREEN)Go tools available$(RESET)"; \
	fi

check-tools-ts: ## 检查TypeScript开发工具
	@if [ "$(HAS_TS)" = "true" ]; then \
		echo "$(YELLOW)Checking TypeScript tools...$(RESET)"; \
		command -v node >/dev/null 2>&1 || (echo "$(RED)Node.js is not installed$(RESET)" && exit 1); \
		command -v $(NPM) >/dev/null 2>&1 || (echo "$(RED)npm is not installed$(RESET)" && exit 1); \
		cd $(TS_DIR) && $(NPM) list typescript >/dev/null 2>&1 || (echo "$(RED)TypeScript is not installed. Run 'make install-tools-ts'$(RESET)" && exit 1); \
		echo "$(GREEN)TypeScript tools available$(RESET)"; \
	fi

check-tools-java: ## 检查Java开发工具
	@if [ "$(HAS_JAVA)" = "true" ]; then \
		echo "$(YELLOW)Checking Java tools...$(RESET)"; \
		command -v java >/dev/null 2>&1 || (echo "$(RED)Java is not installed$(RESET)" && exit 1); \
		command -v $(MVN) >/dev/null 2>&1 || (echo "$(RED)Maven is not installed$(RESET)" && exit 1); \
		echo "$(GREEN)Java tools available$(RESET)"; \
	fi

check-tools-python: ## 检查Python开发工具
	@if [ "$(HAS_PYTHON)" = "true" ]; then \
		echo "$(YELLOW)Checking Python tools...$(RESET)"; \
		command -v $(PYTHON) >/dev/null 2>&1 || (echo "$(RED)Python is not installed$(RESET)" && exit 1); \
		$(PYTHON) -c "import black" 2>/dev/null || (echo "$(RED)black is not installed. Run 'make install-tools-python'$(RESET)" && exit 1); \
		$(PYTHON) -c "import flake8" 2>/dev/null || (echo "$(RED)flake8 is not installed. Run 'make install-tools-python'$(RESET)" && exit 1); \
		$(PYTHON) -c "import mypy" 2>/dev/null || (echo "$(RED)mypy is not installed. Run 'make install-tools-python'$(RESET)" && exit 1); \
		echo "$(GREEN)Python tools available$(RESET)"; \
	fi

# =============================================================================
# Code Formatting
# =============================================================================

fmt: fmt-all ## 格式化所有项目代码

fmt-all: ## 格式化所有语言项目代码
	@echo "$(YELLOW)Formatting all projects...$(RESET)"
	@make --no-print-directory fmt-go
	@make --no-print-directory fmt-ts
	@make --no-print-directory fmt-java
	@make --no-print-directory fmt-python
	@echo "$(GREEN)All projects formatted!$(RESET)"

# Go格式化命令
fmt-go: ## 格式化Go代码
	@if [ "$(HAS_GO)" = "true" ]; then \
		echo "$(YELLOW)Formatting Go code...$(RESET)"; \
		cd backend-go && $(GO) fmt ./...; \
		if [ -n "$(GOFILES)" ]; then \
			$(GOIMPORTS) -w $(GOFILES); \
			$(GOFUMPT) -w $(GOFILES); \
			$(GOLINES) -w -m 120 $(GOFILES); \
		fi; \
		echo "$(GREEN)Go code formatted$(RESET)"; \
	else \
		echo "$(BLUE)Skipping Go formatting (no Go project)$(RESET)"; \
	fi

# TypeScript格式化命令
fmt-ts: ## 格式化TypeScript代码
	@if [ "$(HAS_TS)" = "true" ]; then \
		echo "$(YELLOW)Formatting TypeScript code...$(RESET)"; \
		cd $(TS_DIR) && npx $(PRETTIER) --write "**/*.{ts,tsx,js,jsx,json,css,md}"; \
		echo "$(GREEN)TypeScript code formatted$(RESET)"; \
	else \
		echo "$(BLUE)Skipping TypeScript formatting (no TypeScript project)$(RESET)"; \
	fi

# Java格式化命令
fmt-java: ## 格式化Java代码
	@if [ "$(HAS_JAVA)" = "true" ]; then \
		echo "$(YELLOW)Formatting Java code...$(RESET)"; \
		cd $(JAVA_DIR) && $(MVN) compile; \
		echo "$(GREEN)Java code formatted$(RESET)"; \
	else \
		echo "$(BLUE)Skipping Java formatting (no Java project)$(RESET)"; \
	fi

# Python格式化命令
fmt-python: ## 格式化Python代码
	@if [ "$(HAS_PYTHON)" = "true" ]; then \
		echo "$(YELLOW)Formatting Python code...$(RESET)"; \
		cd $(PYTHON_DIR) && $(BLACK) .; \
		echo "$(GREEN)Python code formatted$(RESET)"; \
	else \
		echo "$(BLUE)Skipping Python formatting (no Python project)$(RESET)"; \
	fi

# =============================================================================
# Code Quality Checks
# =============================================================================

check: check-all ## 运行所有代码质量检查

check-all: ## 检查所有语言项目代码质量
	@echo "$(YELLOW)Running code quality checks for all projects...$(RESET)"
	@make --no-print-directory check-go
	@make --no-print-directory check-ts
	@make --no-print-directory check-java
	@make --no-print-directory check-python
	@echo "$(GREEN)All code quality checks completed!$(RESET)"

# Go代码质量检查
check-go: ## 检查Go代码质量
	@if [ "$(HAS_GO)" = "true" ]; then \
		echo "$(YELLOW)Checking Go code quality...$(RESET)"; \
		cd backend-go; \
		$(GOCYCLO) -over 10 . || (echo "$(RED)High cyclomatic complexity detected$(RESET)" && exit 1); \
		$(STATICCHECK) ./...; \
		$(GOLANGCI_LINT) run ./...; \
		echo "$(GREEN)Go code quality checks passed$(RESET)"; \
	else \
		echo "$(BLUE)Skipping Go checks (no Go project)$(RESET)"; \
	fi

# TypeScript代码质量检查
check-ts: ## 检查TypeScript代码质量
	@if [ "$(HAS_TS)" = "true" ]; then \
		echo "$(YELLOW)Checking TypeScript code quality...$(RESET)"; \
		cd $(TS_DIR); \
		npx $(TSC) --noEmit; \
		npx $(ESLINT) . --ext .ts,.tsx,.js,.jsx; \
		echo "$(GREEN)TypeScript code quality checks passed$(RESET)"; \
	else \
		echo "$(BLUE)Skipping TypeScript checks (no TypeScript project)$(RESET)"; \
	fi

# Java代码质量检查
check-java: ## 检查Java代码质量
	@if [ "$(HAS_JAVA)" = "true" ]; then \
		echo "$(YELLOW)Checking Java code quality...$(RESET)"; \
		cd $(JAVA_DIR); \
		$(MVN) compile; \
		$(MVN) test; \
		echo "$(GREEN)Java code quality checks passed$(RESET)"; \
	else \
		echo "$(BLUE)Skipping Java checks (no Java project)$(RESET)"; \
	fi

# Python代码质量检查
check-python: ## 检查Python代码质量
	@if [ "$(HAS_PYTHON)" = "true" ]; then \
		echo "$(YELLOW)Checking Python code quality...$(RESET)"; \
		cd $(PYTHON_DIR); \
		$(FLAKE8) .; \
		$(MYPY) .; \
		echo "$(GREEN)Python code quality checks passed$(RESET)"; \
	else \
		echo "$(BLUE)Skipping Python checks (no Python project)$(RESET)"; \
	fi

# 格式检查（不修改文件）
fmt-check: ## 检查代码格式是否符合标准（不修改文件）
	@echo "$(YELLOW)Checking code formatting...$(RESET)"
	@if [ "$(HAS_GO)" = "true" ]; then \
		cd backend-go; \
		if [ -n "$$($(GO) fmt ./...)" ]; then \
			echo "$(RED)Go code is not formatted. Run 'make fmt-go' to fix.$(RESET)"; \
			exit 1; \
		fi; \
	fi
	@echo "$(GREEN)Code formatting checks passed$(RESET)"

check-gofumpt:
	@command -v $(GOFUMPT) >/dev/null 2>&1 || (echo "$(RED)gofumpt is not installed. Run 'make install-tools'$(RESET)" && exit 1)

check-golines:
	@command -v $(GOLINES) >/dev/null 2>&1 || (echo "$(RED)golines is not installed. Run 'make install-tools'$(RESET)" && exit 1)

# 简化的格式化命令
fmt: fmt-all ## 格式化代码（fmt-all的别名）

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

# 注：check: check-all 别名已在上面的代码质量检查部分定义

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
	@echo '# Run multi-language code quality checks' >> .git/hooks/pre-commit
	@echo 'echo "$(YELLOW)Running multi-language code quality checks...$(RESET)"' >> .git/hooks/pre-commit
	@echo '' >> .git/hooks/pre-commit
	@echo '# Run all project quality checks' >> .git/hooks/pre-commit
	@echo 'if ! make check >/dev/null 2>&1; then' >> .git/hooks/pre-commit
	@echo '    echo "$(RED)Code quality checks failed. Please fix the issues.$(RESET)"' >> .git/hooks/pre-commit
	@echo '    echo "$(YELLOW)Tip: Run '\''make check'\'' to see detailed error messages$(RESET)"' >> .git/hooks/pre-commit
	@echo '    echo "$(YELLOW)Or run language-specific checks: make check-go/check-ts/check-java/check-python$(RESET)"' >> .git/hooks/pre-commit
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

# =============================================================================
# Branch Management
# =============================================================================

create-branch-helpers: ## 创建Git分支管理辅助脚本
	@echo "$(YELLOW)Creating Git branch management helper script...$(RESET)"
	@mkdir -p .git
	@if [ ! -f .git/git-branch-helpers.sh ]; then \
		echo '#!/bin/bash' > .git/git-branch-helpers.sh; \
		echo '' >> .git/git-branch-helpers.sh; \
		echo '# Git Branch Management Helper Script' >> .git/git-branch-helpers.sh; \
		echo '# Part of Multi-Language CI/CD Development Toolchain' >> .git/git-branch-helpers.sh; \
		echo '' >> .git/git-branch-helpers.sh; \
		echo '# Colors for output' >> .git/git-branch-helpers.sh; \
		echo "RED='\033[31m'" >> .git/git-branch-helpers.sh; \
		echo "GREEN='\033[32m'" >> .git/git-branch-helpers.sh; \
		echo "YELLOW='\033[33m'" >> .git/git-branch-helpers.sh; \
		echo "BLUE='\033[34m'" >> .git/git-branch-helpers.sh; \
		echo "RESET='\033[0m'" >> .git/git-branch-helpers.sh; \
		echo '' >> .git/git-branch-helpers.sh; \
		echo '# Function to create a new feature branch' >> .git/git-branch-helpers.sh; \
		echo 'new_feature() {' >> .git/git-branch-helpers.sh; \
		echo '    local feature_name=$$1' >> .git/git-branch-helpers.sh; \
		echo '    if [ -z "$$feature_name" ]; then' >> .git/git-branch-helpers.sh; \
		echo '        echo -e "$${RED}Error: Feature name is required$${RESET}"' >> .git/git-branch-helpers.sh; \
		echo '        echo "Usage: make new-feature name=my-feature"' >> .git/git-branch-helpers.sh; \
		echo '        exit 1' >> .git/git-branch-helpers.sh; \
		echo '    fi' >> .git/git-branch-helpers.sh; \
		echo '    local branch_name="feature-$$feature_name"' >> .git/git-branch-helpers.sh; \
		echo '    echo -e "$${YELLOW}Creating feature branch: $$branch_name$${RESET}"' >> .git/git-branch-helpers.sh; \
		echo '    if git branch --list | grep -q "$$branch_name"; then' >> .git/git-branch-helpers.sh; \
		echo '        echo -e "$${RED}Error: Branch $$branch_name already exists$${RESET}"' >> .git/git-branch-helpers.sh; \
		echo '        exit 1' >> .git/git-branch-helpers.sh; \
		echo '    fi' >> .git/git-branch-helpers.sh; \
		echo '    git checkout -b "$$branch_name"' >> .git/git-branch-helpers.sh; \
		echo '    echo -e "$${GREEN}✅ Created and switched to feature branch: $$branch_name$${RESET}"' >> .git/git-branch-helpers.sh; \
		echo '}' >> .git/git-branch-helpers.sh; \
		echo '' >> .git/git-branch-helpers.sh; \
		echo '# Function to create a new hotfix branch' >> .git/git-branch-helpers.sh; \
		echo 'new_hotfix() {' >> .git/git-branch-helpers.sh; \
		echo '    local hotfix_name=$$1' >> .git/git-branch-helpers.sh; \
		echo '    if [ -z "$$hotfix_name" ]; then' >> .git/git-branch-helpers.sh; \
		echo '        echo -e "$${RED}Error: Hotfix name is required$${RESET}"' >> .git/git-branch-helpers.sh; \
		echo '        exit 1' >> .git/git-branch-helpers.sh; \
		echo '    fi' >> .git/git-branch-helpers.sh; \
		echo '    local branch_name="hotfix-$$hotfix_name"' >> .git/git-branch-helpers.sh; \
		echo '    git checkout -b "$$branch_name"' >> .git/git-branch-helpers.sh; \
		echo '    echo -e "$${GREEN}✅ Created hotfix branch: $$branch_name$${RESET}"' >> .git/git-branch-helpers.sh; \
		echo '}' >> .git/git-branch-helpers.sh; \
		echo '' >> .git/git-branch-helpers.sh; \
		echo '# Function to list remote branches' >> .git/git-branch-helpers.sh; \
		echo 'list_remote_branches() {' >> .git/git-branch-helpers.sh; \
		echo '    echo -e "$${BLUE}Remote branches:$${RESET}"' >> .git/git-branch-helpers.sh; \
		echo '    git fetch --quiet' >> .git/git-branch-helpers.sh; \
		echo '    git branch -r | grep -E "(origin/master|origin/develop|origin/feature-|origin/hotfix-)"' >> .git/git-branch-helpers.sh; \
		echo '}' >> .git/git-branch-helpers.sh; \
		echo '' >> .git/git-branch-helpers.sh; \
		echo '# Function to display help' >> .git/git-branch-helpers.sh; \
		echo 'branch_help() {' >> .git/git-branch-helpers.sh; \
		echo '    echo -e "$${BLUE}Branch Management Help$${RESET}"' >> .git/git-branch-helpers.sh; \
		echo '    echo "Available commands: new-feature, new-hotfix, list-remote-branches, branch-help"' >> .git/git-branch-helpers.sh; \
		echo '}' >> .git/git-branch-helpers.sh; \
		echo '' >> .git/git-branch-helpers.sh; \
		echo '# Main logic' >> .git/git-branch-helpers.sh; \
		echo 'case "$$1" in' >> .git/git-branch-helpers.sh; \
		echo '    "new-feature") new_feature "$$2" ;;' >> .git/git-branch-helpers.sh; \
		echo '    "new-hotfix") new_hotfix "$$2" ;;' >> .git/git-branch-helpers.sh; \
		echo '    "list-remote-branches") list_remote_branches ;;' >> .git/git-branch-helpers.sh; \
		echo '    "branch-help") branch_help ;;' >> .git/git-branch-helpers.sh; \
		echo '    *) echo "Unknown command"; exit 1 ;;' >> .git/git-branch-helpers.sh; \
		echo 'esac' >> .git/git-branch-helpers.sh; \
		chmod +x .git/git-branch-helpers.sh; \
		echo "$(GREEN)Git branch management helper script created$(RESET)"; \
	else \
		echo "$(BLUE)Git branch management helper script already exists$(RESET)"; \
	fi

branch-setup: create-branch-helpers ## 设置分支管理策略
	@echo "$(YELLOW)Setting up branch management...$(RESET)"
	@if [ -f .git/hooks/pre-push ]; then chmod +x .git/hooks/pre-push; fi
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