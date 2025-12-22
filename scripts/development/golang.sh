#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/logger.sh"
source "$SCRIPT_DIR/../utils/common.sh"

GO_VERSION="1.24.4"

install_go() {
    log_header "Installing Go $GO_VERSION"
    
    # Detect architecture
    ARCH=$(uname -m)
    case $ARCH in
        x86_64)
            GO_ARCH="amd64"
            ;;
        aarch64|arm64)
            GO_ARCH="arm64"
            ;;
        *)
            log_error "Unsupported architecture: $ARCH"
            return 1
            ;;
    esac
    
    GO_TARBALL="go${GO_VERSION}.linux-${GO_ARCH}.tar.gz"
    GO_URL="https://go.dev/dl/${GO_TARBALL}"
    
    log_info "Downloading Go ${GO_VERSION} for ${GO_ARCH}..."
    
    # Download Go
    cd /tmp
    if ! curl -LO "$GO_URL"; then
        log_error "Failed to download Go"
        return 1
    fi
    
    # Remove old Go installation
    log_info "Removing old Go installation..."
    sudo rm -rf /usr/local/go
    
    # Extract new Go
    log_info "Installing Go to /usr/local/go..."
    sudo tar -C /usr/local -xzf "$GO_TARBALL"
    
    # Clean up
    rm "$GO_TARBALL"
    
    # Add Go to PATH if not already present
    if ! grep -q "/usr/local/go/bin" ~/.bashrc; then
        echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
    fi
    
    if [ -f ~/.zshrc ] && ! grep -q "/usr/local/go/bin" ~/.zshrc; then
        echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
    fi
    
    # Add GOPATH
    if ! grep -q "GOPATH" ~/.bashrc; then
        echo 'export GOPATH=$HOME/go' >> ~/.bashrc
        echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc
    fi
    
    if [ -f ~/.zshrc ] && ! grep -q "GOPATH" ~/.zshrc; then
        echo 'export GOPATH=$HOME/go' >> ~/.zshrc
        echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.zshrc
    fi
    
    # Export for current session
    export PATH=$PATH:/usr/local/go/bin
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOPATH/bin
    
    log_success "Go ${GO_VERSION} installed successfully"
    log_info "Go version: $(/usr/local/go/bin/go version)"
    log_info "Please restart your shell or run: source ~/.bashrc"
    
    return 0
}

install_go
