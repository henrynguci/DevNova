#!/bin/bash

# Kubernetes Tools Installation Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/scripts/utils/logger.sh"
source "$SCRIPT_DIR/scripts/utils/common.sh"

# Install kubectl
install_kubectl() {
    log_header "Installing kubectl"
    
    if command_exists kubectl; then
        log_info "kubectl is already installed: $(kubectl version --client --short 2>/dev/null || kubectl version --client)"
        return 0
    fi
    
    local os=$(detect_os)
    
    case $os in
        "ubuntu"|"linux")
            # Download the latest release
            log_info "Downloading kubectl..."
            local version=$(curl -L -s https://dl.k8s.io/release/stable.txt)
            curl -LO "https://dl.k8s.io/release/${version}/bin/linux/amd64/kubectl"
            
            # Install kubectl
            sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
            rm kubectl
            ;;
        "macos")
            brew install kubectl
            ;;
        *)
            log_error "Unsupported OS for kubectl installation"
            return 1
            ;;
    esac
    
    log_success "kubectl installed successfully"
}

# Install minikube
install_minikube() {
    log_header "Installing minikube"
    
    if command_exists minikube; then
        log_info "minikube is already installed: $(minikube version --short)"
        return 0
    fi
    
    local os=$(detect_os)
    
    case $os in
        "ubuntu"|"linux")
            # Download minikube
            log_info "Downloading minikube..."
            curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
            
            # Install minikube
            sudo install minikube-linux-amd64 /usr/local/bin/minikube
            rm minikube-linux-amd64
            ;;
        "macos")
            brew install minikube
            ;;
        *)
            log_error "Unsupported OS for minikube installation"
            return 1
            ;;
    esac
    
    log_success "minikube installed successfully"
}

# Configure kubectl autocompletion
configure_kubectl_completion() {
    log_info "Configuring kubectl autocompletion..."
    
    # For bash
    if [ -f "$HOME/.bashrc" ]; then
        add_to_file_if_not_exists "source <(kubectl completion bash)" "$HOME/.bashrc"
    fi
    
    # For zsh
    if [ -f "$HOME/.zshrc" ]; then
        add_to_file_if_not_exists "source <(kubectl completion zsh)" "$HOME/.zshrc"
    fi
    
    log_success "kubectl autocompletion configured"
}

main() {
    log_header "Kubernetes Tools Setup"
    
    install_kubectl
    install_minikube
    configure_kubectl_completion
    
    log_success "Kubernetes tools setup completed"
    log_info "Run 'kubectl version --client' and 'minikube version' to verify installation"
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    main "$@"
fi
