# 🚨 Advanced PR Management Setup

> **⚠️ Warning**: This is for advanced users, repository maintainers, and team leads only!

## Prerequisites

Before enabling PR management features, ensure you meet ALL requirements:

### 1. **Repository Permissions** ✅
- [ ] You have **write access** to the repository
- [ ] You understand your team's code review process
- [ ] You're authorized to merge Pull Requests

### 2. **Technical Requirements** 🛠️
- [ ] GitHub CLI (`gh`) installed and authenticated
- [ ] Understanding of GitHub Flow workflow
- [ ] Familiarity with Git branching and merging

### 3. **Team Alignment** 👥
- [ ] Your team approves using automated PR tools
- [ ] No conflicts with existing CI/CD processes
- [ ] Clear understanding of when to use these commands

## Installation Steps

### Step 1: Verify GitHub CLI
```bash
# Check if gh is installed
gh --version

# If not installed, install it:
# macOS: brew install gh
# Linux: https://github.com/cli/cli/blob/trunk/docs/install_linux.md
# Windows: https://github.com/cli/cli/releases

# Authenticate with GitHub
gh auth login
```

### Step 2: Test Your Permissions
```bash
# Test if you can create/view PRs in your repo
gh pr list
gh repo view
```

### Step 3: Enable PR Management
Edit the main `Makefile` and uncomment this line:
```makefile
# include makefiles/git-pr.mk  # <- Remove the # to enable
```

### Step 4: Verify Installation
```bash
make help | grep -E "(pr-|github-flow)"
```

You should see PR-related commands with warning icons.

## Available Commands

Once enabled, you'll have access to:

| Command | Risk Level | Description |
|---------|------------|-------------|
| `make pr-status` | 🟢 Safe | View current branch PR status |
| `make pr-list` | 🟢 Safe | List all open Pull Requests |
| `make push-and-pr` | 🟡 Caution | Push branch and create PR |
| `make switch-to-main` | 🟡 Caution | Switch to main and pull updates |
| `make pr-merge` | 🔴 Dangerous | Merge PR and delete branch |

## Usage Guidelines

### ✅ DO Use When:
- You're a repository maintainer
- Working on your own fork/repository
- Team has approved automated PR workflows
- You understand the implications of each command

### ❌ DON'T Use When:
- You're a new contributor
- Working on someone else's repository
- Team has strict manual review processes
- You're unsure about repository permissions

## Safety Features

We've built in several safety measures:

1. **Warning Messages**: All dangerous commands show warnings
2. **Confirmation Prompts**: `pr-merge` requires manual confirmation
3. **Permission Checks**: Commands verify GitHub CLI authentication
4. **Graceful Failures**: Commands won't break if they fail

## Troubleshooting

### "GitHub CLI (gh) required for this command"
```bash
# Install and authenticate GitHub CLI
brew install gh  # or your platform's method
gh auth login
```

### "Failed to merge PR. Check if PR exists and is approved"
- Ensure the PR exists and is approved
- Check if you have merge permissions
- Verify branch protection rules aren't blocking the merge

### "No PR found for current branch"
- Create a PR first with `make push-and-pr`
- Or create one manually on GitHub

## Disabling PR Management

If you want to disable these features:

1. Comment out the include line in `Makefile`:
   ```makefile
   # include makefiles/git-pr.mk
   ```

2. The commands will no longer be available

## Support

If you encounter issues:

1. Check GitHub CLI authentication: `gh auth status`
2. Verify repository permissions: `gh repo view`
3. Review your team's workflow requirements
4. Consider whether basic branch management (`git.mk`) is sufficient for your needs

---

**Remember**: With great power comes great responsibility. These tools can significantly impact your team's workflow, so use them wisely! 🦸‍♂️