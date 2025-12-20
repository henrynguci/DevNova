#!/bin/bash

# =============================================================================
# DevNova - Ubuntu DevOps Environment Setup
# Description: Main installation script for DevNova
# Author: Minh-Hung Trinh
# =============================================================================

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
source "$SCRIPT_DIR/scripts/utils/logger.sh"
source "$SCRIPT_DIR/scripts/utils/common.sh"

# Version
VERSION="2.0.0"

# Installation options
declare -a selected_options=()

# =============================================================================
# Display Functions
# =============================================================================

show_banner() {
    clear
    cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                        DevNova v2.0                          ║
║            Ubuntu DevOps Environment Setup                   ║
╚══════════════════════════════════════════════════════════════╝
EOF
    echo
}

show_menu() {
    show_banner
    log_header "Installation Menu"
    echo
    echo "  Core DevOps Tools:"
    echo "    1) System Setup"
    echo "    2) Docker & Docker Compose"
    echo "    3) Kubernetes (kubectl, minikube)"
    echo "    4) Terraform"
    echo "    5) Ansible"
    echo "    6) AWS CLI"
    echo
    echo "  Development Tools:"
    echo "    7) Node.js, npm & Yarn"
    echo "    8) Python"
    echo "    9) Neovim with LSP"
    echo "   11) WezTerm"
    echo "   12) LazyDocker"
    echo "   13) LazyGit"
    echo
    echo "  Shell:"
    echo "   10) Zsh & Oh My Zsh"
    echo
    echo "  Quick Install:"
    echo "   20) All Core Tools (1-6)"
    echo "   21) All Dev Tools (7-9,11-13)"
    echo "   22) Shell (10)"
    echo "   99) Everything"
    echo
    echo "  Actions:"
    echo "    e) Execute selected"
    echo "    s) Show status"
    echo "    c) Clear selections"
    echo "    q) Quit"
    echo
    
    if [ ${#selected_options[@]} -gt 0 ]; then
        echo -e "${LOG_YELLOW}Selected: ${selected_options[*]}${LOG_NC}"
    else
        echo "No options selected"
    fi
    echo
}

show_system_status() {
    log_header "System Status"
    echo
    echo "OS: $(detect_os)"
    echo "Docker: $(command_exists docker && docker --version || echo 'Not installed')"
    echo "kubectl: $(command_exists kubectl && kubectl version --client --short 2>/dev/null || echo 'Not installed')"
    echo "Terraform: $(command_exists terraform && terraform version | head -1 || echo 'Not installed')"
    echo "Ansible: $(command_exists ansible && ansible --version | head -1 || echo 'Not installed')"
    echo "Node.js: $(command_exists node && node --version || echo 'Not installed')"
    echo "Python: $(command_exists python3 && python3 --version || echo 'Not installed')"
    echo "Neovim: $(command_exists nvim && nvim --version | head -1 || echo 'Not installed')"
    echo "Zsh: $(command_exists zsh && zsh --version || echo 'Not installed')"
    echo "WezTerm: $(command_exists wezterm && echo 'Installed' || echo 'Not installed')"
    echo "LazyDocker: $(command_exists lazydocker && echo 'Installed' || echo 'Not installed')"
    echo "LazyGit: $(command_exists lazygit && echo 'Installed' || echo 'Not installed')"
    echo
    read -p "Press Enter to continue..."
}

# =============================================================================
# Installation Functions
# =============================================================================

execute_installation() {
    local script=$1
    local name=$2
    
    log_step "$current_step" "$total_steps" "$name"
    
    if [ -f "$SCRIPT_DIR/scripts/$script" ]; then
        bash "$SCRIPT_DIR/scripts/$script"
    else
        log_error "Script not found: $script"
        return 1
    fi
    
    ((current_step++))
}

execute_selected_options() {
    if [ ${#selected_options[@]} -eq 0 ]; then
        log_warning "No options selected"
        read -p "Press Enter to continue..."
        return 1
    fi
    
    log_header "Starting Installation"
    
    total_steps=${#selected_options[@]}
    current_step=1
    
    ensure_not_root
    
    for option in "${selected_options[@]}"; do
        case $option in
            1)  execute_installation "core/system.sh" "System Setup" ;;
            2)  execute_installation "core/docker.sh" "Docker" ;;
            3)  execute_installation "core/kubernetes.sh" "Kubernetes" ;;
            4)  execute_installation "core/terraform.sh" "Terraform" ;;
            5)  execute_installation "core/ansible.sh" "Ansible" ;;
            6)  execute_installation "core/aws.sh" "AWS CLI" ;;
            7)  execute_installation "development/nodejs.sh" "Node.js" ;;
            8)  execute_installation "development/python.sh" "Python" ;;
            9)  execute_installation "development/neovim.sh" "Neovim" ;;
            10) execute_installation "shell/zsh.sh" "Zsh" ;;
            11) execute_installation "development/wezterm.sh" "WezTerm" ;;
            12) execute_installation "development/lazydocker.sh" "LazyDocker" ;;
            13) execute_installation "development/lazygit.sh" "LazyGit" ;;
        esac
    done
    
    selected_options=()
    
    log_success "Installation completed!"
    echo
    log_info "Installation log saved to: $LOG_FILE"
    echo
    read -p "Press Enter to continue..."
}

# =============================================================================
# Menu Handling
# =============================================================================

add_option() {
    local option=$1
    
    if [[ " ${selected_options[@]} " =~ " ${option} " ]]; then
        log_warning "Option $option already selected"
    else
        selected_options+=("$option")
        log_success "Added option $option"
    fi
}

handle_choice() {
    local choice=$1
    
    case $choice in
        [1-9]|1[0-3])
            add_option "$choice"
            ;;
        20)
            for i in {1..6}; do add_option "$i"; done
            log_success "Selected all core tools"
            ;;
        21)
            for i in {7..9}; do add_option "$i"; done
            for i in {11..13}; do add_option "$i"; done
            log_success "Selected all development tools"
            ;;
        22)
            add_option "10"
            log_success "Selected shell tools"
            ;;
        99)
            for i in {1..13}; do add_option "$i"; done
            log_success "Selected everything"
            ;;
        e|E)
            execute_selected_options
            ;;
        s|S)
            show_system_status
            ;;
        c|C)
            selected_options=()
            log_info "Selections cleared"
            ;;
        q|Q)
            log_info "Exiting DevNova installer"
            exit 0
            ;;
        *)
            log_error "Invalid choice: $choice"
            ;;
    esac
}

# =============================================================================
# Main Function
# =============================================================================

main() {
    # Check if running as root
    if [ "$EUID" -eq 0 ]; then
        log_error "Please do not run this script as root"
        exit 1
    fi
    
    # Initialize log
    init_log
    
    # Main loop
    while true; do
        show_menu
        read -p "Enter your choice: " choice
        handle_choice "$choice"
        sleep 0.5
    done
}

# Run main
main "$@"
