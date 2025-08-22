# =============================================================================
# Python Language Support - Makefile Module
# =============================================================================

# Python tool definitions
PYTHON := python3
BLACK := black
FLAKE8 := flake8
MYPY := mypy

# Python project variables
PYTHON_DIR := backend-python
PYTHON_FILES := $(shell find backend-python -name "*.py" 2>/dev/null || true)

# =============================================================================
# Python Tool Installation
# =============================================================================

install-tools-python: ## Install Python development tools
	@if [ "$(HAS_PYTHON)" = "true" ]; then \
		echo "$(YELLOW)Installing Python tools...$(RESET)"; \
		$(PYTHON) -m pip install black flake8 mypy; \
		echo "$(GREEN)Python tools installed$(RESET)"; \
	else \
		echo "$(BLUE)Skipping Python tools (no Python project detected)$(RESET)"; \
	fi

check-tools-python: ## Check Python development tools
	@if [ "$(HAS_PYTHON)" = "true" ]; then \
		echo "$(YELLOW)Checking Python tools...$(RESET)"; \
		command -v $(PYTHON) >/dev/null 2>&1 || (echo "$(RED)Python is not installed$(RESET)" && exit 1); \
		$(PYTHON) -c "import black" 2>/dev/null || (echo "$(RED)black is not installed. Run 'make install-tools-python'$(RESET)" && exit 1); \
		$(PYTHON) -c "import flake8" 2>/dev/null || (echo "$(RED)flake8 is not installed. Run 'make install-tools-python'$(RESET)" && exit 1); \
		$(PYTHON) -c "import mypy" 2>/dev/null || (echo "$(RED)mypy is not installed. Run 'make install-tools-python'$(RESET)" && exit 1); \
		echo "$(GREEN)Python tools available$(RESET)"; \
	fi

# =============================================================================
# Python Code Formatting
# =============================================================================

fmt-python: ## Format Python code
	@if [ "$(HAS_PYTHON)" = "true" ]; then \
		echo "$(YELLOW)Formatting Python code...$(RESET)"; \
		cd $(PYTHON_DIR) && $(BLACK) .; \
		echo "$(GREEN)Python code formatted$(RESET)"; \
	else \
		echo "$(BLUE)Skipping Python formatting (no Python project)$(RESET)"; \
	fi

# =============================================================================
# Python Code Quality Checks
# =============================================================================

check-python: ## Check Python code quality
	@if [ "$(HAS_PYTHON)" = "true" ]; then \
		echo "$(YELLOW)Checking Python code quality...$(RESET)"; \
		cd $(PYTHON_DIR); \
		$(FLAKE8) .; \
		$(MYPY) .; \
		echo "$(GREEN)Python code quality checks passed$(RESET)"; \
	else \
		echo "$(BLUE)Skipping Python checks (no Python project)$(RESET)"; \
	fi

# Show Python project information
info-python: ## Show Python project information
	@echo "$(BLUE)Python Project Information:$(RESET)"
	@echo "  Python files: $(words $(PYTHON_FILES))"
	@if [ "$(HAS_PYTHON)" = "true" ]; then \
		echo "  Python version: $$($(PYTHON) --version)"; \
		echo "  Pip version: $$($(PYTHON) -m pip --version)"; \
	fi

# Format check (without modifying files)
fmt-check-python: ## Check if Python code format meets standards (without modifying files)
	@echo "$(YELLOW)Checking Python code formatting...$(RESET)"
	@if [ "$(HAS_PYTHON)" = "true" ]; then \
		cd $(PYTHON_DIR) && $(BLACK) --check . || (echo "$(RED)Python code is not formatted. Run 'make fmt-python' to fix.$(RESET)" && exit 1); \
	fi
	@echo "$(GREEN)Python code formatting checks passed$(RESET)"