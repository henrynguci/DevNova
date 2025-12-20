#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/scripts/utils/logger.sh"
source "$SCRIPT_DIR/scripts/utils/common.sh"

install_gum() {
    log_header "Installing Gum"
    
    if command_exists gum; then
        log_info "Gum is already installed"
        return 0
    fi
    
    local os=$(detect_os)
    
    case $os in
        "ubuntu")
            log_info "Adding Charm repository..."
            sudo mkdir -p /etc/apt/keyrings
            curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
            echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
            sudo apt update
            sudo apt install -y gum
            ;;
        "arch")
            sudo pacman -S --noconfirm gum
            ;;
        "fedora")
            echo '[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key' | sudo tee /etc/yum.repos.d/charm.repo
            sudo yum install -y gum
            ;;
        *)
            log_warning "Installing from binary..."
            local tmp_dir=$(mktemp -d)
            cd "$tmp_dir"
            curl -LO https://github.com/charmbracelet/gum/releases/latest/download/gum_Linux_x86_64.tar.gz
            tar -xzf gum_Linux_x86_64.tar.gz
            sudo install -m 755 gum /usr/local/bin/
            cd -
            rm -rf "$tmp_dir"
            ;;
    esac
    
    log_success "Gum installed successfully"
}

main() {
    install_gum
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    main "$@"
fi
