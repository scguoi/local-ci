# 🔍 Python代码质量检测手册

## 📖 概述

本手册详细说明项目中使用的Python代码质量检测工具链，包括工具介绍、使用方法、质量标准和最佳实践。

## 🛠️ 工具链架构

### 格式化工具链
```
源代码 → isort → black → 标准化代码
```

### 质量检测链
```
代码 → flake8 → mypy → pylint → 质量报告
```

## 🎯 质量标准

| 检测维度 | 标准要求 | 检测工具 | 阈值设置 |
|---------|---------|----------|----------|
| **代码格式** | 符合PEP 8标准 | black + isort | 强制执行 |
| **Import管理** | 按标准排序分组 | isort | 自动整理 |
| **行长度** | 单行不超过88字符 | black | 88字符 |
| **类型检查** | 严格类型注解 | mypy | 0 errors |
| **静态分析** | 无潜在bug和问题 | flake8 + pylint | 0 issues |
| **代码规范** | 遵循最佳实践 | pylint | 评分≥8.0 |

## 🔧 工具详解

### 1. 代码格式化工具

#### **Black** - 代码格式化器
```bash
# 手动使用
black *.py

# 项目中集成
make fmt-python  # 包含在完整格式化流程中
```
**作用**：Python代码格式化器，自动格式化代码符合PEP 8标准

**配置特点**：
- 行长度：88字符
- 目标Python版本：3.9, 3.10, 3.11
- 自动处理缩进、空格、引号等格式问题

#### **isort** - Import管理
```bash
# 安装
pip install isort

# 使用
isort *.py  # 自动整理imports
```
**功能**：
- 自动添加缺失的import
- 移除未使用的import
- 按标准库、第三方库、本地包分组排序
- 与Black兼容的格式化

### 2. 代码质量检测工具

#### **Flake8** - 语法和风格检查
```bash
# 安装
pip install flake8

# 使用
flake8 *.py                    # 检查所有Python文件
flake8 --max-line-length=88 .  # 自定义行长度
```

**检测类别**：
- **E**: pycodestyle errors（PEP 8错误）
- **W**: pycodestyle warnings（PEP 8警告）
- **F**: pyflakes（逻辑错误）
- **C**: mccabe（圈复杂度）

**常见错误码**：
```
E501: line too long (88 > 88 characters)
E302: expected 2 blank lines, found 1
F401: imported but unused
C901: 'function_name' is too complex (10)
```

#### **MyPy** - 类型检查
```bash
# 安装
pip install mypy

# 使用
mypy *.py                      # 检查所有Python文件
mypy --strict *.py             # 严格模式检查
```

**配置特点**：
- Python版本：3.11
- 严格模式设置：
  - `warn_return_any`: 警告返回Any类型
  - `disallow_untyped_defs`: 禁止未类型化的函数定义
  - `disallow_incomplete_defs`: 禁止不完整的函数定义
  - `check_untyped_defs`: 检查未类型化的函数定义
  - `disallow_untyped_decorators`: 禁止未类型化的装饰器

**常见错误**：
```
error: Function is missing a return type annotation
error: Argument 1 to "function" has incompatible type "str"; expected "int"
error: Incompatible return value type (got "str", expected "int")
```

#### **Pylint** - 静态代码分析
```bash
# 安装
pip install pylint

# 使用
pylint *.py                    # 分析所有Python文件
pylint --fail-under=8.0 *.py   # 设置最低评分阈值
```

**检测维度**：
- **C**: Convention（代码规范）
- **R**: Refactor（重构建议）
- **W**: Warning（警告）
- **E**: Error（错误）
- **F**: Fatal（致命错误）

**设计规则限制**：
- 最大参数数：7
- 最大局部变量：15
- 最大返回语句：6
- 最大分支：12
- 最大语句数：50

## 🚀 日常使用指南

### 开发工作流

#### 1. 环境初始化
```bash
# 一键安装所有Python工具
make install-tools-python

# 验证工具安装
make check-tools-python
```

#### 2. 代码开发
```bash
# 编写代码...

# 格式化代码
make fmt-python

# 质量检查
make check-python
```

#### 3. 提交前检查
```bash
# 完整检查（包含格式化）
make fmt && make check

# 或使用Git hooks自动执行（推荐）
git commit -m "feat: add new feature"  # hooks自动运行
```

### 单独工具使用

#### 格式化检查
```bash
# 检查代码格式（不修改文件）
make fmt-check-python

# 自动格式化
make fmt-python
```

#### 类型检查
```bash
# 运行MyPy类型检查
make check-mypy-python

# 严格模式检查
mypy --strict backend-python/
```

#### 静态分析
```bash
# 运行Pylint分析
make check-pylint-python

# 查看详细报告
pylint --reports=y backend-python/
```

#### 语法检查
```bash
# 运行Flake8检查
make check-flake8-python

# 只检查特定问题
flake8 --select=E,W backend-python/
```

## 📊 质量报告解读

### Flake8报告
```bash
$ flake8 backend-python/
backend-python/main.py:5:1: E302 expected 2 blank lines before class
backend-python/main.py:8:80: E501 line too long (89 > 88 characters)
backend-python/main.py:12:1: F401 'os' imported but unused
```
**解读**：
- E302：类定义前需要2个空行
- E501：行长度超过88字符限制
- F401：导入了未使用的模块

### MyPy报告
```bash
$ mypy backend-python/
backend-python/main.py:15: error: Function is missing a return type annotation
backend-python/main.py:20: error: Argument 1 to "process_data" has incompatible type "str"; expected "int"
```
**解读**：
- 函数缺少返回类型注解
- 函数参数类型不匹配

### Pylint报告
```bash
$ pylint backend-python/
Your code has been rated at 7.50/10 (previous run: 7.50/10)

************* Module main
backend-python/main.py:1:0: C0114: Missing module docstring (missing-module-docstring)
backend-python/main.py:5:0: C0116: Missing function or method docstring (missing-docstring)
```
**解读**：
- 代码评分为7.50/10
- 缺少模块文档字符串
- 缺少函数文档字符串

## ⚠️ 常见问题处理

### 1. 行长度超限
**问题**：`E501: line too long (89 > 88 characters)`

**解决方案**：
```python
# ❌ 行过长
def process_user_data(user_id: int, user_name: str, user_email: str, user_phone: str, user_address: str) -> dict:

# ✅ 重构后
def process_user_data(
    user_id: int, 
    user_name: str, 
    user_email: str, 
    user_phone: str, 
    user_address: str
) -> dict:
```

### 2. Import顺序问题
**问题**：Import顺序不规范

**解决方案**：运行`isort`自动修复
```bash
isort backend-python/*.py
```

### 3. 类型注解缺失
**问题**：`Function is missing a return type annotation`

**解决方案**：
```python
# ❌ 缺少类型注解
def process_data(data):
    return data.upper()

# ✅ 添加类型注解
def process_data(data: str) -> str:
    return data.upper()
```

### 4. 未使用导入
**问题**：`F401: 'os' imported but unused`

**解决方案**：
```python
# ❌ 未使用的导入
import os
import sys
import json

def main():
    print("Hello World")

# ✅ 移除未使用的导入
import sys

def main():
    print("Hello World")
```

### 5. 函数复杂度过高
**问题**：`C901: 'complex_function' is too complex (15)`

**解决方案**：
```python
# ❌ 复杂度过高
def process_data(data: list) -> dict:
    result = {}
    for item in data:
        if isinstance(item, str):
            if len(item) > 10:
                if item.startswith("user"):
                    if "admin" in item.lower():
                        result[item] = "admin"
                    else:
                        result[item] = "user"
                else:
                    result[item] = "other"
            else:
                result[item] = "short"
        elif isinstance(item, int):
            if item > 100:
                result[str(item)] = "large"
            else:
                result[str(item)] = "small"
    return result

# ✅ 重构后
def process_data(data: list) -> dict:
    result = {}
    for item in data:
        result[str(item)] = classify_item(item)
    return result

def classify_item(item) -> str:
    if isinstance(item, str):
        return classify_string(item)
    elif isinstance(item, int):
        return classify_number(item)
    return "unknown"

def classify_string(item: str) -> str:
    if len(item) <= 10:
        return "short"
    if item.startswith("user"):
        return "admin" if "admin" in item.lower() else "user"
    return "other"

def classify_number(item: int) -> str:
    return "large" if item > 100 else "small"
```

## 🎛️ 自定义配置

### Pyproject.toml配置
```toml
[tool.black]
line-length = 88
target-version = ['py39', 'py310', 'py311']
include = '\.pyi?$'

[tool.isort]
profile = "black"
line_length = 88
multi_line_output = 3
include_trailing_comma = true
force_grid_wrap = 0
use_parentheses = true

[tool.mypy]
python_version = "3.11"
warn_return_any = true
disallow_untyped_defs = true
disallow_incomplete_defs = true
check_untyped_defs = true
disallow_untyped_decorators = true
no_implicit_optional = true

[tool.pylint.messages_control]
max-line-length = 88
disable = [
    "C0103",  # invalid-name
    "R0903",  # too-few-public-methods
    "C0111",  # missing-docstring
]
```

### Setup.cfg配置
```ini
[flake8]
max-line-length = 88
extend-ignore = E203,W503,E501
max-complexity = 10
select = E,W,F,C
exclude = 
    .git,
    __pycache__,
    .venv,
    venv/,
    build/,
    dist/,
    *.egg-info/,
    .mypy_cache/,
    .pytest_cache/
```

## 📈 质量提升建议

### 1. 逐步提升标准
```bash
# 阶段1：基础质量
pylint --fail-under=6.0 *.py

# 阶段2：中等质量  
pylint --fail-under=7.0 *.py

# 阶段3：高质量
pylint --fail-under=8.0 *.py
```

### 2. 持续监控
```bash
# 定期生成质量报告
flake8 --format=json backend-python/ > flake8_report.json
pylint --reports=y backend-python/ > pylint_report.txt
mypy backend-python/ > mypy_report.txt
```

### 3. 团队规范
- 提交前必须通过所有质量检查
- 定期review质量报告
- 建立代码质量指标看板
- 分享最佳实践案例

## 🔗 参考链接

- [PEP 8 -- Style Guide for Python Code](https://www.python.org/dev/peps/pep-0008/)
- [PEP 484 -- Type Hints](https://www.python.org/dev/peps/pep-0484/)
- [Black文档](https://black.readthedocs.io/)
- [MyPy文档](https://mypy.readthedocs.io/)
- [Pylint文档](https://pylint.pycqa.org/)
- [Flake8文档](https://flake8.pycqa.org/)

---

💡 **记住**：代码质量检测不是为了限制开发，而是为了帮助我们写出更好、更可靠的Python代码！

🤖 如有问题，参考 `make help` 或联系技术负责人
