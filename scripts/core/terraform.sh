#!/bin/bash

# Terraform Installation Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/scripts/utils/logger.sh"
source "$SCRIPT_DIR/scripts/utils/common.sh"

# Install Terraform
install_terraform() {
    log_header "Installing Terraform"
    
    if command_exists terraform; then
        log_info "Terraform is already installed: $(terraform version | head -1)"
        return 0
    fi
    
    local os=$(detect_os)
    
    case $os in
        "ubuntu")
            # Add HashiCorp GPG key
            log_info "Adding HashiCorp GPG key..."
            curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
            
            # Add HashiCorp repository
            log_info "Adding HashiCorp repository..."
            sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
            
            # Install Terraform
            sudo apt-get update
            sudo apt-get install -y terraform
            ;;
        "centos"|"fedora")
            sudo yum install -y yum-utils
            sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
            sudo yum -y install terraform
            ;;
        "arch")
            sudo pacman -S --noconfirm terraform
            ;;
        "macos")
            brew tap hashicorp/tap
            brew install hashicorp/tap/terraform
            ;;
        *)
            log_error "Unsupported OS for Terraform installation"
            return 1
            ;;
    esac
    
    log_success "Terraform installed successfully"
}

# Configure Terraform autocompletion
configure_terraform_completion() {
    log_info "Configuring Terraform autocompletion..."
    
    # Install autocompletion
    terraform -install-autocomplete 2>/dev/null || true
    
    log_success "Terraform autocompletion configured"
}

main() {
    log_header "Terraform Setup"
    
    install_terraform
    configure_terraform_completion
    
    log_success "Terraform setup completed"
    log_info "Run 'terraform version' to verify installation"
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    main "$@"
fi
