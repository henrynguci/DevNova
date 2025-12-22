#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/scripts/utils/logger.sh"
source "$SCRIPT_DIR/scripts/utils/common.sh"

install_unclutter() {
    log_header "Installing Unclutter"
    
    if command_exists unclutter; then
        log_info "Unclutter is already installed"
        return 0
    fi
    
    install_package unclutter
    log_success "Unclutter installed successfully"
}

setup_autostart() {
    log_header "Setting up Unclutter Autostart"
    
    local autostart_dir="$HOME/.config/autostart"
    local desktop_file="$autostart_dir/unclutter.desktop"
    
    mkdir -p "$autostart_dir"
    
    cat > "$desktop_file" << 'EOF'
[Desktop Entry]
Type=Application
Name=Unclutter
Comment=Hide mouse cursor when typing
Exec=unclutter --timeout 1 --jitter 2 --ignore-scrolling
Terminal=false
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF
    
    log_success "Unclutter autostart configured"
}

start_unclutter() {
    if pgrep -x unclutter > /dev/null; then
        log_info "Unclutter is already running"
    else
        log_info "Starting unclutter..."
        nohup unclutter --timeout 1 --jitter 2 --ignore-scrolling >/dev/null 2>&1 &
        log_success "Unclutter started"
    fi
}

main() {
    log_header "Unclutter Setup"
    
    install_unclutter
    setup_autostart
    start_unclutter
    
    log_success "Unclutter setup completed"
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    main "$@"
fi
