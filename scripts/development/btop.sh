#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/scripts/utils/logger.sh"
source "$SCRIPT_DIR/scripts/utils/common.sh"

install_btop() {
    log_header "Installing btop"
    
    if command_exists btop; then
        log_info "btop is already installed"
        return 0
    fi
    
    local os=$(detect_os)
    
    case $os in
        "ubuntu")
            install_package btop
            ;;
        "arch")
            sudo pacman -S --noconfirm btop
            ;;
        "fedora")
            sudo dnf install -y btop
            ;;
        *)
            log_warning "Installing from source..."
            local tmp_dir=$(mktemp -d)
            cd "$tmp_dir"
            curl -LO https://github.com/aristocratos/btop/releases/latest/download/btop-x86_64-linux-musl.tbz
            tar -xjf btop-x86_64-linux-musl.tbz
            cd btop
            sudo make install
            cd -
            rm -rf "$tmp_dir"
            ;;
    esac
    
    log_success "btop installed successfully"
}

main() {
    install_btop
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    main "$@"
fi
