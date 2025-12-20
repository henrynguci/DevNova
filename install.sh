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
    echo -e "${LOG_PURPLE}"
    cat << "EOF"
    ____             _   __                 
   / __ \___  _   __/ | / /__ _   ______ _ 
  / / / / _ \| | / /  |/ / _ \ | / / __ `/
 / /_/ /  __/ |/ / /|  /  __/ |/ / /_/ / 
/_____/\___/|___/_/ |_/\___/|___/\__,_/  
                                          
EOF
    echo -e "${LOG_NC}"
    echo -e "${LOG_CYAN}Ubuntu DevOps Environment Setup v2.0${LOG_NC}"
    echo -e "${LOG_YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${LOG_NC}"
    echo
}

show_menu() {
    show_banner
    
    echo -e "${LOG_GREEN}📦 CORE DEVOPS TOOLS${LOG_NC}"
    echo -e "  ${LOG_CYAN}1${LOG_NC})  🔧 System Setup          ${LOG_YELLOW}2${LOG_NC})  🐳 Docker & Compose"
    echo -e "  ${LOG_CYAN}3${LOG_NC})  ☸️  Kubernetes            ${LOG_YELLOW}4${LOG_NC})  🏗️  Terraform"
    echo -e "  ${LOG_CYAN}5${LOG_NC})  🤖 Ansible              ${LOG_YELLOW}6${LOG_NC})  ☁️  AWS CLI"
    echo
    
    echo -e "${LOG_GREEN}💻 DEVELOPMENT TOOLS${LOG_NC}"
    echo -e "  ${LOG_CYAN}7${LOG_NC})  📗 Node.js & npm        ${LOG_YELLOW}8${LOG_NC})  🐍 Python"
    echo -e "  ${LOG_CYAN}9${LOG_NC})  ✏️  Neovim + LSP         ${LOG_YELLOW}11${LOG_NC}) 🖥️  WezTerm"
    echo -e "  ${LOG_CYAN}12${LOG_NC}) 🐋 LazyDocker          ${LOG_YELLOW}13${LOG_NC}) 🌿 LazyGit"
    echo -e "  ${LOG_CYAN}14${LOG_NC}) 🚀 Rofi"
    echo
    
    echo -e "${LOG_GREEN}🐚 SHELL ENVIRONMENT${LOG_NC}"
    echo -e "  ${LOG_CYAN}10${LOG_NC}) ⚡ Zsh + Oh My Zsh"
    echo
    
    echo -e "${LOG_PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${LOG_NC}"
    echo -e "${LOG_GREEN}⚡ QUICK INSTALL${LOG_NC}"
    echo -e "  ${LOG_CYAN}20${LOG_NC}) 🚀 All Core Tools (1-6)"
    echo -e "  ${LOG_CYAN}21${LOG_NC}) 💎 All Dev Tools (7-9,11-14)"
    echo -e "  ${LOG_CYAN}22${LOG_NC}) 🐚 Shell Environment (10)"
    echo -e "  ${LOG_CYAN}99${LOG_NC}) 🌟 Everything"
    echo
    
    echo -e "${LOG_PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${LOG_NC}"
    echo -e "${LOG_GREEN}⚙️  ACTIONS${LOG_NC}"
    echo -e "  ${LOG_CYAN}e${LOG_NC}) ▶️  Execute selected     ${LOG_YELLOW}s${LOG_NC}) 📊 Show status"
    echo -e "  ${LOG_CYAN}c${LOG_NC}) 🗑️  Clear selections     ${LOG_YELLOW}q${LOG_NC}) 🚪 Quit"
    echo
    
    if [ ${#selected_options[@]} -gt 0 ]; then
        echo -e "${LOG_YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${LOG_NC}"
        echo -e "${LOG_GREEN}✓ Selected:${LOG_NC} ${LOG_CYAN}${selected_options[*]}${LOG_NC}"
        echo -e "${LOG_YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${LOG_NC}"
    else
        echo -e "${LOG_YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${LOG_NC}"
        echo -e "${LOG_YELLOW}ℹ️  No options selected${LOG_NC}"
        echo -e "${LOG_YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${LOG_NC}"
    fi
    echo
    echo -ne "${LOG_GREEN}➜${LOG_NC} Enter your choice: "
}

show_system_status() {
    clear
    echo -e "${LOG_PURPLE}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "                    SYSTEM STATUS                           "
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${LOG_NC}"
    
    check_tool() {
        local name=$1
        local cmd=$2
        local version_cmd=$3
        
        if command_exists $cmd; then
            local ver=$(eval $version_cmd 2>/dev/null | head -1)
            echo -e "  ${LOG_GREEN}✓${LOG_NC} $name: ${LOG_CYAN}$ver${LOG_NC}"
        else
            echo -e "  ${LOG_RED}✗${LOG_NC} $name: ${LOG_YELLOW}Not installed${LOG_NC}"
        fi
    }
    
    echo -e "${LOG_GREEN}📦 Core Tools${LOG_NC}"
    check_tool "Docker      " docker "docker --version"
    check_tool "kubectl     " kubectl "kubectl version --client --short"
    check_tool "Terraform   " terraform "terraform version"
    check_tool "Ansible     " ansible "ansible --version"
    check_tool "AWS CLI     " aws "aws --version"
    echo
    
    echo -e "${LOG_GREEN}💻 Development${LOG_NC}"
    check_tool "Node.js     " node "node --version"
    check_tool "Python      " python3 "python3 --version"
    check_tool "Neovim      " nvim "nvim --version"
    check_tool "WezTerm     " wezterm "echo 'Installed'"
    check_tool "LazyDocker  " lazydocker "echo 'Installed'"
    check_tool "LazyGit     " lazygit "echo 'Installed'"
    check_tool "Rofi        " rofi "rofi -version"
    echo
    
    echo -e "${LOG_GREEN}🐚 Shell${LOG_NC}"
    check_tool "Zsh         " zsh "zsh --version"
    echo
    
    echo -e "${LOG_YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${LOG_NC}"
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
    
    clear
    echo -e "${LOG_PURPLE}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "                  STARTING INSTALLATION                     "
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${LOG_NC}"
    
    total_steps=${#selected_options[@]}
    current_step=1
    
    ensure_not_root
    
    for option in "${selected_options[@]}"; do
        echo -e "${LOG_CYAN}[${current_step}/${total_steps}]${LOG_NC}"
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
            14) execute_installation "development/rofi.sh" "Rofi" ;;
        esac
        ((current_step++))
        echo
    done
    
    selected_options=()
    
    echo -e "${LOG_GREEN}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "              ✓ INSTALLATION COMPLETED!                     "
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${LOG_NC}"
    echo -e "${LOG_CYAN}📝 Log saved to:${LOG_NC} $LOG_FILE"
    echo
    read -p "Press Enter to continue..."
}

# =============================================================================
# Menu Handling
# =============================================================================

add_option() {
    local option=$1
    
    if [[ " ${selected_options[@]} " =~ " ${option} " ]]; then
        echo -e "${LOG_YELLOW}⚠ Option $option already selected${LOG_NC}"
    else
        selected_options+=("$option")
        echo -e "${LOG_GREEN}✓ Added option $option${LOG_NC}"
    fi
}

handle_choice() {
    local choice=$1
    
    case $choice in
        [1-9]|1[0-4])
            add_option "$choice"
            sleep 0.3
            ;;
        20)
            for i in {1..6}; do add_option "$i"; done
            echo -e "${LOG_GREEN}✓ Selected all core tools${LOG_NC}"
            sleep 0.5
            ;;
        21)
            for i in {7..9}; do add_option "$i"; done
            for i in {11..14}; do add_option "$i"; done
            echo -e "${LOG_GREEN}✓ Selected all development tools${LOG_NC}"
            sleep 0.5
            ;;
        22)
            add_option "10"
            echo -e "${LOG_GREEN}✓ Selected shell tools${LOG_NC}"
            sleep 0.5
            ;;
        99)
            for i in {1..14}; do add_option "$i"; done
            echo -e "${LOG_GREEN}✓ Selected everything${LOG_NC}"
            sleep 0.5
            ;;
        e|E)
            execute_selected_options
            ;;
        s|S)
            show_system_status
            ;;
        c|C)
            selected_options=()
            echo -e "${LOG_YELLOW}✓ Selections cleared${LOG_NC}"
            sleep 0.5
            ;;
        q|Q)
            clear
            echo -e "${LOG_CYAN}👋 Thanks for using DevNova!${LOG_NC}"
            exit 0
            ;;
        *)
            echo -e "${LOG_RED}✗ Invalid choice: $choice${LOG_NC}"
            sleep 0.5
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
