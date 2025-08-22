# 📋 Contributor's Branch Management Guide

> 🎯 **For Contributors**: This guide is written specifically for developers who want to contribute code to this project

Welcome! We're excited that you want to contribute to this project. This guide will help you understand how to properly create branches, submit code, and collaborate with the project team.

## 🚀 Essential Reading Before Contributing

### Why Follow Branch Conventions?
As a contributor, following the project's branch conventions helps:
- ✅ Make your code easier for maintainers to understand and accept
- ✅ Prevent your Pull Request from being rejected due to formatting issues
- ✅ Keep the project organized for all contributors
- ✅ Ensure your contribution passes automated checks

### Workflow Used by This Project
We use **GitHub Flow** - a simple, beginner-friendly workflow:
- **One main branch**: `main` branch contains deployable code
- **Feature branches**: Each new feature or fix is developed on a separate branch
- **Pull Requests**: All code is submitted via PRs and reviewed before merging

## 🏷️ How to Name Your Contribution Branch

### First Time Contributing? Understand the Main Branch
- `main` - This is the project's main branch containing stable code
- You **don't need to directly modify** the main branch, just create your feature branch from it

### Choose the Right Branch Name for Your Contribution

As a contributor, you need to create a descriptive branch name for your work. The format is simple: `<type>/<what-you-are-doing>`

#### Common Contribution Types and Examples

| What You Want to Do | Use Type | Branch Name Example | When to Use |
|-------------------|----------|-------------------|-------------|
| Add new feature | `feature` | `feature/add-user-login` | When adding completely new functionality |
| Fix a bug | `fix` | `fix/button-click-error` | When you found and fixed a problem |
| Update documentation | `docs` | `docs/improve-readme` | When improving docs or explanations |
| Refactor code | `refactor` | `refactor/clean-database-code` | When improving code structure without changing functionality |
| Add tests | `test` | `test/add-login-tests` | When adding tests for existing features |

#### Simple Descriptive Naming (Recommended for Beginners)
If the format above feels too complex, you can use simple descriptions:
- `add-dark-mode` - Adding dark mode
- `fix-memory-leak` - Fix memory leak
- `update-dependencies` - Update dependencies

### ❌ Avoid These Branch Names (Will Be Rejected)
- `my_branch` - Contains underscore, not descriptive
- `temp` - Too vague, doesn't explain what you're doing
- `fix` - Too generic, fix what?
- `test branch` - Contains space
- `dev` - Easily confused with development branch

### 🤔 Not Sure What to Name It?

Try describing what you want to do in one sentence:
- "Add user login functionality" → `feature/user-login`
- "Fix button click issue" → `fix/button-click-issue`
- "Update README documentation" → `docs/update-readme`
- "Add unit tests" → `test/add-unit-tests`

## 🔄 Complete Contribution Workflow

### Step 1: Fork the Project and Clone Locally

If this is your first contribution, you need to fork the project first:

1. Click the "Fork" button on GitHub
2. Clone your fork locally:
```bash
git clone https://github.com/your-username/local-ci.git
cd local-ci
```

3. Add the original project as upstream:
```bash
git remote add upstream https://github.com/original-author/local-ci.git
```

### Step 2: Create Your Feature Branch

```bash
# Make sure you're on the main branch with latest code
git checkout main
git pull upstream main

# Now create your feature branch
# If the project has Makefile tools (recommended):
make new-feature name=your-feature-name

# Or create manually:
git checkout -b feature/your-feature-name
```

**Beginner Tip**: If you're not sure what to name it, think about the problem you're solving or feature you're adding, and use simple English description.

### Step 3: Develop Your Feature

Now you can start coding!

```bash
# Write your code...
# Modify files, add features, fix bugs, etc.

# Before committing, run the project's formatting tools (very important!)
make fmt          # Auto-format your code
make check        # Check code quality

# If the above commands have errors, fix them before continuing

# Commit your changes
git add .
git commit -m "feat: add user login functionality"
```

**⚠️ Important Notes**:
- This project has automated code checks, you MUST run `make fmt` and `make check` before committing
- If checks fail, your PR might be rejected
- Use the project's required commit message format (see below)

### Step 4: Submit Your Contribution

```bash
# Push to your fork
git push origin feature/your-feature-name

# If the project provides safe push command (recommended):
make safe-push
```

Then:
1. Open GitHub and go to your fork
2. You'll see a green "Compare & pull request" button
3. Click it and fill out the PR description
4. Submit the Pull Request

**PR Description Tips**:
- Briefly explain what you did
- If you fixed a bug, describe the original problem
- If you added a feature, explain what the feature does

### Step 5: Respond to Code Review

Project maintainers will review your code and may:
- ✅ Accept your PR directly
- 💬 Suggest improvements
- ❌ Ask you to fix certain issues

**If changes are needed**:
```bash
# Continue working on your feature branch
git checkout feature/your-feature-name

# Make changes...
# Run checks again
make fmt && make check

# Commit the fixes
git add .
git commit -m "fix: address review feedback"
git push origin feature/your-feature-name
```

Changes will automatically update in your PR.

### Step 6: After PR is Accepted

Congratulations! Your code has been merged. Now you can clean up:

```bash
# Switch back to main branch
git checkout main
git pull upstream main

# Delete your feature branch
git branch -d feature/your-feature-name
```

## 🛠️ Project's Convenience Commands (Optional)

This project may provide some Makefile commands to simplify your contribution workflow. You can check all available commands with `make help`.

### Commands Useful for Contributors

#### Creating Branches (Recommended for Beginners)
```bash
# One-command feature branch creation
make new-feature name=your-feature-name

# Create bug fix branch
make new-fix name=the-problem-you-are-fixing

# Advanced usage (if you're familiar with the workflow)
make new-branch type=feature name=specific-feature-name
```

#### Code Quality Checks (Very Important!)
```bash
make fmt         # Auto-format your code
make check       # Check if code meets project standards
make fmt-check   # Check formatting without modifying files
```

#### Safe Pushing
```bash
make check-branch  # Check if your branch name follows conventions
make safe-push     # Check and then push safely
```

### What If There Are No Makefile Commands?

If the project doesn't have these commands, no problem! You can do it manually:

```bash
# Manually create branch
git checkout -b feature/your-feature-name

# Manually push
git push origin feature/your-feature-name
```

### 🚨 Advanced Commands (For Project Maintainers Only)

As a contributor, you **don't need** to use these commands:
- `make push-and-pr` - Auto-create PR (better to create manually on GitHub)
- `make pr-merge` - Merge PR (only project maintainers can merge)

These are for project maintainers. As a contributor, you just need to know they exist.

## ✅ Branch Name Validation: Ensure Your PR Won't Be Rejected

The project automatically checks your branch name. As a contributor, make sure your branch name follows conventions:

### ✅ Branch Names That Will Be Accepted
```
✅ feature/user-login          # New feature
✅ fix/password-reset-bug      # Bug fix
✅ docs/update-readme          # Documentation update
✅ refactor/cleanup-code       # Code refactoring
✅ test/add-unit-tests         # Testing related
✅ add-dark-mode               # Simple description
✅ fix-memory-leak             # Simple fix
```

### ❌ Branch Names That Will Be Rejected (Please Avoid)
```
❌ my_branch                 # Underscore, not descriptive
❌ feature-login             # Hyphen separator
❌ temp                      # Too vague, doesn't explain what you're doing
❌ fix                       # Too generic, fix what?
❌ "user auth"               # Contains space
❌ dev                       # Easily confused with development branch
```

### 💡 If Your Branch Name Doesn't Follow Conventions

No worries! You can rename it:
```bash
git branch -m new-branch-name
```

Or create a new branch that follows conventions.

## 🚀 Project's Automated Checks (What You Need to Know)

This project may have automated checks set up. As a contributor, you need to understand:

### Automated Checks When Committing
When you run `git commit`, it may automatically:
- 🎨 Format your code
- ⚙️ Check code quality
- 📝 Validate commit message format

**What this means**:
- ✅ Your code will automatically become cleaner
- ⚠️ If there are issues, the commit may be blocked
- 💪 This ensures your PR quality is higher

### Checks When Pushing Code
When you run `git push`, it may check:
- 🏷️ Whether your branch name follows conventions
- ❌ If not compliant, it will block the push and give suggestions

### What to Do If Checks Fail?

1. **Code formatting issues**:
   ```bash
   make fmt  # Auto-fix formatting
   ```

2. **Code quality issues**:
   ```bash
   make check  # See specific problems
   ```

3. **Branch name issues**:
   ```bash
   git branch -m new-branch-name
   ```

4. **Commit message issues**:
   ```bash
   git commit --amend -m "correct commit message"
   ```

### 📝 Commit Message Format Requirements

Your commit messages need to follow a specific format:

**Correct Format**: `<type>: <description>`

Common types:
- `feat` - Adding new feature
- `fix` - Fixing bugs
- `docs` - Documentation updates
- `test` - Test related
- `refactor` - Code refactoring

**Examples**:
```bash
git commit -m "feat: add user login functionality"
git commit -m "fix: resolve button click issue"
git commit -m "docs: update installation guide"
```

## 💡 Secrets to Successful Contributions

As a new contributor, these tips will make your PRs more likely to be accepted:

### ✅ This Will Make Maintainers Happy

1. **Do One Thing at a Time**
   - 🎯 One PR should solve one problem or add one feature
   - ⚠️ Don't mix bug fixes with new features in the same PR

2. **Use Clear Names to Describe Your Work**
   ```bash
   ✅ feature/add-user-profile-page    # Clear what you're doing
   ✅ fix/login-button-crash          # Specific problem identified
   ❌ feature/updates                 # Too vague
   ❌ fix/stuff                       # Doesn't explain what's fixed
   ```

3. **Check Your Code Before Submitting**
   ```bash
   make fmt && make check  # Ensure code quality
   ```

4. **Write Meaningful Commit Messages**
   ```bash
   ✅ "feat: add user avatar upload feature"    # Explains specific functionality
   ✅ "fix: resolve login button unresponsive issue"  # Clear problem fixed
   ❌ "update"                        # Too vague
   ❌ "fix bug"                       # What bug?
   ```

5. **Keep in Sync with Main Branch (Important!)**
   ```bash
   # Regularly run during development:
   git checkout main
   git pull upstream main
   git checkout feature/your-feature
   git merge main
   ```
   
   **Why do this?** Prevents merge conflicts and makes your PR easier to merge.

### ❌ These Behaviors Will Get Your PR Rejected

1. **Not Following Branch Naming Conventions**
   - Using `my_branch`, `temp`, `test` and other non-descriptive names
   - System will automatically block non-compliant pushes

2. **Changing Too Many Things at Once**
   - Modifying dozens of files and adding multiple features in one PR
   - This makes it very hard for reviewers to understand your intent

3. **Ignoring Code Quality Checks**
   - Not running `make fmt` and `make check`
   - This will cause CI failures and your PR will be marked as problematic

4. **Using Meaningless Commit Messages**
   - "update", "fix", "changes" don't help people understand what you did

5. **Not Responding to Review Feedback**
   - When maintainers suggest changes, not replying or making the changes

## 🔧 First-Time Contributor Setup

If this is your first time contributing to this project, you may need to set up some things:

### Install Project's Required Tools

If the project has a `make dev-setup` command, run it:
```bash
make dev-setup
```

This will help you install:
- 🎨 Code formatting tools
- ⚙️ Code quality check tools
- 📝 Git commit checks

### If There's No Such Command

Check the project's README file, which usually has development environment setup instructions.

### As a Contributor, You Don't Need to Modify These
- Branch naming rules
- Git hooks configuration
- CI/CD settings

These are the project maintainer's job. You just need to follow these rules.

## 🆘 Common Contributor Issues & Solutions

### Q: My branch name doesn't follow conventions, what do I do?

**Solution**: Rename your branch
```bash
git branch -m feature/new-appropriate-name

# For example:
git branch -m feature/add-user-login
```

### Q: `git commit` is blocked, showing formatting errors

**Reason**: Project has automated code checks
**Solution**:
```bash
make fmt      # Auto-fix formatting issues
make check    # Check what other issues exist

# Then try committing again
git add .
git commit -m "your commit message"
```

### Q: `git push` is blocked, says branch name doesn't comply

**Solution**: Rename the branch
```bash
# Look at the suggested name, then rename
git branch -m new-name

# Then push again
git push origin new-name
```

### Q: My PR is said to have code quality issues

**Solution**: Fix locally
```bash
# On your feature branch
make fmt && make check  # Follow error messages to fix

# After fixing, recommit
git add .
git commit -m "fix: resolve code quality issues"
git push origin feature/your-branch-name
```

### Q: I don't know how to use the project's `make` commands

**Check help**:
```bash
make help     # See all available commands
```

**If there are no make commands**: Check the project's README file, which usually has instructions.

### Q: Can I skip these checks?

**Answer**: Not recommended. These checks are for:
- ✅ Ensuring code quality
- ✅ Making your PR more likely to be accepted
- ✅ Maintaining project consistency

If you really encounter an emergency:
```bash
git commit --no-verify  # Skip commit checks
git push --no-verify    # Skip push checks
```

But remember, doing this might cause your PR to be rejected.

## 📚 Contributor Resources

### Must-Read Documentation
- **README.md** - Project overview and basic usage
- **CONTRIBUTING.md** - Detailed contribution guidelines (if available)

### Advanced Resources (Optional)
- `Makefile-readme.md` - Complete command documentation
- `ADVANCED-PR-SETUP.md` - Advanced user features (not relevant for contributors)

## 🚀 Contributor Advancement Guide

### For New Contributors
1. **Start with Small Issues**
   - Look for issues labeled "good first issue" or "beginner-friendly"
   - Try simple tasks like fixing docs, adding comments first
   - Learn the workflow before attempting more complex features

2. **Learn by Example**
   - When unsure, look at other contributors' PRs
   - Mimic their branch naming and commit message style
   - Learn how they respond to review feedback

### For Experienced Contributors
1. **Help Newcomers**
   - Give constructive feedback during PR reviews
   - Share your experience and best practices

2. **Proactive Communication**
   - For large features, open an Issue to discuss design first
   - Finalize the plan before development to avoid wasted work

---

🎉 **Thank you for wanting to contribute to this project!**

Every contribution, no matter how small, is meaningful to the project. If you encounter any issues during the contribution process, don't hesitate to open an Issue for help - the community will assist you!

📝 **Document Version**: v2.0 (Contributor Edition)  
📅 **Last Updated**: 2024  
👥 **Target Audience**: Project Contributors