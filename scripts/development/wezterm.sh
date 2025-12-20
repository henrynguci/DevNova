#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/scripts/utils/logger.sh"
source "$SCRIPT_DIR/scripts/utils/common.sh"

install_wezterm() {
    log_header "Installing WezTerm"
    
    if command_exists wezterm; then
        log_info "WezTerm is already installed"
        return 0
    fi
    
    local os=$(detect_os)
    
    case $os in
        "ubuntu")
            curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
            echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
            sudo apt update
            sudo apt install -y wezterm
            ;;
        *)
            log_error "Unsupported OS for WezTerm installation"
            return 1
            ;;
    esac
    
    log_success "WezTerm installed successfully"
}

main() {
    install_wezterm
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    main "$@"
fi
