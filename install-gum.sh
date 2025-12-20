#!/bin/bash
# Removed set -euo pipefail to handle errors gracefully

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/utils/logger.sh"
source "$SCRIPT_DIR/scripts/utils/common.sh"

VERSION="2.0.0"

show_banner() {
    clear
    gum style \
        --foreground 212 --border-foreground 212 --border double \
        --align center --width 60 --margin "1 2" --padding "1 2" \
        '    ____             _   __                 ' \
        '   / __ \___  _   __/ | / /__ _   ______ _ ' \
        '  / / / / _ \| | / /  |/ / _ \ | / / __ `/' \
        ' / /_/ /  __/ |/ / /|  /  __/ |/ / /_/ / ' \
        '/_____/\___/|___/_/ |_/\___/|___/\__,_/  ' \
        '' \
        'Ubuntu DevOps Environment Setup v2.0'
}

select_tools() {
    # Display instructions to stderr (not captured)
    gum style --border double --border-foreground 86 --padding "1 2" --width 60 \
        "Select tools to install" \
        "" \
        "Use TAB to select multiple items" \
        "Press ENTER when done" >&2
    echo >&2
    
    # Capture only gum filter output
    local selected=$(gum filter --no-limit --indicator ">" --placeholder "Type to search..." \
        "System Setup" \
        "Docker" \
        "Kubernetes" \
        "Terraform" \
        "Ansible" \
        "AWS CLI" \
        "Node.js" \
        "Python" \
        "Neovim" \
        "Zsh" \
        "WezTerm" \
        "LazyDocker" \
        "LazyGit" \
        "Rofi" \
        "Gum")
    
    if [ -z "$selected" ]; then
        echo >&2
        gum style --foreground 214 "⚠ No tools selected" >&2
        echo >&2
        gum style --foreground 242 "Press ENTER to exit..." >&2
        read
        exit 0
    fi
    
    echo "$selected"
}

confirm_installation() {
    local tools=$1
    
    echo
    gum style --foreground 86 --bold "Selected tools:"
    echo "$tools" | while IFS= read -r tool; do
        [ -z "$tool" ] && continue
        echo "  • $tool"
    done
    echo
    
    gum style --foreground 212 "Proceed with installation?"
    echo
    
    echo -n "Type 'yes' to continue: "
    read answer
    
    if [[ "$answer" != "yes" && "$answer" != "YES" && "$answer" != "Yes" ]]; then
        echo
        gum style --foreground 214 "Installation cancelled."
        exit 0
    fi
    
    echo
    gum style --foreground 86 "✓ Starting installation..."
}

install_tools() {
    local tools="$1"
    local total=$(echo "$tools" | wc -l)
    local current=0
    
    local IFS=$'\n'
    for tool in $tools; do
        [ -z "$tool" ] && continue
        current=$((current + 1))
        
        echo
        echo "[$current/$total] Installing $tool..."
        
        case "$tool" in
            "System Setup")
                gum spin --spinner dot --title "Installing system tools..." -- bash "$SCRIPT_DIR/scripts/core/system.sh" || true
                ;;
            "Docker")
                gum spin --spinner dot --title "Installing Docker..." -- bash "$SCRIPT_DIR/scripts/core/docker.sh" || true
                ;;
            "Kubernetes")
                gum spin --spinner dot --title "Installing Kubernetes..." -- bash "$SCRIPT_DIR/scripts/core/kubernetes.sh" || true
                ;;
            "Terraform")
                gum spin --spinner dot --title "Installing Terraform..." -- bash "$SCRIPT_DIR/scripts/core/terraform.sh" || true
                ;;
            "Ansible")
                gum spin --spinner dot --title "Installing Ansible..." -- bash "$SCRIPT_DIR/scripts/core/ansible.sh" || true
                ;;
            "AWS CLI")
                gum spin --spinner dot --title "Installing AWS CLI..." -- bash "$SCRIPT_DIR/scripts/core/aws.sh" || true
                ;;
            "Node.js")
                gum spin --spinner dot --title "Installing Node.js..." -- bash "$SCRIPT_DIR/scripts/development/nodejs.sh" || true
                ;;
            "Python")
                gum spin --spinner dot --title "Installing Python..." -- bash "$SCRIPT_DIR/scripts/development/python.sh" || true
                ;;
            "Neovim")
                gum spin --spinner dot --title "Installing Neovim..." -- bash "$SCRIPT_DIR/scripts/development/neovim.sh" || true
                ;;
            "Zsh")
                gum spin --spinner dot --title "Installing Zsh..." -- bash "$SCRIPT_DIR/scripts/shell/zsh.sh" || true
                ;;
            "WezTerm")
                gum spin --spinner dot --title "Installing WezTerm..." -- bash "$SCRIPT_DIR/scripts/development/wezterm.sh" || true
                ;;
            "LazyDocker")
                gum spin --spinner dot --title "Installing LazyDocker..." -- bash "$SCRIPT_DIR/scripts/development/lazydocker.sh" || true
                ;;
            "LazyGit")
                gum spin --spinner dot --title "Installing LazyGit..." -- bash "$SCRIPT_DIR/scripts/development/lazygit.sh" || true
                ;;
            "Rofi")
                gum spin --spinner dot --title "Installing Rofi..." -- bash "$SCRIPT_DIR/scripts/development/rofi.sh" || true
                ;;
            "Gum")
                gum style --foreground 86 "✓ Gum already installed"
                ;;
        esac
        
        echo "✓ $tool done"
    done
}

show_completion() {
    gum style \
        --foreground 86 --border-foreground 86 --border double \
        --align center --width 60 --margin "1 2" --padding "2 4" \
        '✓ Installation Complete!' \
        '' \
        'Your DevOps environment is ready!' \
        '' \
        'Next steps:' \
        '  • Copy configs: cp -r config/* ~/.config/' \
        '  • Start Zsh: zsh' \
        '  • Enjoy your new setup! 🚀'
}

main() {
    # Install Gum only mode
    if [[ "${1:-}" == "--install-gum-only" ]]; then
        bash "$SCRIPT_DIR/scripts/development/gum.sh"
        exit 0
    fi
    
    # Check not running as root
    if [ "$EUID" -eq 0 ]; then
        log_error "Please do not run this script as root"
        exit 1
    fi
    
    # Check Gum
    if ! command_exists gum; then
        echo "Gum is not installed. Install it first:"
        echo "  sudo $0 --install-gum-only"
        exit 1
    fi
    
    show_banner
    
    local selected_tools=$(select_tools)
    confirm_installation "$selected_tools"
    
    echo
    install_tools "$selected_tools"
    
    show_completion
}

main "$@"
