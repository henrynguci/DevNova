#!/bin/bash

# Neovim Installation and Configuration Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/scripts/utils/logger.sh"
source "$SCRIPT_DIR/scripts/utils/common.sh"

# Install Neovim
install_neovim() {
    log_header "Installing Neovim"
    
    if command_exists nvim; then
        log_info "Neovim is already installed: $(nvim --version | head -1)"
        return 0
    fi
    
    local os=$(detect_os)
    
    case $os in
        "ubuntu")
            # Add Neovim PPA for latest version
            sudo add-apt-repository -y ppa:neovim-ppa/unstable
            sudo apt-get update
            sudo apt-get install -y neovim
            ;;
        "centos"|"fedora")
            sudo yum install -y neovim python3-neovim
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
    
    log_success "Neovim installed successfully"
}

# Install ripgrep for telescope
install_ripgrep() {
    if command_exists rg; then
        log_debug "ripgrep is already installed"
        return 0
    fi
    
    log_info "Installing ripgrep..."
    install_package ripgrep
}

# Install fd for telescope
install_fd() {
    if command_exists fd || command_exists fdfind; then
        log_debug "fd is already installed"
        return 0
    fi
    
    log_info "Installing fd..."
    local os=$(detect_os)
    
    case $os in
        "ubuntu")
            sudo apt-get install -y fd-find
            sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd 2>/dev/null || true
            ;;
        *)
            install_package fd
            ;;
    esac
}

# Install bat for better file preview
install_bat() {
    if command_exists bat || command_exists batcat; then
        log_debug "bat is already installed"
        return 0
    fi
    
    log_info "Installing bat..."
    local os=$(detect_os)
    
    case $os in
        "ubuntu")
            sudo apt-get install -y bat
            sudo ln -sf /usr/bin/batcat /usr/local/bin/bat 2>/dev/null || true
            ;;
        *)
            install_package bat
            ;;
    esac
}

# Install LSP servers
install_lsp_servers() {
    log_header "Installing LSP Servers"
    
    # TypeScript/JavaScript
    if command_exists npm; then
        log_info "Installing TypeScript LSP..."
        sudo npm install -g typescript-language-server typescript
        
        log_info "Installing ESLint and Prettier LSP..."
        sudo npm install -g vscode-langservers-extracted
    fi
    
    # Python
    if command_exists python3; then
        log_info "Installing Python LSP (pyright)..."
        python3 -m pip install --user pyright
    fi
    
    # Lua (for Neovim config)
    local os=$(detect_os)
    if [ "$os" = "arch" ]; then
        sudo pacman -S --noconfirm lua-language-server
    elif [ "$os" = "macos" ]; then
        brew install lua-language-server
    fi
    
    log_success "LSP servers installed"
}

# Setup Neovim configuration
setup_neovim_config() {
    log_header "Setting up Neovim Configuration"
    
    local nvim_config="$HOME/.config/nvim"
    
    # Backup existing config
    if [ -d "$nvim_config" ]; then
        create_backup "$nvim_config"
    fi
    
    # Create config directory
    mkdir -p "$nvim_config"
    
    # Note: Users should add their own Neovim configuration
    log_info "Neovim config directory created at: $nvim_config"
    log_info "You can add your own init.lua or init.vim configuration"
    
    # Install Packer (plugin manager)
    install_packer
}

# Install Packer plugin manager
install_packer() {
    local packer_dir="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
    
    if [ -d "$packer_dir" ]; then
        log_debug "Packer is already installed"
        return 0
    fi
    
    log_info "Installing Packer plugin manager..."
    git clone --depth 1 https://github.com/wbthomason/packer.nvim "$packer_dir"
    log_success "Packer installed"
}

main() {
    log_header "Neovim Setup"
    
    install_neovim
    install_ripgrep
    install_fd
    install_bat
    
    if confirm "Do you want to install LSP servers?" "y"; then
        install_lsp_servers
    fi
    
    setup_neovim_config
    
    log_success "Neovim setup completed"
    log_info "Run 'nvim' to start Neovim"
    log_info "Add your configuration to ~/.config/nvim/"
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    main "$@"
fi
