# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Architecture

This is a **local CI/CD toolchain for Go projects**, not a traditional application. The core value lies in the comprehensive Makefile-based development workflow, while main.go serves only as a demonstration HTTP server.

### Key Architecture Components

- **Makefile (379 lines)**: The heart of the system containing all CI/CD automation
- **Git Hooks**: Automated pre-commit, commit-msg, and pre-push validation
- **Tool Chain**: Integration of 6 Go development tools (goimports, gofumpt, golines, gocyclo, staticcheck, golangci-lint)
- **Branch Management**: Enforced naming conventions and workflow automation

### Data Flow

```
Developer Code → make fmt → Git Hooks → Quality Checks → Safe Push
     ↓              ↓           ↓            ↓            ↓
   main.go    Auto-format   Validation   Static-analysis  Branch-check
```

## Essential Commands

### Environment Setup
```bash
make dev-setup          # One-time setup: installs tools + configures Git hooks
make install-tools      # Install all Go development tools
make check-tools        # Verify tool installation
```

### Daily Development Workflow
```bash
make fmt               # Auto-format code (gofmt + goimports + gofumpt + golines)
make check             # Run all quality checks (complexity + static analysis + lint)
make new-feature name=feature-name  # Create properly named feature branch  
make safe-push         # Validate branch name and push safely
```

### Testing and Validation
```bash
make fmt-check         # Verify code formatting without modifying files
make check-gocyclo     # Check cyclomatic complexity (threshold: 10)
make check-staticcheck # Run static analysis
make check-golangci-lint # Comprehensive linting
make explain-staticcheck code=ST1008  # Explain specific staticcheck errors
```

### Git Hook Management
```bash
make hooks-install      # Install all hooks (pre-commit + commit-msg + pre-push)
make hooks-install-basic # Lightweight hooks (formatting only)
make hooks-uninstall    # Remove all Git hooks
```

### Application Runtime
```bash
go run main.go         # Start HTTP server on port 8080 (demo only)
```

## Code Quality Standards

### Automatic Formatting Pipeline
1. `go fmt` - Basic Go formatting
2. `goimports` - Import organization  
3. `gofumpt` - Strict formatting
4. `golines -m 120` - Line length enforcement

### Quality Gates
- **Cyclomatic Complexity**: Maximum 10 per function
- **Static Analysis**: Must pass staticcheck@2025.1.1
- **Comprehensive Linting**: Must pass golangci-lint@v2.3.0
- **Commit Messages**: Must follow Conventional Commits format
- **Branch Names**: Must follow `feature-*` or `hotfix-*` pattern

## Branch and Commit Conventions

### Branch Naming
- `master` - Main branch
- `develop` - Development branch  
- `feature-*` - Feature branches (use `make new-feature name=xxx`)
- `hotfix-*` - Hotfix branches (use `make new-hotfix name=xxx`)

### Commit Message Format
```
<type>(<scope>): <description>

Types: feat, fix, docs, style, refactor, test, chore
Examples:
- feat: add user authentication
- fix(makefile): resolve pre-push hook issue
- docs: update API documentation
```

## Development Constraints

### Pre-commit Hook Behavior
- Automatically formats code before each commit
- Runs full quality check suite (can be slow)
- Fails commit if quality gates not met
- Auto-adds formatted files to commit

### Tool Version Locks
- staticcheck: 2025.1.1 (pinned)
- golangci-lint: v2.3.0 (pinned)  
- Other tools: @latest

## Important Notes for Development

### This is NOT a Traditional Go Application
- main.go is a minimal demo server only
- Real value is in the Makefile toolchain
- Focus on improving development workflow, not application features

### Git Hooks Are Mandatory Once Installed
- Cannot bypass without `--no-verify` flag
- Pre-commit runs full format + quality pipeline
- Quality checks can significantly slow down commits
- Use `make hooks-install-basic` for faster development cycles

### Missing Components (Planned)
- Unit testing framework
- Test coverage reporting  
- Performance benchmarking
- Docker containerization

## Troubleshooting Common Issues

### Tool Installation Failures
```bash
make check-tools        # Identify missing tools
make install-tools      # Reinstall all tools
```

### Git Hook Problems
```bash
ls -la .git/hooks/      # Check hook permissions
make hooks-install      # Reinstall hooks
```

### Quality Check Failures
```bash
make explain-staticcheck code=ST1008  # Understand staticcheck errors
# For complexity issues: refactor functions or temporarily adjust threshold in Makefile
```

Refer to `Makefile-readme.md` for comprehensive documentation of all available commands and detailed usage examples.