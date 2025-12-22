#!/bin/bash

set -e  # Exit on any error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/utils/logger.sh"
source "$SCRIPT_DIR/scripts/utils/common.sh"

VERSION="2.0.0"

show_banner() {
    clear
    gum style \
        --foreground 196 --border-foreground 196 --border double \
        --align center --width 70 --margin "1 2" --padding "1 2" \
        ' ███╗   ██╗  ██████╗  ██╗   ██╗  █████╗ ' \
        ' ████╗  ██║ ██╔═══██╗ ██║   ██║ ██╔══██╗' \
        ' ██╔██╗ ██║ ██║   ██║ ██║   ██║ ███████║' \
        ' ██║╚██╗██║ ██║   ██║ ╚██╗ ██╔╝ ██╔══██║' \
        ' ██║ ╚████║ ╚██████╔╝  ╚████╔╝  ██║  ██║' \
        ' ╚═╝  ╚═══╝  ╚═════╝    ╚═══╝   ╚═╝  ╚═╝' \
        '' \
        'DevNova v2.0 - Uninstaller'
}

# Function to handle cleanup on exit
cleanup_and_exit() {
    local exit_code=$?
    # If exit code is 130 (SIGINT/Ctrl+C), clear screen
    if [ $exit_code -eq 130 ]; then
        printf "\033[2J\033[H"
    fi
    exit $exit_code
}

select_tools() {
    gum style --foreground 86 "Select tools to uninstall (TAB to select, ENTER to confirm):" >&2
    echo >&2
    
    gum filter --no-limit --height 20 --indicator ">" --placeholder "Type to search..." \
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
        "Unclutter" \
        "All DevNova Configs"
}

confirm_uninstall() {
    local tools=$1
    
    local tools_trimmed=$(echo "$tools" | tr -d '[:space:]')
    if [ -z "$tools_trimmed" ]; then
        exit 0
    fi
    
    local tool_count=$(echo "$tools" | grep -v '^[[:space:]]*$' | wc -l)
    
    clear
    show_banner
    echo
    gum style --foreground 214 "You have selected $tool_count tool(s) to uninstall."
    echo "$tools" | while IFS= read -r tool; do
        [ -z "$tool" ] && continue
        echo "	$tool"
    done
    echo
    
    gum confirm "Are you SURE you want to uninstall these tools?"
    local confirm_exit=$?
    
    if [ $confirm_exit -eq 130 ]; then
        printf "\033[2J\033[H"
        exit 130
    elif [ $confirm_exit -ne 0 ]; then
        printf "\033[2J\033[H"
        exit 0
    fi
    
    return 0
}

uninstall_docker() {
    log_header "Uninstalling Docker"
    
    if command_exists docker; then
        sudo systemctl stop docker 2>/dev/null || true
        sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 2>/dev/null || true
        sudo rm -rf /var/lib/docker
        sudo rm -rf /var/lib/containerd
        sudo groupdel docker 2>/dev/null || true
        log_success "Docker uninstalled"
    else
        log_info "Docker is not installed"
    fi
}

uninstall_kubernetes() {
    log_header "Uninstalling Kubernetes Tools"
    
    if command_exists kubectl; then
        sudo rm -f /usr/local/bin/kubectl
        log_success "kubectl removed"
    fi
    
    if command_exists minikube; then
        minikube delete --all 2>/dev/null || true
        sudo rm -f /usr/local/bin/minikube
        rm -rf ~/.minikube
        log_success "minikube removed"
    fi
    
    if command_exists helm; then
        sudo rm -f /usr/local/bin/helm
        rm -rf ~/.helm
        log_success "helm removed"
    fi
}

uninstall_terraform() {
    log_header "Uninstalling Terraform"
    
    if command_exists terraform; then
        sudo rm -f /usr/local/bin/terraform
        rm -rf ~/.terraform.d
        log_success "Terraform uninstalled"
    else
        log_info "Terraform is not installed"
    fi
}

uninstall_ansible() {
    log_header "Uninstalling Ansible"
    
    if command_exists ansible; then
        sudo apt-get purge -y ansible 2>/dev/null || true
        sudo pip3 uninstall -y ansible 2>/dev/null || true
        rm -rf ~/.ansible
        log_success "Ansible uninstalled"
    else
        log_info "Ansible is not installed"
    fi
}

uninstall_aws() {
    log_header "Uninstalling AWS CLI"
    
    if command_exists aws; then
        sudo rm -rf /usr/local/aws-cli
        sudo rm -f /usr/local/bin/aws
        sudo rm -f /usr/local/bin/aws_completer
        rm -rf ~/.aws
        log_success "AWS CLI uninstalled"
    else
        log_info "AWS CLI is not installed"
    fi
}

uninstall_nodejs() {
    log_header "Uninstalling Node.js"
    
    if [ -d "$HOME/.nvm" ]; then
        rm -rf "$HOME/.nvm"
        sed -i '/NVM_DIR/d' ~/.bashrc ~/.zshrc 2>/dev/null || true
        log_success "NVM and Node.js uninstalled"
    else
        log_info "NVM is not installed"
    fi
}

uninstall_python() {
    log_header "Uninstalling Python Development Tools"
    
    if [ -d "$HOME/.pyenv" ]; then
        rm -rf "$HOME/.pyenv"
        sed -i '/PYENV_ROOT/d' ~/.bashrc ~/.zshrc 2>/dev/null || true
        log_success "pyenv uninstalled"
    else
        log_info "pyenv is not installed"
    fi
}

uninstall_neovim() {
    log_header "Uninstalling Neovim"
    
    if command_exists nvim; then
        sudo apt-get purge -y neovim 2>/dev/null || true
        sudo rm -f /usr/local/bin/nvim
        rm -rf ~/.local/share/nvim
        rm -rf ~/.cache/nvim
        log_success "Neovim uninstalled"
    else
        log_info "Neovim is not installed"
    fi
}

uninstall_zsh() {
    log_header "Uninstalling Zsh"
    
    if [ "$SHELL" = "$(which zsh)" ]; then
        chsh -s /bin/bash
        log_info "Default shell changed back to bash"
    fi
    
    if [ -d "$HOME/.oh-my-zsh" ]; then
        rm -rf "$HOME/.oh-my-zsh"
        log_success "Oh My Zsh removed"
    fi
    
    if command_exists zsh; then
        sudo apt-get purge -y zsh 2>/dev/null || true
        log_success "Zsh uninstalled"
    else
        log_info "Zsh is not installed"
    fi
}

uninstall_wezterm() {
    log_header "Uninstalling WezTerm"
    
    if command_exists wezterm; then
        sudo apt-get purge -y wezterm 2>/dev/null || true
        rm -rf ~/.config/wezterm
        log_success "WezTerm uninstalled"
    else
        log_info "WezTerm is not installed"
    fi
}

uninstall_monaspace() {
    log_header "Uninstalling Monaspace Fonts"
    
    if [ -d "$HOME/.local/share/fonts/monaspace" ]; then
        rm -rf "$HOME/.local/share/fonts/monaspace"
        fc-cache -f
        log_success "Monaspace fonts uninstalled"
    else
        log_info "Monaspace fonts are not installed"
    fi
}

uninstall_lazydocker() {
    log_header "Uninstalling LazyDocker"
    
    if command_exists lazydocker; then
        sudo rm -f /usr/local/bin/lazydocker
        rm -rf ~/.config/lazydocker
        log_success "LazyDocker uninstalled"
    else
        log_info "LazyDocker is not installed"
    fi
}

uninstall_lazygit() {
    log_header "Uninstalling LazyGit"
    
    if command_exists lazygit; then
        sudo rm -f /usr/local/bin/lazygit
        rm -rf ~/.config/lazygit
        log_success "LazyGit uninstalled"
    else
        log_info "LazyGit is not installed"
    fi
}

uninstall_gum() {
    log_header "Uninstalling Gum"
    
    if command_exists gum; then
        sudo rm -f /usr/local/bin/gum
        log_success "Gum uninstalled"
    else
        log_info "Gum is not installed"
    fi
}

uninstall_btop() {
    log_header "Uninstalling btop"
    
    if command_exists btop; then
        sudo apt-get purge -y btop 2>/dev/null || true
        sudo rm -f /usr/local/bin/btop
        rm -rf ~/.config/btop
        log_success "btop uninstalled"
    else
        log_info "btop is not installed"
    fi
}

uninstall_bat_tokyonight() {
    log_header "Uninstalling Bat Tokyo Night Theme"
    
    local bat_cmd="bat"
    if command_exists batcat; then
        bat_cmd="batcat"
    fi
    
    if command_exists $bat_cmd; then
        local themes_dir="$(command $bat_cmd --config-dir)/themes"
        if [ -d "$themes_dir/tokyonight.nvim" ]; then
            rm -rf "$themes_dir/tokyonight.nvim"
            command $bat_cmd cache --build
            log_success "Bat Tokyo Night theme uninstalled"
        else
            log_info "Bat Tokyo Night theme is not installed"
        fi
    else
        log_info "bat is not installed"
    fi
}

uninstall_unclutter() {
    log_header "Uninstalling Unclutter"
    
    pkill unclutter 2>/dev/null || true
    
    if command_exists unclutter; then
        sudo apt-get purge -y unclutter 2>/dev/null || true
        rm -f ~/.config/autostart/unclutter.desktop
        log_success "Unclutter uninstalled"
    else
        log_info "Unclutter is not installed"
    fi
}

remove_all_configs() {
    log_header "Removing All DevNova Configurations"
    
    if [ -d "$HOME/.config/devnova" ]; then
        rm -rf "$HOME/.config/devnova"
        log_success "DevNova configs removed"
    fi
    
    sed -i '/DevNova/d' ~/.bashrc ~/.zshrc 2>/dev/null || true
    sed -i '/devnova/d' ~/.bashrc ~/.zshrc 2>/dev/null || true
    
    log_success "All DevNova configurations removed"
}

uninstall_tools() {
    local tools="$1"
    local total=$(echo "$tools" | wc -l)
    local current=0
    
    local IFS=$'\n'
    for tool in $tools; do
        [ -z "$tool" ] && continue
        current=$((current + 1))
        
        echo
        echo "[$current/$total] Uninstalling $tool..."
        
        case "$tool" in
            "Docker")
                uninstall_docker
                ;;
            "Kubernetes")
                uninstall_kubernetes
                ;;
            "Terraform")
                uninstall_terraform
                ;;
            "Ansible")
                uninstall_ansible
                ;;
            "AWS CLI")
                uninstall_aws
                ;;
            "Node.js")
                uninstall_nodejs
                ;;
            "Python")
                uninstall_python
                ;;
            "Neovim")
                uninstall_neovim
                ;;
            "Zsh")
                uninstall_zsh
                ;;
            "WezTerm")
                uninstall_wezterm
                ;;
            "Monaspace Fonts")
                uninstall_monaspace
                ;;
            "LazyDocker")
                uninstall_lazydocker
                ;;
            "LazyGit")
                uninstall_lazygit
                ;;
            "Gum")
                uninstall_gum
                ;;
            "btop")
                uninstall_btop
                ;;
            "Bat Tokyo Night")
                uninstall_bat_tokyonight
                ;;
            "Unclutter")
                uninstall_unclutter
                ;;
            "All DevNova Configs")
                remove_all_configs
                ;;
        esac
        
        echo "Done: $tool"
    done
}

show_completion() {
    echo
    gum style \
        --foreground 196 --border-foreground 196 --border double \
        --align center --width 60 --margin "1 2" --padding "2 4" \
        'Uninstall Complete!'
    
    echo
    log_info "Selected tools have been uninstalled"
    echo
}

main() {
    if [ "$EUID" -eq 0 ]; then
        echo "Do not run as root"
        exit 1
    fi
    
    if ! command -v gum &> /dev/null; then
        echo "Gum not installed. Cannot run uninstaller without gum."
        exit 1
    fi
    
    show_banner
    
    local selected_tools
    selected_tools=$(select_tools)
    local select_exit=$?
    
    if [ $select_exit -eq 130 ]; then
        printf "\033[2J\033[H"
        exit 130
    fi
    
    if [ $select_exit -ne 0 ] || [ -z "$selected_tools" ]; then
        printf "\033[2J\033[H"
        exit 0
    fi
    
    confirm_uninstall "$selected_tools"
    uninstall_tools "$selected_tools"
    show_completion
}

main "$@"
