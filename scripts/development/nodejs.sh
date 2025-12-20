#!/bin/bash

# Node.js and npm Installation Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/scripts/utils/logger.sh"
source "$SCRIPT_DIR/scripts/utils/common.sh"

# Install Node.js and npm
install_nodejs() {
    log_header "Installing Node.js and npm"
    
    if command_exists node; then
        log_info "Node.js is already installed: $(node --version)"
        log_info "npm version: $(npm --version)"
        return 0
    fi
    
    local os=$(detect_os)
    
    case $os in
        "ubuntu")
            # Install Node.js LTS from NodeSource
            log_info "Adding NodeSource repository..."
            curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
            
            log_info "Installing Node.js..."
            sudo apt-get install -y nodejs
            ;;
        "centos"|"fedora")
            curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
            sudo yum install -y nodejs
            ;;
        "arch")
            sudo pacman -S --noconfirm nodejs npm
            ;;
        "macos")
            brew install node
            ;;
        *)
            log_error "Unsupported OS for Node.js installation"
            return 1
            ;;
    esac
    
    log_success "Node.js and npm installed successfully"
}

# Update npm to latest version
update_npm() {
    log_info "Updating npm to latest version..."
    sudo npm install -g npm@latest
    log_success "npm updated to $(npm --version)"
}

# Install Yarn
install_yarn() {
    log_header "Installing Yarn"
    
    if command_exists yarn; then
        log_info "Yarn is already installed: $(yarn --version)"
        return 0
    fi
    
    local os=$(detect_os)
    
    case $os in
        "ubuntu")
            # Add Yarn repository
            curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
            echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
            
            sudo apt-get update
            sudo apt-get install -y yarn
            ;;
        "centos"|"fedora")
            curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
            sudo yum install -y yarn
            ;;
        "arch")
            sudo pacman -S --noconfirm yarn
            ;;
        "macos")
            brew install yarn
            ;;
        *)
            # Fallback to npm install
            log_warning "Installing Yarn via npm..."
            sudo npm install -g yarn
            ;;
    esac
    
    log_success "Yarn installed successfully"
}

main() {
    log_header "Node.js Setup"
    
    install_nodejs
    update_npm
    install_yarn
    
    log_success "Node.js setup completed"
    log_info "Node.js version: $(node --version)"
    log_info "npm version: $(npm --version)"
    log_info "Yarn version: $(yarn --version)"
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    main "$@"
fi
