#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/scripts/utils/logger.sh"
source "$SCRIPT_DIR/scripts/utils/common.sh"

install_neovim() {
    log_header "Installing Neovim"
    
    if command_exists nvim; then
        log_info "Neovim is already installed: $(nvim --version | head -1)"
        return 0
    fi
    
    local os=$(detect_os)
    
    case $os in
        "ubuntu")
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

install_ripgrep() {
    if command_exists rg; then
        log_debug "ripgrep is already installed"
        return 0
    fi
    
    log_info "Installing ripgrep..."
    install_package ripgrep
}

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

install_lsp_servers() {
    log_header "Installing LSP Servers"
    
    if command_exists npm; then
        log_info "Installing TypeScript LSP..."
        sudo npm install -g typescript-language-server typescript
        
        log_info "Installing ESLint and Prettier LSP..."
        sudo npm install -g vscode-langservers-extracted
        
        log_info "Installing Bash LSP..."
        sudo npm install -g bash-language-server
        
        log_info "Installing Docker LSP..."
        sudo npm install -g dockerfile-language-server-nodejs
        
        log_info "Installing YAML LSP..."
        sudo npm install -g yaml-language-server
        
        log_info "Installing JSON LSP..."
        sudo npm install -g vscode-json-languageserver
    fi
    
    if command_exists python3; then
        log_info "Installing Python LSP (pyright)..."
        python3 -m pip install --user pyright
    fi
    
    if command_exists go; then
        log_info "Installing Go LSP..."
        go install golang.org/x/tools/gopls@latest
    fi
    
    if command_exists cargo; then
        log_info "Installing Rust Analyzer..."
        rustup component add rust-analyzer
    fi
    
    local os=$(detect_os)
    if [ "$os" = "arch" ]; then
        sudo pacman -S --noconfirm lua-language-server
    elif [ "$os" = "macos" ]; then
        brew install lua-language-server
    fi
    
    log_success "LSP servers installed"
}

setup_neovim_config() {
    log_header "Setting up Neovim Configuration"
    
    local nvim_config="$HOME/.config/nvim"
    
    if [ -d "$nvim_config" ]; then
        create_backup "$nvim_config"
    fi
    
    mkdir -p "$nvim_config"
    
    log_info "Neovim config directory created at: $nvim_config"
    log_info "You can add your own init.lua or init.vim configuration"
    
    install_lazy_nvim
}

install_lazy_nvim() {
    local lazy_dir="$HOME/.local/share/nvim/lazy/lazy.nvim"
    
    if [ -d "$lazy_dir" ]; then
        log_debug "Lazy.nvim is already installed"
        return 0
    fi
    
    log_info "Installing Lazy.nvim plugin manager..."
    git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$lazy_dir"
    log_success "Lazy.nvim installed"
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
