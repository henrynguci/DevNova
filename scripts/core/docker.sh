#!/bin/bash

# Docker Installation Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/scripts/utils/logger.sh"
source "$SCRIPT_DIR/scripts/utils/common.sh"

# Install Docker
install_docker() {
    log_header "Installing Docker"
    
    if command_exists docker; then
        log_info "Docker is already installed: $(docker --version)"
        return 0
    fi
    
    local os=$(detect_os)
    
    case $os in
        "ubuntu")
            # Add Docker's official GPG key
            log_info "Adding Docker GPG key..."
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
            
            # Set up the stable repository
            log_info "Adding Docker repository..."
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            
            # Install Docker Engine
            sudo apt-get update
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io
            ;;
        "centos")
            sudo yum install -y yum-utils
            sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
            sudo yum install -y docker-ce docker-ce-cli containerd.io
            sudo systemctl start docker
            sudo systemctl enable docker
            ;;
        "fedora")
            sudo dnf -y install dnf-plugins-core
            sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
            sudo dnf install -y docker-ce docker-ce-cli containerd.io
            sudo systemctl start docker
            sudo systemctl enable docker
            ;;
        "arch")
            sudo pacman -S --noconfirm docker
            sudo systemctl start docker
            sudo systemctl enable docker
            ;;
        "macos")
            log_warning "Please install Docker Desktop for Mac from https://www.docker.com/products/docker-desktop"
            return 1
            ;;
        *)
            log_error "Unsupported OS for Docker installation"
            return 1
            ;;
    esac
    
    # Add current user to docker group
    log_info "Adding user to docker group..."
    sudo usermod -aG docker "$USER"
    
    log_success "Docker installed successfully"
    log_warning "You may need to log out and back in for group changes to take effect"
}

# Install Docker Compose
install_docker_compose() {
    log_header "Installing Docker Compose"
    
    if command_exists docker-compose; then
        log_info "Docker Compose is already installed: $(docker-compose --version)"
        return 0
    fi
    
    # Get latest version
    local version=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    
    if [ -z "$version" ]; then
        log_warning "Could not determine latest version, using v2.20.0"
        version="v2.20.0"
    fi
    
    log_info "Installing Docker Compose $version..."
    
    # Download Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/download/${version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    
    # Make it executable
    sudo chmod +x /usr/local/bin/docker-compose
    
    log_success "Docker Compose installed successfully"
}

main() {
    log_header "Docker Setup"
    
    install_docker
    install_docker_compose
    
    log_success "Docker setup completed"
    log_info "Run 'docker --version' and 'docker-compose --version' to verify installation"
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    main "$@"
fi
