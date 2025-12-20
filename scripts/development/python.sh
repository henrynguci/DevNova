#!/bin/bash

# Python Development Environment Setup Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/scripts/utils/logger.sh"
source "$SCRIPT_DIR/scripts/utils/common.sh"

# Install Python and pip
install_python() {
    log_header "Installing Python and pip"
    
    if command_exists python3; then
        log_info "Python3 is already installed: $(python3 --version)"
    else
        local os=$(detect_os)
        
        case $os in
            "ubuntu")
                sudo apt-get install -y python3 python3-pip python3-venv
                ;;
            "centos"|"fedora")
                sudo yum install -y python3 python3-pip
                ;;
            "arch")
                sudo pacman -S --noconfirm python python-pip
                ;;
            "macos")
                brew install python
                ;;
            *)
                log_error "Unsupported OS for Python installation"
                return 1
                ;;
        esac
        
        log_success "Python installed successfully"
    fi
    
    # Upgrade pip
    log_info "Upgrading pip..."
    python3 -m pip install --upgrade pip
}

# Install pynvim for Neovim support
install_pynvim() {
    log_info "Installing pynvim for Neovim support..."
    python3 -m pip install --user pynvim
    log_success "pynvim installed"
}

# Install common Python libraries
install_python_libraries() {
    log_header "Installing Common Python Libraries"
    
    local libraries=(
        "virtualenv"
        "pipenv"
        "black"
        "flake8"
        "pylint"
        "pytest"
    )
    
    for lib in "${libraries[@]}"; do
        log_info "Installing $lib..."
        python3 -m pip install --user "$lib"
    done
    
    log_success "Python libraries installed"
}

main() {
    log_header "Python Development Setup"
    
    install_python
    install_pynvim
    
    if confirm "Do you want to install common Python development libraries?" "y"; then
        install_python_libraries
    fi
    
    log_success "Python development setup completed"
    log_info "Python version: $(python3 --version)"
    log_info "pip version: $(python3 -m pip --version)"
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    main "$@"
fi
