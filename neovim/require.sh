#!/bin/bash

# =============================================================================
# Neovim Configuration Setup Script
# Description: Script to install and configure Neovim with plugins and dependencies
# Author: Mhung
# Created: $(date +"%Y-%m-%d")
# =============================================================================

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Configuration paths
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly NVIM_CONFIG_DIR="$HOME/.config/nvim"
readonly BACKUP_DIR="$HOME/.config/nvim_backup_$(date +%Y%m%d_%H%M%S)"

# Array to store selected options
declare -a selected_options=()

# =============================================================================
# Utility Functions
# =============================================================================

# Colored logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_header() {
    echo -e "${PURPLE}================================${NC}"
    echo -e "${PURPLE} $1${NC}"
    echo -e "${PURPLE}================================${NC}"
}

# OS detection function
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get >/dev/null 2>&1; then
            echo "ubuntu"
        elif command -v yum >/dev/null 2>&1; then
            echo "centos"
        elif command -v pacman >/dev/null 2>&1; then
            echo "arch"
        elif command -v dnf >/dev/null 2>&1; then
            echo "fedora"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

# Check and install dependencies
check_dependencies() {
    local deps=("curl" "wget" "git" "unzip")
    local missing_deps=()

    log_info "Checking dependencies..."

    for dep in "${deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            missing_deps+=("$dep")
        fi
    done

    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_warning "Missing dependencies: ${missing_deps[*]}"
        install_dependencies "${missing_deps[@]}"
    else
        log_success "All dependencies are installed"
    fi
}

# Install dependencies based on OS
install_dependencies() {
    local deps=("$@")
    local os=$(detect_os)

    log_info "Installing dependencies for $os..."

    case $os in
        "ubuntu")
            sudo apt-get update
            sudo apt-get install -y "${deps[@]}"
            ;;
        "centos")
            sudo yum install -y "${deps[@]}"
            ;;
        "fedora")
            sudo dnf install -y "${deps[@]}"
            ;;
        "arch")
            sudo pacman -S --noconfirm "${deps[@]}"
            ;;
        "macos")
            if command -v brew >/dev/null 2>&1; then
                brew install "${deps[@]}"
            else
                log_error "Homebrew is not installed. Please install Homebrew first."
                exit 1
            fi
            ;;
        *)
            log_error "Unsupported OS: $os"
            exit 1
            ;;
    esac
}

# Backup existing configuration
backup_existing_config() {
    if [ -d "$NVIM_CONFIG_DIR" ]; then
        log_warning "Existing Neovim configuration detected"
        read -p "Do you want to backup the existing configuration? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log_info "Backing up existing configuration to $BACKUP_DIR..."
            mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
            log_success "Backup completed: $BACKUP_DIR"
        else
            log_warning "Removing existing configuration..."
            rm -rf "$NVIM_CONFIG_DIR"
        fi
    fi
}

# =============================================================================
# Installation Functions
# =============================================================================

# Install Neovim
install_neovim() {
    log_header "Installing Neovim"

    local os=$(detect_os)

    case $os in
        "ubuntu")
            # Install latest Neovim
            sudo add-apt-repository ppa:neovim-ppa/unstable -y
            sudo apt-get update
            sudo apt-get install -y neovim
            ;;
        "centos")
            sudo yum install -y epel-release
            sudo yum install -y neovim python3-neovim
            ;;
        "fedora")
            sudo dnf install -y neovim python3-neovim
            ;;
        "arch")
            sudo pacman -S --noconfirm neovim
            ;;
        "macos")
            brew install neovim
            ;;
        *)
            log_error "Unsupported OS for Neovim installation"
            return 1
            ;;
    esac

    log_success "Neovim has been installed"
}

# Install Node.js and npm (for LSP)
install_nodejs() {
    log_header "Installing Node.js and npm"

    if command -v node >/dev/null 2>&1; then
        log_info "Node.js is already installed: $(node --version)"
        return 0
    fi

    local os=$(detect_os)

    case $os in
        "ubuntu")
            curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
            sudo apt-get install -y nodejs
            ;;
        "centos")
            curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
            sudo yum install -y nodejs npm
            ;;
        "fedora")
            curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
            sudo dnf install -y nodejs npm
            ;;
        "arch")
            sudo pacman -S --noconfirm nodejs npm
            ;;
        "macos")
            brew install node
            ;;
    esac

    log_success "Node.js and npm have been installed"
}

# Install Python and pip
install_python() {
    log_header "Installing Python and pip"

    if command -v python3 >/dev/null 2>&1; then
        log_info "Python3 is already installed: $(python3 --version)"
    else
        local os=$(detect_os)
        case $os in
            "ubuntu")
                sudo apt-get install -y python3 python3-pip
                ;;
            "centos")
                sudo yum install -y python3 python3-pip
                ;;
            "fedora")
                sudo dnf install -y python3 python3-pip
                ;;
            "arch")
                sudo pacman -S --noconfirm python python-pip
                ;;
            "macos")
                brew install python
                ;;
        esac
    fi

    # Install pynvim
    pip3 install --user pynvim
    log_success "Python support for Neovim has been installed"
}

# Install Ripgrep (for telescope)
install_ripgrep() {
    log_header "Installing Ripgrep"

    if command -v rg >/dev/null 2>&1; then
        log_info "Ripgrep is already installed"
        return 0
    fi

    local os=$(detect_os)

    case $os in
        "ubuntu")
            sudo apt-get install -y ripgrep
            ;;
        "centos")
            sudo yum install -y ripgrep
            ;;
        "fedora")
            sudo dnf install -y ripgrep
            ;;
        "arch")
            sudo pacman -S --noconfirm ripgrep
            ;;
        "macos")
            brew install ripgrep
            ;;
    esac

    log_success "Ripgrep has been installed"
}

# Install fd (for telescope)
install_fd() {
    log_header "Installing fd"

    if command -v fd >/dev/null 2>&1; then
        log_info "fd is already installed"
        return 0
    fi

    local os=$(detect_os)

    case $os in
        "ubuntu")
            sudo apt-get install -y fd-find
            # Create symlink for fd command
            sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd
            ;;
        "centos")
            sudo yum install -y fd-find
            ;;
        "fedora")
            sudo dnf install -y fd-find
            ;;
        "arch")
            sudo pacman -S --noconfirm fd
            ;;
        "macos")
            brew install fd
            ;;
    esac

    log_success "fd has been installed"
}

# Install additional tools
install_additional_tools() {
    log_header "Installing Additional Tools"

    local os=$(detect_os)
    local tools=()

    # Add tools based on OS
    case $os in
        "ubuntu"|"fedora")
            tools+=("tree" "htop" "bat" "exa")
            ;;
        "centos")
            tools+=("tree" "htop")
            ;;
        "arch")
            tools+=("tree" "htop" "bat" "exa")
            ;;
        "macos")
            tools+=("tree" "htop" "bat" "exa")
            ;;
    esac

    for tool in "${tools[@]}"; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            log_info "Installing $tool..."
            case $os in
                "ubuntu")
                    sudo apt-get install -y "$tool"
                    ;;
                "centos")
                    sudo yum install -y "$tool"
                    ;;
                "fedora")
                    sudo dnf install -y "$tool"
                    ;;
                "arch")
                    sudo pacman -S --noconfirm "$tool"
                    ;;
                "macos")
                    brew install "$tool"
                    ;;
            esac
        fi
    done

    log_success "Additional tools have been installed"
}

# Copy Neovim configuration
setup_neovim_config() {
    log_header "Setting up Neovim Configuration"

    # Create configuration directory
    mkdir -p "$NVIM_CONFIG_DIR"

    # Copy configuration from current directory
    if [ -d "$SCRIPT_DIR" ]; then
        log_info "Copying configuration from $SCRIPT_DIR to $NVIM_CONFIG_DIR..."

        # Copy all files except the require.sh script itself
        find "$SCRIPT_DIR" -maxdepth 1 -type f ! -name "require.sh" -exec cp {} "$NVIM_CONFIG_DIR/" \;

        # Copy all subdirectories
        find "$SCRIPT_DIR" -maxdepth 1 -type d ! -path "$SCRIPT_DIR" -exec cp -r {} "$NVIM_CONFIG_DIR/" \;

        log_success "Neovim configuration has been copied"
    else
        log_error "Configuration directory not found: $SCRIPT_DIR"
        return 1
    fi

    # Install Packer (plugin manager)
    install_packer
}

# Install Packer
install_packer() {
    log_info "Installing Packer (Plugin Manager)..."

    local packer_dir="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"

    if [ ! -d "$packer_dir" ]; then
        git clone --depth 1 https://github.com/wbthomason/packer.nvim "$packer_dir"
        log_success "Packer has been installed"
    else
        log_info "Packer already exists"
    fi
}

# Install LSP servers
install_lsp_servers() {
    log_header "Installing LSP Servers"

    # Common LSP servers
    local lsp_servers=(
        "typescript-language-server"
        "vscode-langservers-extracted"
        "pyright"
        "lua-language-server"
    )

    # Install npm-based LSP servers
    for server in "typescript-language-server" "vscode-langservers-extracted"; do
        if ! npm list -g "$server" >/dev/null 2>&1; then
            log_info "Installing $server..."
            npm install -g "$server"
        else
            log_info "$server is already installed"
        fi
    done

    # Install Python LSP
    if ! pip3 show pyright >/dev/null 2>&1; then
        log_info "Installing pyright..."
        pip3 install --user pyright
    else
        log_info "pyright is already installed"
    fi

    # Install Lua LSP (if available)
    local os=$(detect_os)
    case $os in
        "ubuntu"|"fedora")
            if ! command -v lua-language-server >/dev/null 2>&1; then
                log_info "Installing lua-language-server..."
                # This might need manual installation depending on the system
            fi
            ;;
        "arch")
            if ! command -v lua-language-server >/dev/null 2>&1; then
                sudo pacman -S --noconfirm lua-language-server
            fi
            ;;
        "macos")
            if ! command -v lua-language-server >/dev/null 2>&1; then
                brew install lua-language-server
            fi
            ;;
    esac

    # Install additional language servers if compilers are available
    if command -v rustup >/dev/null 2>&1; then
        log_info "Installing rust-analyzer..."
        rustup component add rust-analyzer
    fi

    if command -v go >/dev/null 2>&1; then
        log_info "Installing gopls..."
        go install golang.org/x/tools/gopls@latest
    fi

    log_success "LSP servers have been installed"
}

# Install fonts for better terminal experience
install_fonts() {
    log_header "Installing Nerd Fonts"

    local font_dir="$HOME/.local/share/fonts"
    mkdir -p "$font_dir"

    # Download and install JetBrains Mono Nerd Font
    if [ ! -f "$font_dir/JetBrains Mono Regular Nerd Font Complete.ttf" ]; then
        log_info "Downloading JetBrains Mono Nerd Font..."
        wget -O /tmp/JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
        unzip -o /tmp/JetBrainsMono.zip -d "$font_dir"
        rm /tmp/JetBrainsMono.zip

        # Refresh font cache
        if command -v fc-cache >/dev/null 2>&1; then
            fc-cache -fv
        fi

        log_success "JetBrains Mono Nerd Font has been installed"
    else
        log_info "Nerd Font is already installed"
    fi
}

# =============================================================================
# Menu Functions
# =============================================================================

# Display menu
show_menu() {
    clear
    log_header "NEOVIM SETUP SCRIPT"
    echo -e "${CYAN}Select installation options (multiple choices separated by spaces):${NC}"
    echo
    echo "1) Install Neovim"
    echo "2) Install Dependencies (Node.js, Python, Ripgrep, fd)"
    echo "3) Setup Neovim Configuration"
    echo "4) Install LSP Servers"
    echo "5) Install Additional Tools (tree, htop, bat, exa)"
    echo "6) Install Nerd Fonts"
    echo "7) Install Everything"
    echo "8) Execute Selected Options"
    echo "9) Show System Status"
    echo "0) Exit"
    echo
    if [ ${#selected_options[@]} -gt 0 ]; then
        echo -e "${YELLOW}Selected options: ${selected_options[*]}${NC}"
    fi
    echo
}

# Show system status
show_system_status() {
    log_header "System Status"

    echo "OS: $(detect_os)"
    echo "Neovim: $(command -v nvim >/dev/null 2>&1 && nvim --version | head -1 || echo "Not installed")"
    echo "Node.js: $(command -v node >/dev/null 2>&1 && node --version || echo "Not installed")"
    echo "Python3: $(command -v python3 >/dev/null 2>&1 && python3 --version || echo "Not installed")"
    echo "Git: $(command -v git >/dev/null 2>&1 && git --version || echo "Not installed")"
    echo "Ripgrep: $(command -v rg >/dev/null 2>&1 && echo "Installed" || echo "Not installed")"
    echo "fd: $(command -v fd >/dev/null 2>&1 && echo "Installed" || echo "Not installed")"
    echo "Neovim Config: $([ -d "$NVIM_CONFIG_DIR" ] && echo "Present" || echo "Not found")"
    echo "Packer: $([ -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ] && echo "Installed" || echo "Not installed")"

    read -p "Press Enter to continue..."
}

# Execute selected options
execute_selected_options() {
    if [ ${#selected_options[@]} -eq 0 ]; then
        log_warning "No options selected."
        return 1
    fi

    log_header "Executing Selected Options"

    # Check dependencies first
    check_dependencies

    for option in "${selected_options[@]}"; do
        case $option in
            1) install_neovim ;;
            2)
                install_nodejs
                install_python
                install_ripgrep
                install_fd
                ;;
            3)
                backup_existing_config
                setup_neovim_config
                ;;
            4) install_lsp_servers ;;
            5) install_additional_tools ;;
            6) install_fonts ;;
        esac
    done

    selected_options=() # Clear selected options after execution
    log_success "All selected options have been executed."

    echo
    log_info "To complete the setup, open Neovim and run:"
    echo -e "${GREEN}:PackerSync${NC}"
    echo
    log_info "You may also want to restart your terminal to apply font changes."

    read -p "Press Enter to continue..."
}

# =============================================================================
# Main Script
# =============================================================================

main() {
    # Check if running as root
    if [[ $EUID -eq 0 ]]; then
        log_error "This script should not be run as root"
        exit 1
    fi

    # Check if running in correct directory
    if [ ! -f "$SCRIPT_DIR/require.sh" ]; then
        log_error "Please run this script from your Neovim configuration directory"
        exit 1
    fi

    while true; do
        show_menu
        read -p "Enter your choice(s): " choices

        for choice in $choices; do
            case $choice in
                1|2|3|4|5|6)
                    if [[ ! " ${selected_options[@]} " =~ " ${choice} " ]]; then
                        selected_options+=("$choice")
                        log_success "Added option $choice to the list."
                    else
                        log_warning "Option $choice is already selected."
                    fi
                    ;;
                7)
                    selected_options=(1 2 3 4 5 6)
                    log_success "Selected all options."
                    ;;
                8)
                    execute_selected_options
                    ;;
                9)
                    show_system_status
                    ;;
                0)
                    log_info "Exiting the program."
                    exit 0
                    ;;
                *)
                    log_error "Invalid choice: $choice. Please try again."
                    ;;
            esac
        done

        sleep 1
    done
}

# Run main script
main "$@"
