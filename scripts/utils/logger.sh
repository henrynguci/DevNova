#!/bin/bash

# Logger Utility

# Colors
readonly LOG_RED='\033[0;31m'
readonly LOG_GREEN='\033[0;32m'
readonly LOG_YELLOW='\033[1;33m'
readonly LOG_BLUE='\033[0;34m'
readonly LOG_PURPLE='\033[0;35m'
readonly LOG_CYAN='\033[0;36m'
readonly LOG_NC='\033[0m' # No Color

# Log file
LOG_FILE="${LOG_FILE:-$HOME/.devnova-install.log}"

# Verbosity level (0=quiet, 1=normal, 2=verbose)
VERBOSITY="${VERBOSITY:-1}"

# Initialize log file
init_log() {
    mkdir -p "$(dirname "$LOG_FILE")"
    echo "=== DevNova Installation Log - $(date) ===" >> "$LOG_FILE"
}

# Log to file
log_to_file() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

# Info message (blue)
log_info() {
    if [ "$VERBOSITY" -ge 1 ]; then
        echo -e "${LOG_BLUE}[INFO]${LOG_NC} $*"
    fi
    log_to_file "INFO: $*"
}

# Success message (green)
log_success() {
    if [ "$VERBOSITY" -ge 1 ]; then
        echo -e "${LOG_GREEN}[SUCCESS]${LOG_NC} $*"
    fi
    log_to_file "SUCCESS: $*"
}

# Warning message (yellow)
log_warning() {
    if [ "$VERBOSITY" -ge 1 ]; then
        echo -e "${LOG_YELLOW}[WARNING]${LOG_NC} $*" >&2
    fi
    log_to_file "WARNING: $*"
}

# Error message (red)
log_error() {
    echo -e "${LOG_RED}[ERROR]${LOG_NC} $*" >&2
    log_to_file "ERROR: $*"
}

# Debug message (cyan) - only shown in verbose mode
log_debug() {
    if [ "$VERBOSITY" -ge 2 ]; then
        echo -e "${LOG_CYAN}[DEBUG]${LOG_NC} $*"
    fi
    log_to_file "DEBUG: $*"
}

# Header message (purple)
log_header() {
    if [ "$VERBOSITY" -ge 1 ]; then
        echo -e "${LOG_PURPLE}================================${LOG_NC}"
        echo -e "${LOG_PURPLE} $*${LOG_NC}"
        echo -e "${LOG_PURPLE}================================${LOG_NC}"
    fi
    log_to_file "HEADER: $*"
}

# Step message (for progress indication)
log_step() {
    local current=$1
    local total=$2
    local message=$3
    
    if [ "$VERBOSITY" -ge 1 ]; then
        echo -e "${LOG_CYAN}[${current}/${total}]${LOG_NC} $message"
    fi
    log_to_file "STEP [$current/$total]: $message"
}

# Initialize log on source
init_log
