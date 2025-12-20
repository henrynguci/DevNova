#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/scripts/utils/logger.sh"
source "$SCRIPT_DIR/scripts/utils/common.sh"

install_lazydocker() {
    log_header "Installing LazyDocker"
    
    if command_exists lazydocker; then
        log_info "LazyDocker is already installed"
        return 0
    fi
    
    log_info "Downloading LazyDocker..."
    curl -fsSL https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
    
    log_success "LazyDocker installed successfully"
}

main() {
    install_lazydocker
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    main "$@"
fi
