#!/bin/bash

# AWS CLI Installation Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/scripts/utils/logger.sh"
source "$SCRIPT_DIR/scripts/utils/common.sh"

# Install AWS CLI
install_aws_cli() {
    log_header "Installing AWS CLI"
    
    if command_exists aws; then
        log_info "AWS CLI is already installed: $(aws --version)"
        return 0
    fi
    
    local os=$(detect_os)
    
    case $os in
        "ubuntu"|"linux")
            # Download AWS CLI installer
            log_info "Downloading AWS CLI..."
            cd /tmp
            curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
            
            # Unzip and install
            unzip -q awscliv2.zip
            sudo ./aws/install
            
            # Cleanup
            rm -rf aws awscliv2.zip
            cd - >/dev/null
            ;;
        "macos")
            brew install awscli
            ;;
        *)
            log_error "Unsupported OS for AWS CLI installation"
            return 1
            ;;
    esac
    
    log_success "AWS CLI installed successfully"
}

# Configure AWS CLI autocompletion
configure_aws_completion() {
    log_info "Configuring AWS CLI autocompletion..."
    
    # For bash
    if [ -f "$HOME/.bashrc" ]; then
        add_to_file_if_not_exists "complete -C '/usr/local/bin/aws_completer' aws" "$HOME/.bashrc"
    fi
    
    # For zsh
    if [ -f "$HOME/.zshrc" ]; then
        add_to_file_if_not_exists "complete -C '/usr/local/bin/aws_completer' aws" "$HOME/.zshrc"
    fi
    
    log_success "AWS CLI autocompletion configured"
}

main() {
    log_header "AWS CLI Setup"
    
    install_aws_cli
    configure_aws_completion
    
    log_success "AWS CLI setup completed"
    log_info "Run 'aws --version' to verify installation"
    log_info "Run 'aws configure' to set up your AWS credentials"
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    main "$@"
fi
