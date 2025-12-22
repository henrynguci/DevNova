#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/scripts/utils/logger.sh"
source "$SCRIPT_DIR/scripts/utils/common.sh"

MONASPACE_VERSION="v1.300"
MONASPACE_URL="https://github.com/githubnext/monaspace/releases/download/${MONASPACE_VERSION}/monaspace-${MONASPACE_VERSION}.zip"
FONT_DIR="$HOME/.local/share/fonts"
TEMP_DIR="/tmp/monaspace-install"

check_monaspace_installed() {
    if fc-list | grep -qi "monaspace"; then
        return 0
    fi
    return 1
}

download_monaspace() {
    log_header "Downloading Monaspace Fonts"
    
    mkdir -p "$TEMP_DIR"
    
    log_info "Downloading Monaspace ${MONASPACE_VERSION}..."
    if ! curl -L -o "$TEMP_DIR/monaspace.zip" "$MONASPACE_URL"; then
        log_error "Failed to download Monaspace fonts"
        return 1
    fi
    
    log_success "Download completed"
}

install_monaspace() {
    log_header "Installing Monaspace Fonts"
    
    mkdir -p "$FONT_DIR/monaspace"
    
    log_info "Extracting fonts..."
    if ! unzip -q "$TEMP_DIR/monaspace.zip" -d "$TEMP_DIR"; then
        log_error "Failed to extract fonts"
        return 1
    fi
    
    local extracted_dir=$(find "$TEMP_DIR" -maxdepth 1 -type d -name "monaspace-*" | head -n 1)
    
    if [ -z "$extracted_dir" ]; then
        log_error "Could not find extracted Monaspace directory"
        return 1
    fi
    
    log_info "Installing OTF fonts..."
    if [ -d "$extracted_dir/fonts/otf" ]; then
        cp -r "$extracted_dir/fonts/otf/"* "$FONT_DIR/monaspace/" 2>/dev/null || true
    fi
    
    log_info "Installing Variable fonts..."
    if [ -d "$extracted_dir/fonts/variable" ]; then
        cp -r "$extracted_dir/fonts/variable/"* "$FONT_DIR/monaspace/" 2>/dev/null || true
    fi
    
    log_success "Fonts copied to $FONT_DIR/monaspace"
}

rebuild_font_cache() {
    log_header "Rebuilding Font Cache"
    
    log_info "Running fc-cache..."
    if fc-cache -f; then
        log_success "Font cache rebuilt successfully"
    else
        log_warning "Failed to rebuild font cache, but fonts may still work"
    fi
}

cleanup() {
    log_info "Cleaning up temporary files..."
    rm -rf "$TEMP_DIR"
}

configure_terminal() {
    log_header "Terminal Configuration"
    
    log_info "Monaspace fonts are now installed!"
    log_info "To use Monaspace in your terminal:"
    echo ""
    echo "  Available Monaspace fonts:"
    echo "    - Monaspace Argon"
    echo "    - Monaspace Krypton"
    echo "    - Monaspace Neon"
    echo "    - Monaspace Radon"
    echo "    - Monaspace Xenon"
    echo ""
    echo "  Configure your terminal emulator to use one of these fonts."
    echo ""
    
    if command_exists wezterm; then
        log_info "WezTerm detected. You can configure it in ~/.wezterm.lua"
        echo "  Example: config.font = wezterm.font('Monaspace Neon')"
    fi
    
    if command_exists alacritty; then
        log_info "Alacritty detected. You can configure it in ~/.config/alacritty/alacritty.yml"
        echo "  Example: font.normal.family: 'Monaspace Neon'"
    fi
    
    if command_exists kitty; then
        log_info "Kitty detected. You can configure it in ~/.config/kitty/kitty.conf"
        echo "  Example: font_family Monaspace Neon"
    fi
}

list_monaspace_fonts() {
    log_header "Installed Monaspace Fonts"
    
    if check_monaspace_installed; then
        fc-list | grep -i "monaspace" | cut -d: -f2 | sort -u
    else
        log_warning "No Monaspace fonts found"
    fi
}

main() {
    log_header "Monaspace Font Installation"
    
    if ! command_exists unzip; then
        log_info "Installing unzip..."
        install_package unzip
    fi
    
    if check_monaspace_installed; then
        log_info "Monaspace fonts are already installed"
        if confirm "Do you want to reinstall/update Monaspace fonts?" "n"; then
            log_info "Removing old fonts..."
            rm -rf "$FONT_DIR/monaspace"
        else
            list_monaspace_fonts
            return 0
        fi
    fi
    
    download_monaspace || { cleanup; return 1; }
    install_monaspace || { cleanup; return 1; }
    rebuild_font_cache
    cleanup
    
    log_success "Monaspace installation completed!"
    echo ""
    list_monaspace_fonts
    echo ""
    configure_terminal
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    main "$@"
fi

