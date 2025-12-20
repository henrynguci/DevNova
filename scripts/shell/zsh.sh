#!/bin/bash

# Zsh and Oh My Zsh Installation Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/scripts/utils/logger.sh"
source "$SCRIPT_DIR/scripts/utils/common.sh"

# Install Zsh
install_zsh() {
    log_header "Installing Zsh"
    
    if command_exists zsh; then
        log_info "Zsh is already installed: $(zsh --version)"
        return 0
    fi
    
    install_package zsh
    log_success "Zsh installed successfully"
}

# Install Oh My Zsh
install_oh_my_zsh() {
    log_header "Installing Oh My Zsh"
    
    if [ -d "$HOME/.oh-my-zsh" ]; then
        log_info "Oh My Zsh is already installed"
        return 0
    fi
    
    log_info "Downloading and installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    log_success "Oh My Zsh installed successfully"
}

# Install Zsh plugins
install_zsh_plugins() {
    log_header "Installing Zsh Plugins"
    
    local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    
    # zsh-autosuggestions
    if [ ! -d "$zsh_custom/plugins/zsh-autosuggestions" ]; then
        log_info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom/plugins/zsh-autosuggestions"
    fi
    
    # zsh-syntax-highlighting
    if [ ! -d "$zsh_custom/plugins/zsh-syntax-highlighting" ]; then
        log_info "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$zsh_custom/plugins/zsh-syntax-highlighting"
    fi
    
    # zsh-completions
    if [ ! -d "$zsh_custom/plugins/zsh-completions" ]; then
        log_info "Installing zsh-completions..."
        git clone https://github.com/zsh-users/zsh-completions "$zsh_custom/plugins/zsh-completions"
    fi
    
    log_success "Zsh plugins installed"
}

# Configure .zshrc
configure_zshrc() {
    log_header "Configuring .zshrc"
    
    local zshrc="$HOME/.zshrc"
    
    # Backup existing .zshrc if it exists
    if [ -f "$zshrc" ]; then
        create_backup "$zshrc"
    fi
    
    # Create basic .zshrc if it doesn't exist
    if [ ! -f "$zshrc" ] || ! grep -q "export ZSH=" "$zshrc"; then
        log_info "Creating basic .zshrc configuration..."
        cat > "$zshrc" << 'EOF'
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)

source $ZSH/oh-my-zsh.sh

# User configuration
export EDITOR='nvim'
export VISUAL='nvim'

# History settings
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zsh_history
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE

# Add local bin to PATH
export PATH=$PATH:$HOME/.local/bin

EOF
    fi
    
    # Source aliases if the file exists
    local aliases_file="$SCRIPT_DIR/scripts/shell/aliases.sh"
    if [ -f "$aliases_file" ]; then
        if ! grep -q "source.*aliases.sh" "$zshrc"; then
            echo "" >> "$zshrc"
            echo "# Source DevNova aliases" >> "$zshrc"
            echo "[ -f \"$aliases_file\" ] && source \"$aliases_file\"" >> "$zshrc"
            log_info "Added aliases source to .zshrc"
        fi
    fi
    
    log_success ".zshrc configured"
}

# Set Zsh as default shell
set_default_shell() {
    if [ "$SHELL" = "$(which zsh)" ]; then
        log_info "Zsh is already the default shell"
        return 0
    fi
    
    if confirm "Do you want to set Zsh as your default shell?" "y"; then
        log_info "Setting Zsh as default shell..."
        chsh -s "$(which zsh)"
        log_success "Zsh set as default shell"
        log_warning "You need to log out and back in for the change to take effect"
    fi
}

main() {
    log_header "Zsh Setup"
    
    install_zsh
    install_oh_my_zsh
    install_zsh_plugins
    configure_zshrc
    set_default_shell
    
    log_success "Zsh setup completed"
    log_info "Run 'zsh' to start using Zsh"
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    main "$@"
fi
