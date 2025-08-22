# =============================================================================
# Java Language Support - Makefile Module
# =============================================================================

# Java tool definitions
MVN := mvn

# Java project variables
JAVA_DIR := backend-java
JAVA_FILES := $(shell find backend-java -name "*.java" 2>/dev/null || true)

# =============================================================================
# Java Tool Installation
# =============================================================================

install-tools-java: ## Install Java development tools
	@if [ "$(HAS_JAVA)" = "true" ]; then \
		echo "$(YELLOW)Installing Java tools...$(RESET)"; \
		echo "$(GREEN)Java tools ready (using Maven built-in tools)$(RESET)"; \
	else \
		echo "$(BLUE)Skipping Java tools (no Java project detected)$(RESET)"; \
	fi

check-tools-java: ## Check Java development tools
	@if [ "$(HAS_JAVA)" = "true" ]; then \
		echo "$(YELLOW)Checking Java tools...$(RESET)"; \
		command -v java >/dev/null 2>&1 || (echo "$(RED)Java is not installed$(RESET)" && exit 1); \
		command -v $(MVN) >/dev/null 2>&1 || (echo "$(RED)Maven is not installed$(RESET)" && exit 1); \
		echo "$(GREEN)Java tools available$(RESET)"; \
	fi

# =============================================================================
# Java Code Formatting
# =============================================================================

fmt-java: ## Format Java code
	@if [ "$(HAS_JAVA)" = "true" ]; then \
		echo "$(YELLOW)Formatting Java code...$(RESET)"; \
		cd $(JAVA_DIR) && $(MVN) compile; \
		echo "$(GREEN)Java code formatted$(RESET)"; \
	else \
		echo "$(BLUE)Skipping Java formatting (no Java project)$(RESET)"; \
	fi

# =============================================================================
# Java Code Quality Checks
# =============================================================================

check-java: ## Check Java code quality
	@if [ "$(HAS_JAVA)" = "true" ]; then \
		echo "$(YELLOW)Checking Java code quality...$(RESET)"; \
		cd $(JAVA_DIR); \
		$(MVN) compile; \
		$(MVN) test; \
		echo "$(GREEN)Java code quality checks passed$(RESET)"; \
	else \
		echo "$(BLUE)Skipping Java checks (no Java project)$(RESET)"; \
	fi

# Show Java project information
info-java: ## Show Java project information
	@echo "$(BLUE)Java Project Information:$(RESET)"
	@echo "  Java files: $(words $(JAVA_FILES))"
	@if [ "$(HAS_JAVA)" = "true" ]; then \
		echo "  Java version: $$(java -version 2>&1 | head -n 1)"; \
		echo "  Maven version: $$(mvn --version | head -n 1)"; \
	fi

# Format check (without modifying files)
fmt-check-java: ## Check if Java code format meets standards (without modifying files)
	@echo "$(YELLOW)Checking Java code formatting...$(RESET)"
	@if [ "$(HAS_JAVA)" = "true" ]; then \
		cd $(JAVA_DIR) && $(MVN) validate || (echo "$(RED)Java code validation failed. Run 'make fmt-java' to fix.$(RESET)" && exit 1); \
	fi
	@echo "$(GREEN)Java code formatting checks passed$(RESET)"