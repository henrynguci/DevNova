#!/bin/bash

# Common Utility Functions

# Get script directory
get_script_dir() {
    echo "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect operating system
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command_exists apt-get; then
            echo "ubuntu"
        elif command_exists yum; then
            echo "centos"
        elif command_exists pacman; then
            echo "arch"
        elif command_exists dnf; then
            echo "fedora"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

# Install package based on OS
install_package() {
    local package=$1
    local os=$(detect_os)
    
    log_info "Installing $package..."
    
    case $os in
        "ubuntu")
            sudo apt-get install -y "$package"
            ;;
        "centos")
            sudo yum install -y "$package"
            ;;
        "fedora")
            sudo dnf install -y "$package"
            ;;
        "arch")
            sudo pacman -S --noconfirm "$package"
            ;;
        "macos")
            if command_exists brew; then
                brew install "$package"
            else
                log_error "Homebrew is not installed"
                return 1
            fi
            ;;
        *)
            log_error "Unsupported OS: $os"
            return 1
            ;;
    esac
}

# Create backup of file or directory
create_backup() {
    local target=$1
    local backup_suffix=$(date +%Y%m%d_%H%M%S)
    
    if [ -e "$target" ]; then
        local backup_path="${target}.backup.${backup_suffix}"
        log_info "Creating backup: $backup_path"
        mv "$target" "$backup_path"
        log_success "Backup created successfully"
        return 0
    else
        log_debug "No backup needed, target does not exist: $target"
        return 1
    fi
}

# Download file with progress
download_file() {
    local url=$1
    local output=$2
    
    log_info "Downloading from $url..."
    
    if command_exists wget; then
        wget -q --show-progress -O "$output" "$url"
    elif command_exists curl; then
        curl -L --progress-bar -o "$output" "$url"
    else
        log_error "Neither wget nor curl is available"
        return 1
    fi
    
    if [ $? -eq 0 ]; then
        log_success "Download completed: $output"
        return 0
    else
        log_error "Download failed"
        return 1
    fi
}

# Check if running as root
is_root() {
    [ "$EUID" -eq 0 ]
}

# Ensure not running as root
ensure_not_root() {
    if is_root; then
        log_error "This script should not be run as root"
        exit 1
    fi
}

# Ensure running as root
ensure_root() {
    if ! is_root; then
        log_error "This script must be run as root"
        exit 1
    fi
}

# Check if package is installed
is_installed() {
    local package=$1
    local os=$(detect_os)
    
    case $os in
        "ubuntu")
            dpkg -l "$package" 2>/dev/null | grep -q "^ii"
            ;;
        "centos"|"fedora")
            rpm -q "$package" >/dev/null 2>&1
            ;;
        "arch")
            pacman -Q "$package" >/dev/null 2>&1
            ;;
        "macos")
            brew list "$package" >/dev/null 2>&1
            ;;
        *)
            return 1
            ;;
    esac
}

# Update package manager
update_system() {
    local os=$(detect_os)
    
    log_info "Updating system packages..."
    
    case $os in
        "ubuntu")
            sudo apt-get update
            ;;
        "centos")
            sudo yum check-update || true
            ;;
        "fedora")
            sudo dnf check-update || true
            ;;
        "arch")
            sudo pacman -Sy
            ;;
        "macos")
            brew update
            ;;
    esac
    
    log_success "System updated"
}

# Confirm action with user
confirm() {
    local message=$1
    local default=${2:-"n"}
    
    if [ "$default" = "y" ]; then
        local prompt="$message [Y/n]: "
    else
        local prompt="$message [y/N]: "
    fi
    
    read -p "$prompt" -n 1 -r
    echo
    
    if [ "$default" = "y" ]; then
        [[ ! $REPLY =~ ^[Nn]$ ]]
    else
        [[ $REPLY =~ ^[Yy]$ ]]
    fi
}

# Add line to file if not exists
add_to_file_if_not_exists() {
    local line=$1
    local file=$2
    
    if ! grep -qF "$line" "$file" 2>/dev/null; then
        echo "$line" >> "$file"
        log_debug "Added to $file: $line"
        return 0
    else
        log_debug "Already exists in $file: $line"
        return 1
    fi
}

# Source file if exists
source_if_exists() {
    local file=$1
    if [ -f "$file" ]; then
        # shellcheck source=/dev/null
        source "$file"
        return 0
    fi
    return 1
}
