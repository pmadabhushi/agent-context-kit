#!/usr/bin/env bash
#
# Agent Context Kit — Environment Setup
# ======================================
# Sets up everything you need to run the agent, MCP server, eval harness,
# and tutorial validator. Safe to run multiple times (idempotent).
#
# Supports: macOS (Intel & Apple Silicon), Ubuntu/Debian, Fedora/RHEL, Arch Linux
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
# Detect Linux package manager
# ---------------------------------------------------------------------------
PKG_MGR="unknown"
pkg_install() {
    case "$PKG_MGR" in
        apt)    sudo apt-get install -y -qq "$@" ;;
        dnf)    sudo dnf install -y -q "$@" ;;
        yum)    sudo yum install -y -q "$@" ;;
        pacman) sudo pacman -S --noconfirm "$@" ;;
        *)      fail "No supported package manager found (tried apt, dnf, yum, pacman)"
                return 1 ;;
    esac
}

pkg_update() {
    case "$PKG_MGR" in
        apt)    sudo apt-get update -qq ;;
        dnf)    sudo dnf check-update -q || true ;;
        yum)    sudo yum check-update -q || true ;;
        pacman) sudo pacman -Sy --noconfirm ;;
        *)      return 1 ;;
    esac
}

detect_pkg_manager() {
    if command -v apt-get &>/dev/null; then PKG_MGR="apt"
    elif command -v dnf &>/dev/null; then PKG_MGR="dnf"
    elif command -v yum &>/dev/null; then PKG_MGR="yum"
    elif command -v pacman &>/dev/null; then PKG_MGR="pacman"
    fi
}

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
pass "Shell: ${SHELL:-$(basename "$(cat /proc/$$/comm 2>/dev/null || echo unknown)")}"
pass "Architecture: $(uname -m)"

if [[ "$OS" == "linux" ]]; then
    detect_pkg_manager
    if [[ "$PKG_MGR" != "unknown" ]]; then
        pass "Package manager: $PKG_MGR"
    else
        warn "No supported package manager found — you may need to install dependencies manually"
        WARNINGS=$((WARNINGS + 1))
    fi
    # Show distro info if available
    if [[ -f /etc/os-release ]]; then
        DISTRO=$(sed -n 's/^PRETTY_NAME="\(.*\)"/\1/p' /etc/os-release 2>/dev/null || echo "unknown")
        pass "Distro: $DISTRO"
    fi
fi

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
            pkg_update
            pkg_install git
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
find_python() {
    for cmd in python3.14 python3.13 python3.12 python3.11 python3.10 python3; do
        if command -v "$cmd" &>/dev/null; then
            PY_VERSION=$("$cmd" --version 2>&1 | grep -oE '[0-9]+\.[0-9]+' | head -1)
            PY_MAJOR=$(echo "$PY_VERSION" | cut -d. -f1)
            PY_MINOR=$(echo "$PY_VERSION" | cut -d. -f2)
            if [[ "$PY_MAJOR" -ge 3 && "$PY_MINOR" -ge 10 ]]; then
                echo "$cmd"
                return 0
            fi
        fi
    done

    # macOS: also check Homebrew paths (might not be in PATH yet)
    if [[ "$OS" == "macos" ]]; then
        for brew_py in /opt/homebrew/bin/python3{.14,.13,.12,.11,.10,} /usr/local/bin/python3{.14,.13,.12,.11,.10,}; do
            if [[ -x "$brew_py" ]]; then
                PY_VERSION=$("$brew_py" --version 2>&1 | grep -oE '[0-9]+\.[0-9]+' | head -1)
                PY_MAJOR=$(echo "$PY_VERSION" | cut -d. -f1)
                PY_MINOR=$(echo "$PY_VERSION" | cut -d. -f2)
                if [[ "$PY_MAJOR" -ge 3 && "$PY_MINOR" -ge 10 ]]; then
                    echo "$brew_py"
                    return 0
                fi
            fi
        done
    fi

    return 1
}

PYTHON_CMD=$(find_python || echo "")

if [[ -n "$PYTHON_CMD" ]]; then
    pass "Python found: $($PYTHON_CMD --version) ($PYTHON_CMD)"
else
    CURRENT_PY=$(python3 --version 2>&1 || echo "not installed")
    if $CHECK_ONLY; then
        fail "Python 3.10+ not found (current: $CURRENT_PY)"
        if [[ "$OS" == "macos" ]]; then
            echo "  Install: brew install python"
        elif [[ "$OS" == "linux" ]]; then
            case "$PKG_MGR" in
                apt)    echo "  Install: sudo apt install python3.12 python3.12-venv" ;;
                dnf)    echo "  Install: sudo dnf install python3.12" ;;
                pacman) echo "  Install: sudo pacman -S python" ;;
                *)      echo "  Install Python 3.10+ from https://www.python.org/downloads/" ;;
            esac
        fi
        ERRORS=$((ERRORS + 1))
    else
        info "Installing Python..."
        if [[ "$OS" == "macos" ]]; then
            if command -v brew &>/dev/null; then
                brew install python
            else
                fail "Homebrew not available — install it first (step 2)"
                ERRORS=$((ERRORS + 1))
            fi
        elif [[ "$OS" == "linux" ]]; then
            pkg_update
            case "$PKG_MGR" in
                apt)
                    # Try python3.12 first (available on Ubuntu 24.04+ and via deadsnakes)
                    if apt-cache show python3.12 &>/dev/null; then
                        pkg_install python3.12 python3.12-venv
                    else
                        # Fall back to default python3 and hope it's 3.10+
                        pkg_install python3 python3-pip python3-venv
                    fi
                    ;;
                dnf)    pkg_install python3.12 || pkg_install python3 python3-pip ;;
                pacman) pkg_install python ;;
                *)      fail "Can't auto-install Python — install 3.10+ manually" ;;
            esac
        fi

        PYTHON_CMD=$(find_python || echo "")
        if [[ -n "$PYTHON_CMD" ]]; then
            pass "Python installed: $($PYTHON_CMD --version)"
        else
            fail "Python 3.10+ installation failed"
            echo "  Your system may only have an older Python available."
            echo "  Try: https://github.com/pyenv/pyenv (any OS)"
            if [[ "$OS" == "linux" && "$PKG_MGR" == "apt" ]]; then
                echo "  Or:  https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa (Ubuntu)"
            fi
            ERRORS=$((ERRORS + 1))
        fi
    fi
fi

# Check for venv module
if [[ -n "$PYTHON_CMD" ]]; then
    if $PYTHON_CMD -m venv --help &>/dev/null; then
        pass "venv module available"
    else
        if $CHECK_ONLY; then
            fail "Python venv module not installed"
            if [[ "$OS" == "linux" ]]; then
                PY_SHORT=$($PYTHON_CMD --version 2>&1 | grep -oE '[0-9]+\.[0-9]+' | head -1)
                echo "  Install: sudo $PKG_MGR install python${PY_SHORT}-venv"
            fi
            ERRORS=$((ERRORS + 1))
        else
            if [[ "$OS" == "linux" ]]; then
                info "Installing Python venv module..."
                PY_SHORT=$($PYTHON_CMD --version 2>&1 | grep -oE '[0-9]+\.[0-9]+' | head -1)
                case "$PKG_MGR" in
                    apt)    pkg_install "python${PY_SHORT}-venv" || pkg_install python3-venv ;;
                    dnf)    pkg_install python3-libs ;;  # venv is usually included
                    pacman) pass "venv is included with python on Arch" ;;
                    *)      fail "Install the Python venv module manually" ;;
                esac
                if $PYTHON_CMD -m venv --help &>/dev/null; then
                    pass "venv module installed"
                else
                    fail "venv module still not available"
                    ERRORS=$((ERRORS + 1))
                fi
            else
                fail "Python venv module not available"
                ERRORS=$((ERRORS + 1))
            fi
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

if [[ -d "$VENV_DIR" ]] && [[ -n "${PYTHON_CMD:-}" ]]; then
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
    elif [[ "$OS" == "linux" ]]; then
        echo "    Install: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
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
