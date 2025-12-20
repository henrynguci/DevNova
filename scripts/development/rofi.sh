#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/scripts/utils/logger.sh"
source "$SCRIPT_DIR/scripts/utils/common.sh"

install_rofi() {
    log_header "Installing Rofi"
    
    if command_exists rofi; then
        log_info "Rofi is already installed"
        return 0
    fi
    
    local os=$(detect_os)
    
    case $os in
        "ubuntu")
            sudo apt-get install -y rofi
            ;;
        "arch")
            sudo pacman -S --noconfirm rofi
            ;;
        "fedora")
            sudo dnf install -y rofi
            ;;
        *)
            log_error "Unsupported OS for Rofi installation"
            return 1
            ;;
    esac
    
    log_success "Rofi installed successfully"
}

main() {
    install_rofi
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    main "$@"
fi
