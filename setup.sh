#!/usr/bin/env bash
#
# Agent Context Kit — Environment Setup
# ======================================
# Sets up everything you need to run the agent, MCP server, eval harness,
# and tutorial validator. Safe to run multiple times (idempotent).
#
# Usage:
#   ./setup.sh              # Full setup
#   ./setup.sh --check      # Just check what's installed, don't install anything
#
# What it does:
#   1. Checks OS and shell
#   2. Checks/installs Git
#   3. Checks/installs Python 3.10+
#   4. Creates a virtual environment
#   5. Installs Python dependencies
#   6. Runs the structural validator as a smoke test
#   7. Checks for LLM provider credentials (optional)

set -euo pipefail

# ---------------------------------------------------------------------------
# Colors and helpers
# ---------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

pass()  { echo -e "  ${GREEN}✓${NC} $1"; }
fail()  { echo -e "  ${RED}✗${NC} $1"; }
warn()  { echo -e "  ${YELLOW}!${NC} $1"; }
info()  { echo -e "  ${BLUE}→${NC} $1"; }
header() { echo -e "\n${BLUE}$1${NC}"; }

CHECK_ONLY=false
if [[ "${1:-}" == "--check" ]]; then
    CHECK_ONLY=true
fi

ERRORS=0
WARNINGS=0

# ---------------------------------------------------------------------------
# Detect script location (repo root)
# ---------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# ---------------------------------------------------------------------------
# 1. OS Detection
# ---------------------------------------------------------------------------
header "1. System Check"

OS="unknown"
case "$(uname -s)" in
    Darwin*)  OS="macos";;
    Linux*)   OS="linux";;
    MINGW*|MSYS*|CYGWIN*) OS="windows";;
esac

if [[ "$OS" == "unknown" ]]; then
    fail "Unsupported OS: $(uname -s)"
    echo "  This script supports macOS, Linux, and Windows (Git Bash/WSL2)."
    exit 1
fi

pass "OS: $(uname -s) ($OS)"
pass "Shell: $SHELL"
pass "Architecture: $(uname -m)"

# ---------------------------------------------------------------------------
# 2. Homebrew (macOS only)
# ---------------------------------------------------------------------------
if [[ "$OS" == "macos" ]]; then
    header "2. Homebrew (macOS package manager)"

    if command -v brew &>/dev/null; then
        pass "Homebrew installed: $(brew --version | head -1)"
    else
        if $CHECK_ONLY; then
            fail "Homebrew not installed"
            echo "  Install: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
            ERRORS=$((ERRORS + 1))
        else
            info "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

            # Add to PATH for Apple Silicon Macs
            if [[ -f /opt/homebrew/bin/brew ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi

            if command -v brew &>/dev/null; then
                pass "Homebrew installed successfully"
            else
                fail "Homebrew installation failed"
                echo "  Visit https://brew.sh for manual installation."
                ERRORS=$((ERRORS + 1))
            fi
        fi
    fi
fi

# ---------------------------------------------------------------------------
# 3. Git
# ---------------------------------------------------------------------------
header "3. Git"

if command -v git &>/dev/null; then
    pass "Git installed: $(git --version)"
else
    if $CHECK_ONLY; then
        fail "Git not installed"
        ERRORS=$((ERRORS + 1))
    else
        info "Installing Git..."
        if [[ "$OS" == "macos" ]]; then
            # This triggers Xcode Command Line Tools install if needed
            xcode-select --install 2>/dev/null || true
            echo "  If prompted, click 'Install' in the dialog and wait for it to finish."
            echo "  Then re-run this script."
            exit 0
        elif [[ "$OS" == "linux" ]]; then
            sudo apt-get update -qq && sudo apt-get install -y -qq git
        fi

        if command -v git &>/dev/null; then
            pass "Git installed: $(git --version)"
        else
            fail "Git installation failed"
            ERRORS=$((ERRORS + 1))
        fi
    fi
fi

# Check git config
GIT_NAME=$(git config --global user.name 2>/dev/null || echo "")
GIT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")

if [[ -n "$GIT_NAME" ]]; then
    pass "Git user.name: $GIT_NAME"
else
    if $CHECK_ONLY; then
        warn "Git user.name not set (needed for commits)"
        WARNINGS=$((WARNINGS + 1))
    else
        echo ""
        read -rp "  Enter your name for Git commits: " GIT_NAME
        if [[ -n "$GIT_NAME" ]]; then
            git config --global user.name "$GIT_NAME"
            pass "Git user.name set: $GIT_NAME"
        else
            warn "Skipped — you can set it later: git config --global user.name \"Your Name\""
            WARNINGS=$((WARNINGS + 1))
        fi
    fi
fi

if [[ -n "$GIT_EMAIL" ]]; then
    pass "Git user.email: $GIT_EMAIL"
else
    if $CHECK_ONLY; then
        warn "Git user.email not set (needed for commits)"
        WARNINGS=$((WARNINGS + 1))
    else
        echo ""
        read -rp "  Enter your email for Git commits: " GIT_EMAIL
        if [[ -n "$GIT_EMAIL" ]]; then
            git config --global user.email "$GIT_EMAIL"
            pass "Git user.email set: $GIT_EMAIL"
        else
            warn "Skipped — you can set it later: git config --global user.email \"you@example.com\""
            WARNINGS=$((WARNINGS + 1))
        fi
    fi
fi


# ---------------------------------------------------------------------------
# 4. Python 3.10+
# ---------------------------------------------------------------------------
header "4. Python 3.10+"

# Find the best available Python
PYTHON_CMD=""
for cmd in python3.13 python3.12 python3.11 python3.10 python3; do
    if command -v "$cmd" &>/dev/null; then
        PY_VERSION=$("$cmd" --version 2>&1 | grep -oE '[0-9]+\.[0-9]+')
        PY_MAJOR=$(echo "$PY_VERSION" | cut -d. -f1)
        PY_MINOR=$(echo "$PY_VERSION" | cut -d. -f2)
        if [[ "$PY_MAJOR" -ge 3 && "$PY_MINOR" -ge 10 ]]; then
            PYTHON_CMD="$cmd"
            break
        fi
    fi
done

# Also check Homebrew Python on macOS (might not be in PATH yet)
if [[ -z "$PYTHON_CMD" && "$OS" == "macos" ]]; then
    for brew_py in /opt/homebrew/bin/python3.13 /opt/homebrew/bin/python3.12 /opt/homebrew/bin/python3.11 /opt/homebrew/bin/python3.10 /usr/local/bin/python3.13 /usr/local/bin/python3.12 /usr/local/bin/python3.11 /usr/local/bin/python3.10; do
        if [[ -x "$brew_py" ]]; then
            PY_VERSION=$("$brew_py" --version 2>&1 | grep -oE '[0-9]+\.[0-9]+')
            PY_MAJOR=$(echo "$PY_VERSION" | cut -d. -f1)
            PY_MINOR=$(echo "$PY_VERSION" | cut -d. -f2)
            if [[ "$PY_MAJOR" -ge 3 && "$PY_MINOR" -ge 10 ]]; then
                PYTHON_CMD="$brew_py"
                break
            fi
        fi
    done
fi

if [[ -n "$PYTHON_CMD" ]]; then
    pass "Python found: $($PYTHON_CMD --version) ($PYTHON_CMD)"
else
    if $CHECK_ONLY; then
        fail "Python 3.10+ not found (macOS ships with 3.9 which is too old)"
        echo "  Install: brew install python"
        ERRORS=$((ERRORS + 1))
    else
        info "Installing Python via Homebrew..."
        if [[ "$OS" == "macos" ]]; then
            if command -v brew &>/dev/null; then
                brew install python
                # Find the newly installed Python
                for brew_py in /opt/homebrew/bin/python3 /usr/local/bin/python3; do
                    if [[ -x "$brew_py" ]]; then
                        PYTHON_CMD="$brew_py"
                        break
                    fi
                done
            else
                fail "Homebrew not available — install it first (step 2)"
                ERRORS=$((ERRORS + 1))
            fi
        elif [[ "$OS" == "linux" ]]; then
            sudo apt-get update -qq && sudo apt-get install -y -qq python3 python3-pip python3-venv
            PYTHON_CMD="python3"
        fi

        if [[ -n "$PYTHON_CMD" ]]; then
            pass "Python installed: $($PYTHON_CMD --version)"
        else
            fail "Python installation failed"
            echo "  Install manually: https://www.python.org/downloads/"
            ERRORS=$((ERRORS + 1))
        fi
    fi
fi

# Check for venv module
if [[ -n "$PYTHON_CMD" ]]; then
    if $PYTHON_CMD -m venv --help &>/dev/null; then
        pass "venv module available"
    else
        if [[ "$OS" == "linux" ]]; then
            if $CHECK_ONLY; then
                fail "Python venv module not installed"
                echo "  Install: sudo apt install python3-venv"
                ERRORS=$((ERRORS + 1))
            else
                info "Installing python3-venv..."
                sudo apt-get install -y -qq python3-venv
                pass "venv module installed"
            fi
        else
            fail "Python venv module not available"
            ERRORS=$((ERRORS + 1))
        fi
    fi
fi


# ---------------------------------------------------------------------------
# 5. Virtual Environment and Dependencies
# ---------------------------------------------------------------------------
header "5. Virtual Environment & Dependencies"

VENV_DIR="$SCRIPT_DIR/.venv"

if [[ -z "$PYTHON_CMD" ]]; then
    fail "Skipping — Python 3.10+ not available"
    ERRORS=$((ERRORS + 1))
elif $CHECK_ONLY; then
    if [[ -d "$VENV_DIR" ]]; then
        pass "Virtual environment exists: $VENV_DIR"
        # Check if deps are installed
        if "$VENV_DIR/bin/python" -c "import strands, fastmcp, rich" 2>/dev/null; then
            pass "All Python dependencies installed"
        else
            warn "Some dependencies missing — run ./setup.sh to install"
            WARNINGS=$((WARNINGS + 1))
        fi
    else
        warn "Virtual environment not created yet — run ./setup.sh to create"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    # Create venv if it doesn't exist
    if [[ ! -d "$VENV_DIR" ]]; then
        info "Creating virtual environment..."
        $PYTHON_CMD -m venv "$VENV_DIR"
        pass "Virtual environment created: $VENV_DIR"
    else
        pass "Virtual environment exists: $VENV_DIR"
    fi

    # Upgrade pip
    info "Upgrading pip..."
    "$VENV_DIR/bin/python" -m pip install --upgrade pip --quiet
    pass "pip upgraded: $("$VENV_DIR/bin/pip" --version | cut -d' ' -f2)"

    # Install dependencies
    info "Installing dependencies..."
    "$VENV_DIR/bin/pip" install -r "$SCRIPT_DIR/agent/requirements.txt" --quiet
    pass "All dependencies installed"
fi

# ---------------------------------------------------------------------------
# 6. Smoke Test
# ---------------------------------------------------------------------------
header "6. Smoke Test"

if [[ -d "$VENV_DIR" ]] && [[ -n "$PYTHON_CMD" ]]; then
    # Test 1: validator
    info "Running structural validator against quickstart example..."
    if "$VENV_DIR/bin/python" "$SCRIPT_DIR/agent/validate_config.py" --path "$SCRIPT_DIR/examples/quickstart" 2>&1 | grep -q "ALL 17 CHECKS PASSED"; then
        pass "Validator: ALL 17 CHECKS PASSED"
    else
        fail "Validator did not pass — check output above"
        ERRORS=$((ERRORS + 1))
    fi

    # Test 2: imports
    info "Checking module imports..."
    if "$VENV_DIR/bin/python" -c "
import sys
sys.path.insert(0, '$SCRIPT_DIR/agent')
import config
import tools
import main
import mcp_server
import eval_harness
print('ok')
" 2>/dev/null | grep -q "ok"; then
        pass "All agent modules import successfully"
    else
        fail "Some modules failed to import"
        ERRORS=$((ERRORS + 1))
    fi
elif $CHECK_ONLY; then
    warn "Skipping smoke test — virtual environment not set up"
    WARNINGS=$((WARNINGS + 1))
else
    fail "Skipping smoke test — setup incomplete"
    ERRORS=$((ERRORS + 1))
fi


# ---------------------------------------------------------------------------
# 7. LLM Provider Check (informational only)
# ---------------------------------------------------------------------------
header "7. LLM Provider (optional — needed for running the agent)"

LLM_FOUND=false

# Check AWS Bedrock
if command -v aws &>/dev/null; then
    AWS_IDENTITY=$(aws sts get-caller-identity 2>/dev/null || echo "")
    if [[ -n "$AWS_IDENTITY" ]]; then
        pass "AWS credentials configured (Bedrock — default provider)"
        LLM_FOUND=true
    else
        warn "AWS CLI installed but credentials not configured"
        echo "    Run: aws configure"
    fi
else
    info "AWS CLI not installed (needed for Bedrock, the default provider)"
    if [[ "$OS" == "macos" ]]; then
        echo "    Install: brew install awscli"
    fi
fi

# Check OpenAI
if [[ -n "${OPENAI_API_KEY:-}" ]]; then
    pass "OpenAI API key set (OPENAI_API_KEY)"
    LLM_FOUND=true
else
    info "OPENAI_API_KEY not set"
    echo "    Get a key: https://platform.openai.com/api-keys"
    echo "    Set it: export OPENAI_API_KEY=\"sk-...\""
fi

# Check Anthropic
if [[ -n "${ANTHROPIC_API_KEY:-}" ]]; then
    pass "Anthropic API key set (ANTHROPIC_API_KEY)"
    LLM_FOUND=true
else
    info "ANTHROPIC_API_KEY not set"
    echo "    Get a key: https://console.anthropic.com/"
    echo "    Set it: export ANTHROPIC_API_KEY=\"sk-ant-...\""
fi

if ! $LLM_FOUND; then
    warn "No LLM provider configured"
    echo "    You need at least one to run the agent, eval harness, or full validator."
    echo "    The templates and structural validator work without LLM access."
    WARNINGS=$((WARNINGS + 1))
fi

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
header "Setup Complete"
echo ""

if [[ $ERRORS -gt 0 ]]; then
    fail "$ERRORS error(s) found — fix them and re-run ./setup.sh"
    exit 1
elif [[ $WARNINGS -gt 0 ]]; then
    warn "$WARNINGS warning(s) — everything works but some optional items need attention"
else
    pass "Everything is set up and working"
fi

echo ""
echo "Next steps:"
echo "  1. Activate the virtual environment:"
echo "       source .venv/bin/activate"
echo ""
echo "  2. Follow the tutorial:"
echo "       docs/tutorial.md"
echo ""
echo "  3. Or run the agent directly:"
echo "       cd agent"
echo "       python main.py --persona devops"
echo ""
