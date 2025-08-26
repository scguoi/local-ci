# =============================================================================
# TypeScript Language Support - Makefile Module
# =============================================================================

# TypeScript tool definitions
NPM := npm
PRETTIER := prettier
ESLINT := eslint
TSC := tsc

# TypeScript project variables
TS_DIR := frontend-ts
TS_FILES := $(shell find frontend-ts -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" 2>/dev/null || true)

# =============================================================================
# TypeScript Tool Installation
# =============================================================================

install-tools-typescript: ## Install TypeScript development tools
	@if [ "$(HAS_TS)" = "true" ]; then \
		echo "$(YELLOW)Installing TypeScript tools...$(RESET)"; \
		cd $(TS_DIR) && $(NPM) install --save-dev \
			prettier@^3.6.2 \
			eslint@^9.33.0 \
			@typescript-eslint/parser@^8.40.0 \
			@typescript-eslint/eslint-plugin@^8.40.0 \
			eslint-config-prettier@^9.1.0 \
			eslint-plugin-import@^2.29.1 \
			eslint-plugin-prettier@^5.1.3; \
		echo "$(GREEN)TypeScript tools installed$(RESET)"; \
	else \
		echo "$(BLUE)Skipping TypeScript tools (no TypeScript project detected)$(RESET)"; \
	fi

check-tools-typescript: ## Check TypeScript development tools
	@if [ "$(HAS_TS)" = "true" ]; then \
		echo "$(YELLOW)Checking TypeScript tools...$(RESET)"; \
		command -v node >/dev/null 2>&1 || (echo "$(RED)Node.js is not installed$(RESET)" && exit 1); \
		command -v $(NPM) >/dev/null 2>&1 || (echo "$(RED)npm is not installed$(RESET)" && exit 1); \
		cd $(TS_DIR) && $(NPM) list typescript >/dev/null 2>&1 || (echo "$(RED)TypeScript is not installed. Run 'make install-tools-typescript'$(RESET)" && exit 1); \
		cd $(TS_DIR) && $(NPM) list prettier >/dev/null 2>&1 || (echo "$(RED)Prettier is not installed. Run 'make install-tools-typescript'$(RESET)" && exit 1); \
		cd $(TS_DIR) && $(NPM) list eslint >/dev/null 2>&1 || (echo "$(RED)ESLint is not installed. Run 'make install-tools-typescript'$(RESET)" && exit 1); \
		echo "$(GREEN)TypeScript tools available$(RESET)"; \
	else \
		echo "$(BLUE)Skipping TypeScript tools (no TypeScript project detected)$(RESET)"; \
	fi

# =============================================================================
# TypeScript Code Formatting
# =============================================================================

fmt-typescript: ## Format TypeScript code
	@if [ "$(HAS_TS)" = "true" ]; then \
		echo "$(YELLOW)Formatting TypeScript code...$(RESET)"; \
		cd $(TS_DIR) && npx $(PRETTIER) --write "**/*.{ts,tsx,js,jsx,json,md}"; \
		echo "$(GREEN)TypeScript code formatted$(RESET)"; \
	else \
		echo "$(BLUE)Skipping TypeScript formatting (no TypeScript project)$(RESET)"; \
	fi

# =============================================================================
# TypeScript Code Quality Checks
# =============================================================================

check-typescript: ## Check TypeScript code quality
	@if [ "$(HAS_TS)" = "true" ]; then \
		echo "$(YELLOW)Checking TypeScript code quality...$(RESET)"; \
		cd $(TS_DIR); \
		echo "$(YELLOW)Running TypeScript type checking...$(RESET)" && \
		npx $(TSC) --noEmit && \
		echo "$(YELLOW)Running ESLint...$(RESET)" && \
		npx $(ESLINT) "**/*.{ts,tsx}" && \
		echo "$(GREEN)TypeScript code quality checks completed$(RESET)"; \
	else \
		echo "$(BLUE)Skipping TypeScript checks (no TypeScript project)$(RESET)"; \
	fi

# Show TypeScript project information
info-typescript: ## Show TypeScript project information
	@echo "$(BLUE)TypeScript Project Information:$(RESET)"
	@echo "  TypeScript files: $(words $(TS_FILES))"
	@if [ "$(HAS_TS)" = "true" ]; then \
		echo "  Node version: $$(node --version)"; \
		echo "  NPM version: $$(npm --version)"; \
		cd $(TS_DIR) && echo "  TypeScript version: $$(npx tsc --version)"; \
	fi

# Format check (without modifying files)
fmt-check-typescript: ## Check if TypeScript code format meets standards (without modifying files)
	@echo "$(YELLOW)Checking TypeScript code formatting...$(RESET)"
	@if [ "$(HAS_TS)" = "true" ]; then \
		cd $(TS_DIR) && npx $(PRETTIER) --check "**/*.{ts,tsx,js,jsx,json,md}" || (echo "$(RED)TypeScript code is not formatted. Run 'make fmt-typescript' to fix.$(RESET)" && exit 1); \
	fi
	@echo "$(GREEN)TypeScript code formatting checks passed$(RESET)"

# =============================================================================
# Individual TypeScript Quality Check Tools
# =============================================================================

check-eslint-typescript: ## Run ESLint syntax and style checks
	@echo "$(YELLOW)Running ESLint checks...$(RESET)"
	@if [ "$(HAS_TS)" = "true" ]; then \
		cd $(TS_DIR) && npx $(ESLINT) "**/*.{ts,tsx}"; \
		echo "$(GREEN)ESLint checks passed$(RESET)"; \
	fi

check-tsc-typescript: ## Run TypeScript type checking
	@echo "$(YELLOW)Running TypeScript type checking...$(RESET)"
	@if [ "$(HAS_TS)" = "true" ]; then \
		cd $(TS_DIR) && npx $(TSC) --noEmit; \
		echo "$(GREEN)TypeScript type checking passed$(RESET)"; \
	fi

# =============================================================================
# Legacy aliases for backward compatibility
# =============================================================================

install-tools-ts: install-tools-typescript
check-tools-ts: check-tools-typescript
fmt-ts: fmt-typescript
check-ts: check-typescript
info-ts: info-typescript
fmt-check-ts: fmt-check-typescript