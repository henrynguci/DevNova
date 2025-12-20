#!/bin/bash

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
    gum style --foreground 86 "Select tools (TAB to select, ENTER to confirm):" >&2
    echo >&2
    
    local selected=$(gum filter --no-limit --height 20 --indicator ">" --placeholder "Type to search..." \
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
        "Gum" \
        "btop")
    
    if [ -z "$selected" ]; then
        gum style --foreground 214 "No tools selected" >&2
        exit 0
    fi
    
    echo "$selected"
}

confirm_installation() {
    local tools=$1
    
    echo
    gum style --foreground 86 --bold "Selected:"
    echo "$tools" | while IFS= read -r tool; do
        [ -z "$tool" ] && continue
        echo "  - $tool"
    done
    echo
    
    echo -n "Install? (yes/no): "
    read answer
    
    if [[ "$answer" != "yes" && "$answer" != "YES" && "$answer" != "Yes" ]]; then
        gum style --foreground 214 "Cancelled."
        exit 0
    fi
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
                bash "$SCRIPT_DIR/scripts/core/system.sh"
                ;;
            "Docker")
                bash "$SCRIPT_DIR/scripts/core/docker.sh"
                ;;
            "Kubernetes")
                bash "$SCRIPT_DIR/scripts/core/kubernetes.sh"
                ;;
            "Terraform")
                bash "$SCRIPT_DIR/scripts/core/terraform.sh"
                ;;
            "Ansible")
                bash "$SCRIPT_DIR/scripts/core/ansible.sh"
                ;;
            "AWS CLI")
                bash "$SCRIPT_DIR/scripts/core/aws.sh"
                ;;
            "Node.js")
                bash "$SCRIPT_DIR/scripts/development/nodejs.sh"
                ;;
            "Python")
                bash "$SCRIPT_DIR/scripts/development/python.sh"
                ;;
            "Neovim")
                bash "$SCRIPT_DIR/scripts/development/neovim.sh"
                ;;
            "Zsh")
                bash "$SCRIPT_DIR/scripts/shell/zsh.sh"
                ;;
            "WezTerm")
                bash "$SCRIPT_DIR/scripts/development/wezterm.sh"
                ;;
            "LazyDocker")
                bash "$SCRIPT_DIR/scripts/development/lazydocker.sh"
                ;;
            "LazyGit")
                bash "$SCRIPT_DIR/scripts/development/lazygit.sh"
                ;;
            "Rofi")
                bash "$SCRIPT_DIR/scripts/development/rofi.sh"
                ;;
            "Gum")
                echo "Already installed"
                ;;
            "btop")
                bash "$SCRIPT_DIR/scripts/development/btop.sh"
                ;;
        esac
        
        echo "Done: $tool"
    done
}

show_completion() {
    echo
    gum style \
        --foreground 86 --border-foreground 86 --border double \
        --align center --width 60 --margin "1 2" --padding "2 4" \
        'Installation Complete!' \
        '' \
        'Next steps:' \
        '  cp -r config/* ~/.config/' \
        '  zsh'
}

main() {
    if [[ "${1:-}" == "--install-gum-only" ]]; then
        bash "$SCRIPT_DIR/scripts/development/gum.sh"
        exit 0
    fi
    
    if [ "$EUID" -eq 0 ]; then
        echo "Do not run as root"
        exit 1
    fi
    
    if ! command -v gum &> /dev/null; then
        echo "Gum not installed. Run: sudo $0 --install-gum-only"
        exit 1
    fi
    
    show_banner
    
    local selected_tools=$(select_tools)
    confirm_installation "$selected_tools"
    install_tools "$selected_tools"
    show_completion
}

main "$@"
