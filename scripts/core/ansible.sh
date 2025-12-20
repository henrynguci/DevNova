#!/bin/bash

# Ansible Installation Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/scripts/utils/logger.sh"
source "$SCRIPT_DIR/scripts/utils/common.sh"

# Install Ansible
install_ansible() {
    log_header "Installing Ansible"
    
    if command_exists ansible; then
        log_info "Ansible is already installed: $(ansible --version | head -1)"
        return 0
    fi
    
    local os=$(detect_os)
    
    case $os in
        "ubuntu")
            # Add Ansible PPA
            sudo apt-add-repository -y ppa:ansible/ansible
            sudo apt-get update
            sudo apt-get install -y ansible
            ;;
        "centos"|"fedora")
            sudo yum install -y ansible
            ;;
        "arch")
            sudo pacman -S --noconfirm ansible
            ;;
        "macos")
            brew install ansible
            ;;
        *)
            log_error "Unsupported OS for Ansible installation"
            return 1
            ;;
    esac
    
    log_success "Ansible installed successfully"
}

main() {
    log_header "Ansible Setup"
    
    install_ansible
    
    log_success "Ansible setup completed"
    log_info "Run 'ansible --version' to verify installation"
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    main "$@"
fi
