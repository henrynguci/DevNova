#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/scripts/utils/logger.sh"
source "$SCRIPT_DIR/scripts/utils/common.sh"

install_lazygit() {
    log_header "Installing LazyGit"
    
    if command_exists lazygit; then
        log_info "LazyGit is already installed"
        return 0
    fi
    
    local os=$(detect_os)
    
    case $os in
        "ubuntu")
            LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
            curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
            tar xf lazygit.tar.gz lazygit
            sudo install lazygit /usr/local/bin
            rm lazygit lazygit.tar.gz
            ;;
        *)
            log_error "Unsupported OS for LazyGit installation"
            return 1
            ;;
    esac
    
    log_success "LazyGit installed successfully"
}

main() {
    install_lazygit
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    main "$@"
fi
