#!/bin/bash

# System Setup Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/scripts/utils/logger.sh"
source "$SCRIPT_DIR/scripts/utils/common.sh"

# Install basic system tools
install_system_tools() {
    log_header "Installing Basic System Tools"
    
    local tools=(curl wget git unzip apt-transport-https ca-certificates gnupg lsb-release build-essential xclip)
    local os=$(detect_os)
    
    # Update system first
    update_system
    
    # Install each tool
    for tool in "${tools[@]}"; do
        if ! command_exists "$tool" && ! is_installed "$tool"; then
            log_info "Installing $tool..."
            install_package "$tool"
        else
            log_debug "$tool is already installed"
        fi
    done
    
    log_success "Basic system tools installed"
}

# Upgrade system packages
upgrade_system() {
    log_header "Upgrading System Packages"
    
    local os=$(detect_os)
    
    case $os in
        "ubuntu")
            sudo apt-get upgrade -y
            ;;
        "centos")
            sudo yum upgrade -y
            ;;
        "fedora")
            sudo dnf upgrade -y
            ;;
        "arch")
            sudo pacman -Syu --noconfirm
            ;;
        "macos")
            brew upgrade
            ;;
    esac
    
    log_success "System upgraded"
}

main() {
    log_header "System Setup"
    
    install_system_tools
    
    if confirm "Do you want to upgrade all system packages?" "n"; then
        upgrade_system
    fi
    
    log_success "System setup completed"
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    main "$@"
fi
