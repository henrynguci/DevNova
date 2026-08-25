#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/utils/logger.sh"
source "$SCRIPT_DIR/scripts/utils/common.sh"

VERSION="2.0.0"

show_banner() {
    clear
    gum style \
        --foreground 212 --border-foreground 212 --border double \
        --align center --width 70 --margin "1 2" --padding "1 2" \
        ' ███╗   ██╗  ██████╗  ██╗   ██╗  █████╗ ' \
        ' ████╗  ██║ ██╔═══██╗ ██║   ██║ ██╔══██╗' \
        ' ██╔██╗ ██║ ██║   ██║ ██║   ██║ ███████║' \
        ' ██║╚██╗██║ ██║   ██║ ╚██╗ ██╔╝ ██╔══██║' \
        ' ██║ ╚████║ ╚██████╔╝  ╚████╔╝  ██║  ██║' \
        ' ╚═╝  ╚═══╝  ╚═════╝    ╚═══╝   ╚═╝  ╚═╝' \
        '' \
        'DevNova v2.0 - Cre: Minh Hung'
}

select_role() {
    local role=$(gum filter --no-limit --height 10 --indicator ">" --placeholder "Choose your role..." \
        "DevOps Engineer" \
        "Backend Developer" \
        "Frontend Developer" \
        "Cloud Engineer" \
        "Network Engineer" \
        "Fullstack Developer" \
        "Custom Selection")
    
    echo "$role"
}

get_tools_for_role() {
    local role=$1
    
    case "$role" in
        "DevOps Engineer")
            echo "System Setup
Docker
Kubernetes
Terraform
Ansible
AWS CLI
Python
Neovim
Zsh
LazyDocker
LazyGit
Gum
btop
Bat Tokyo Night
Unclutter"
            ;;
        "Backend Developer")
            echo "System Setup
Docker
Node.js
Python
Neovim
Zsh
LazyDocker
LazyGit
Gum
btop
Bat Tokyo Night
Unclutter"
            ;;
        "Frontend Developer")
            echo "System Setup
Node.js
Neovim
Zsh
LazyGit
Gum
btop
Bat Tokyo Night
Unclutter"
            ;;
        "Cloud Engineer")
            echo "System Setup
Docker
Kubernetes
Terraform
AWS CLI
Python
Neovim
Zsh
LazyDocker
Gum
btop
Bat Tokyo Night
Unclutter"
            ;;
        "Network Engineer")
            echo "System Setup
Docker
Ansible
Python
Neovim
Zsh
Gum
btop
Bat Tokyo Night
Unclutter"
            ;;
        "Fullstack Developer")
            echo "System Setup
Docker
Kubernetes
Node.js
Python
Neovim
Zsh
WezTerm
Monaspace Fonts
LazyDocker
LazyGit
Gum
btop
Bat Tokyo Night
Unclutter"
            ;;
        "Custom Selection")
            gum filter --no-limit --height 20 --indicator ">" --placeholder "Type to search..." \
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
                "Monaspace Fonts" \
                "LazyDocker" \
                "LazyGit" \
                "Gum" \
                "btop" \
                "Bat Tokyo Night" \
                "Unclutter"
            ;;
    esac
}

select_tools() {
    local role=$(select_role)
    local selected=$(get_tools_for_role "$role")
    
    if [ -z "$selected" ]; then
        gum style --foreground 214 "No tools selected" >&2
        exit 0
    fi
    
    echo "$selected"
}


confirm_installation() {
    local role=$1
    
    if [ ! -f "$SCRIPT_DIR/bin/role-confirm" ]; then
        log_error "role-confirm tool not found. Please run ./build.sh first"
        exit 1
    fi
    
    if "$SCRIPT_DIR/bin/role-confirm" "$role"; then
        return 0
    else
        gum style --foreground 214 "Installation cancelled."
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
            "Monaspace Fonts")
                bash "$SCRIPT_DIR/scripts/development/install-monaspace.sh"
                ;;
            "LazyDocker")
                bash "$SCRIPT_DIR/scripts/development/lazydocker.sh"
                ;;
            "LazyGit")
                bash "$SCRIPT_DIR/scripts/development/lazygit.sh"
                ;;
            "Gum")
                echo "Already installed"
                ;;
            "btop")
                bash "$SCRIPT_DIR/scripts/development/btop.sh"
                ;;
            "Bat Tokyo Night")
                bash "$SCRIPT_DIR/scripts/development/bat-tokyonight.sh"
                ;;
            "Unclutter")
                bash "$SCRIPT_DIR/scripts/development/unclutter.sh"
                ;;
        esac
        
        echo "Done: $tool"
    done
}

normalize_role() {
    local input=$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr -d ' -_')
    case "$input" in
        devops|devopsengineer)
            echo "DevOps Engineer"
            ;;
        backend|backenddeveloper)
            echo "Backend Developer"
            ;;
        frontend|frontenddeveloper)
            echo "Frontend Developer"
            ;;
        cloud|cloudengineer)
            echo "Cloud Engineer"
            ;;
        network|networkengineer)
            echo "Network Engineer"
            ;;
        fullstack|fullstackdeveloper)
            echo "Fullstack Developer"
            ;;
        *)
            echo "$1"
            ;;
    esac
}

show_completion() {
    echo
    if command_exists gum; then
        gum style \
            --foreground 86 --border-foreground 86 --border double \
            --align center --width 60 --margin "1 2" --padding "2 4" \
            'Installation Complete!'
    else
        echo "=== Installation Complete! ==="
    fi
    
    echo
    echo "Copying configs..."
    mkdir -p ~/.config
    cp -r "$SCRIPT_DIR/config/"* ~/.config/ 2>/dev/null || true
    echo "Done"
    
    if [ "${NON_INTERACTIVE:-0}" -eq 1 ] || [ "${NO_EXEC_ZSH:-0}" -eq 1 ] || [ ! -t 0 ]; then
        echo "Non-interactive run completed successfully."
        return 0
    fi
    
    echo
    echo "Starting zsh..."
    exec zsh
}

main() {
    local cli_role=""
    local auto_yes=0
    local non_interactive=0

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --install-gum-only)
                bash "$SCRIPT_DIR/scripts/development/gum.sh"
                exit 0
                ;;
            -r|--role)
                cli_role="$2"
                shift 2
                ;;
            -y|--yes)
                auto_yes=1
                shift
                ;;
            --non-interactive)
                non_interactive=1
                export NON_INTERACTIVE=1
                shift
                ;;
            -h|--help)
                echo "DevNova - Environment Setup Tool"
                echo "Usage: ./install.sh [options] or ./devnova [options]"
                echo ""
                echo "Options:"
                echo "  -r, --role <ROLE>      Specify role (devops, backend, frontend, cloud, network, fullstack)"
                echo "  -y, --yes              Skip TUI confirmation prompt"
                echo "  --non-interactive      Run non-interactively without launching zsh at the end"
                echo "  --install-gum-only     Install gum TUI tool only"
                echo "  -h, --help             Show this help message"
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                exit 1
                ;;
        esac
    done

    if [ "$EUID" -eq 0 ]; then
        echo "Do not run as root"
        exit 1
    fi

    # Non-interactive CLI role execution path
    if [ -n "$cli_role" ]; then
        local target_role=$(normalize_role "$cli_role")
        local selected_tools=$(get_tools_for_role "$target_role")
        
        if [ -z "$selected_tools" ]; then
            echo "Error: Invalid or unknown role '$cli_role'"
            exit 1
        fi

        echo "=== DevNova Non-Interactive Install ==="
        echo "Target Role: $target_role"
        echo "Selected Tools:"
        echo "$selected_tools"
        echo "======================================"

        if [ "$auto_yes" -eq 1 ] || [ "$non_interactive" -eq 1 ] || [ ! -t 0 ]; then
            export NON_INTERACTIVE=1
            install_tools "$selected_tools"
            show_completion
            exit 0
        else
            if [ -f "$SCRIPT_DIR/bin/role-confirm" ]; then
                "$SCRIPT_DIR/bin/role-confirm" "$target_role"
                local confirm_result=$?
                if [ $confirm_result -eq 0 ]; then
                    install_tools "$selected_tools"
                    show_completion
                    exit 0
                else
                    echo "Installation cancelled."
                    exit 0
                fi
            else
                install_tools "$selected_tools"
                show_completion
                exit 0
            fi
        fi
    fi

    if ! command -v gum &> /dev/null; then
        echo "Gum not installed. Run: sudo $0 --install-gum-only"
        exit 1
    fi
    
    while true; do
        show_banner
        
        local selected_role=$(select_role)
        
        if [ -z "$selected_role" ]; then
            gum style --foreground 214 "No role selected"
            exit 0
        fi
        
        if [ "$selected_role" = "Custom Selection" ]; then
            local selected_tools=$(get_tools_for_role "$selected_role")
            
            if [ -z "$selected_tools" ]; then
                gum style --foreground 214 "No tools selected"
                continue
            fi
            
            if [ ! -f "$SCRIPT_DIR/bin/custom-confirm" ]; then
                log_error "custom-confirm tool not found. Please run ./build.sh first"
                exit 1
            fi
            
            local IFS=$'\n'
            local tools_array=($selected_tools)
            
            "$SCRIPT_DIR/bin/custom-confirm" "${tools_array[@]}"
            local confirm_result=$?
            
            if [ $confirm_result -eq 0 ]; then
                install_tools "$selected_tools"
                break
            elif [ $confirm_result -eq 2 ]; then
                continue
            else
                gum style --foreground 214 "Installation cancelled."
                exit 0
            fi
        else
            "$SCRIPT_DIR/bin/role-confirm" "$selected_role"
            local confirm_result=$?
            
            if [ $confirm_result -eq 0 ]; then
                local selected_tools=$(get_tools_for_role "$selected_role")
                install_tools "$selected_tools"
                break
            elif [ $confirm_result -eq 2 ]; then
                continue
            else
                gum style --foreground 214 "Installation cancelled."
                exit 0
            fi
        fi
    done
    
    show_completion
}

main "$@"
