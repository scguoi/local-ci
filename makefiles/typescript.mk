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

install-tools-ts: ## Install TypeScript development tools
	@if [ "$(HAS_TS)" = "true" ]; then \
		echo "$(YELLOW)Installing TypeScript tools...$(RESET)"; \
		cd $(TS_DIR) && $(NPM) install --save-dev prettier eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin; \
		echo "$(GREEN)TypeScript tools installed$(RESET)"; \
	else \
		echo "$(BLUE)Skipping TypeScript tools (no TypeScript project detected)$(RESET)"; \
	fi

check-tools-ts: ## Check TypeScript development tools
	@if [ "$(HAS_TS)" = "true" ]; then \
		echo "$(YELLOW)Checking TypeScript tools...$(RESET)"; \
		command -v node >/dev/null 2>&1 || (echo "$(RED)Node.js is not installed$(RESET)" && exit 1); \
		command -v $(NPM) >/dev/null 2>&1 || (echo "$(RED)npm is not installed$(RESET)" && exit 1); \
		cd $(TS_DIR) && $(NPM) list typescript >/dev/null 2>&1 || (echo "$(RED)TypeScript is not installed. Run 'make install-tools-ts'$(RESET)" && exit 1); \
		echo "$(GREEN)TypeScript tools available$(RESET)"; \
	fi

# =============================================================================
# TypeScript Code Formatting
# =============================================================================

fmt-ts: ## Format TypeScript code
	@if [ "$(HAS_TS)" = "true" ]; then \
		echo "$(YELLOW)Formatting TypeScript code...$(RESET)"; \
		cd $(TS_DIR) && npx $(PRETTIER) --write "**/*.{ts,tsx,js,jsx,json,css,md}"; \
		echo "$(GREEN)TypeScript code formatted$(RESET)"; \
	else \
		echo "$(BLUE)Skipping TypeScript formatting (no TypeScript project)$(RESET)"; \
	fi

# =============================================================================
# TypeScript Code Quality Checks
# =============================================================================

check-ts: ## Check TypeScript code quality
	@if [ "$(HAS_TS)" = "true" ]; then \
		echo "$(YELLOW)Checking TypeScript code quality...$(RESET)"; \
		cd $(TS_DIR); \
		npx $(TSC) --noEmit; \
		npx $(ESLINT) . --ext .ts,.tsx,.js,.jsx; \
		echo "$(GREEN)TypeScript code quality checks passed$(RESET)"; \
	else \
		echo "$(BLUE)Skipping TypeScript checks (no TypeScript project)$(RESET)"; \
	fi

# Show TypeScript project information
info-ts: ## Show TypeScript project information
	@echo "$(BLUE)TypeScript Project Information:$(RESET)"
	@echo "  TypeScript files: $(words $(TS_FILES))"
	@if [ "$(HAS_TS)" = "true" ]; then \
		echo "  Node version: $$(node --version)"; \
		echo "  NPM version: $$(npm --version)"; \
		cd $(TS_DIR) && echo "  TypeScript version: $$(npx tsc --version)"; \
	fi

# Format check (without modifying files)
fmt-check-ts: ## Check if TypeScript code format meets standards (without modifying files)
	@echo "$(YELLOW)Checking TypeScript code formatting...$(RESET)"
	@if [ "$(HAS_TS)" = "true" ]; then \
		cd $(TS_DIR) && npx $(PRETTIER) --check "**/*.{ts,tsx,js,jsx,json,css,md}" || (echo "$(RED)TypeScript code is not formatted. Run 'make fmt-ts' to fix.$(RESET)" && exit 1); \
	fi
	@echo "$(GREEN)TypeScript code formatting checks passed$(RESET)"