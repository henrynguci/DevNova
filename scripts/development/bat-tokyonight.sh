#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/scripts/utils/logger.sh"
source "$SCRIPT_DIR/scripts/utils/common.sh"

REPO='https://github.com/folke/tokyonight.nvim.git'
REPO_NAME='tokyonight.nvim/'
THEME_DIR='extras/sublime/'

install_bat_tokyonight() {
    log_header "Installing Tokyo Night Theme for Bat"
    
    if ! command_exists bat && ! command_exists batcat; then
        log_error "bat is not installed. Please install bat first."
        return 1
    fi
    
    local bat_cmd="bat"
    if command_exists batcat; then
        bat_cmd="batcat"
    fi
    
    BAT_THEMES_DIR="$(command $bat_cmd --config-dir)/themes"
    [ ! -d "$BAT_THEMES_DIR" ] && mkdir -p "$BAT_THEMES_DIR"
    
    cd "$BAT_THEMES_DIR"
    if [ ! -d "$REPO_NAME" ]; then
        log_info "Cloning Tokyo Night theme repository..."
        git clone --no-checkout --depth=1 --filter=blob:none "$REPO"
        cd "$REPO_NAME"
        git sparse-checkout set --no-cone '!/*' "$THEME_DIR"
        git checkout
    else
        log_info "Updating Tokyo Night theme..."
        cd "$REPO_NAME"
        git fetch --filter=blob:none
        updates="$(git rev-list HEAD..@{u} -- "$THEME_DIR" 2>/dev/null || true)"
        [ -n "$updates" ] && git merge --ff-only --log
    fi
    
    BAT_THEME_CACHE="$(command $bat_cmd --cache-dir)/themes.bin"
    if [ ! -e "$BAT_THEME_CACHE" ] \
    || [ -n "$(find "$BAT_THEMES_DIR" -name '*.tmTheme' -newer "$BAT_THEME_CACHE" 2>/dev/null || true)" ]; then
        log_info "Rebuilding bat cache..."
        command $bat_cmd cache --build
    fi

    BAT_CONFIG_FILE="$(command $bat_cmd --config-dir)/config"
    BAT_CONFIG_DIR="$(dirname "$BAT_CONFIG_FILE")"
    [ ! -d "$BAT_CONFIG_DIR" ] && mkdir -p "$BAT_CONFIG_DIR"
    [ ! -f "$BAT_CONFIG_FILE" ] && touch "$BAT_CONFIG_FILE"

    if grep -q "^--theme=\"tokyonight_night\"" "$BAT_CONFIG_FILE"; then
        log_info "Tokyo Night theme is already set in bat config"
    else
        if grep -q "^--theme=" "$BAT_CONFIG_FILE"; then
            sed -i 's/^--theme=/# --theme=/' "$BAT_CONFIG_FILE"
        fi
        echo '--theme="tokyonight_night"' >> "$BAT_CONFIG_FILE"
        log_info "Set Tokyo Night theme in $BAT_CONFIG_FILE"
    fi
    
    log_success "Tokyo Night theme installed for bat"
}

main() {
    install_bat_tokyonight
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    main "$@"
fi
