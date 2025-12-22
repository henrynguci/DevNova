#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"
BIN_DIR="$PROJECT_ROOT/bin"

# Check if gum is installed
if ! command -v gum &> /dev/null; then
    echo "Error: gum is not installed."
    echo "Please install gum first by running: sudo ./install.sh --install-gum-only"
    exit 1
fi

# Check if Go is installed
check_go() {
    if command -v go &> /dev/null; then
        GO_VERSION=$(go version | awk '{print $3}')
        gum style --foreground 86 "✓ Go is already installed: $GO_VERSION"
        return 0
    else
        return 1
    fi
}

# Install Go with user confirmation
install_go() {
    echo
    gum style --foreground 214 --bold "Go is not installed!"
    echo
    gum style --foreground 86 "Go is required to build DevNova CLI tools."
    echo
    
    if gum confirm "Would you like to install Go now?"; then
        echo
        gum style --foreground 86 "Installing Go..."
        
        if bash "$SCRIPT_DIR/scripts/development/golang.sh"; then
            # Source the new PATH
            export PATH=$PATH:/usr/local/go/bin
            
            echo
            gum style --foreground 86 --bold "✓ Go installed successfully!"
            
            # Verify installation
            if command -v go &> /dev/null; then
                GO_VERSION=$(go version | awk '{print $3}')
                gum style --foreground 86 "Go version: $GO_VERSION"
                return 0
            else
                gum style --foreground 196 "Error: Go installation failed. Please restart your shell and try again."
                exit 1
            fi
        else
            gum style --foreground 196 "Error: Failed to install Go"
            exit 1
        fi
    else
        echo
        gum style --foreground 214 "Build cancelled. Please install Go manually and try again."
        exit 0
    fi
}

# Main build process
build_tools() {
    mkdir -p "$BIN_DIR"
    
    echo
    gum style --foreground 212 --bold "Building DevNova CLI tools..."
    echo
    
    gum spin --spinner dot --title "Building tool-info..." -- \
        go build -o "$BIN_DIR/tool-info" "$PROJECT_ROOT/cmd/tool-info/main.go"
    gum style --foreground 86 "  ✓ tool-info built"
    
    gum spin --spinner dot --title "Building role-confirm..." -- \
        go build -o "$BIN_DIR/role-confirm" "$PROJECT_ROOT/cmd/role-confirm/main.go"
    gum style --foreground 86 "  ✓ role-confirm built"
    
    gum spin --spinner dot --title "Building custom-confirm..." -- \
        go build -o "$BIN_DIR/custom-confirm" "$PROJECT_ROOT/cmd/custom-confirm/main.go"
    gum style --foreground 86 "  ✓ custom-confirm built"
    
    echo
    gum style \
        --foreground 86 --border-foreground 86 --border double \
        --align center --width 50 --margin "1 2" --padding "1 2" \
        'Build Complete! ✓'
    
    echo
    echo "Binaries are in: $BIN_DIR/"
    ls -lh "$BIN_DIR/"
}

# Main execution
main() {
    clear
    
    gum style \
        --foreground 212 --border-foreground 212 --border double \
        --align center --width 60 --margin "1 2" --padding "1 2" \
        'DevNova Build Script'
    
    # Check and install Go if needed
    if ! check_go; then
        install_go
    fi
    
    # Build the tools
    build_tools
}

main

