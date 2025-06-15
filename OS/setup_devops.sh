#!/bin/bash

# Script name
echo "=== DevOps Environment Setup Script ==="

# Update the system
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install basic tools
echo "Checking and installing basic tools..."
for tool in curl wget git unzip apt-transport-https ca-certificates gnupg lsb-release; do
    if ! command_exists $tool; then
        sudo apt install -y $tool
    else
        echo "$tool is already installed."
    fi
done

# Install Node.js and npm
if ! command_exists node; then
    echo "Installing Node.js and npm..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
else
    echo "Node.js is already installed."
fi

# Update npm to latest version
sudo npm install -g npm@latest

# Install Yarn
if ! command_exists yarn; then
    echo "Installing Yarn..."
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt update && sudo apt install -y yarn
else
    echo "Yarn is already installed."
fi

# Install Docker
if ! command_exists docker; then
    echo "Installing Docker..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    sudo usermod -aG docker $USER
else
    echo "Docker is already installed."
fi

# Install Docker Compose
if ! command_exists docker-compose; then
    echo "Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
else
    echo "Docker Compose is already installed."
fi

# Install Kubernetes tools
if ! command_exists kubectl; then
    echo "Installing Kubernetes tools..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
else
    echo "kubectl is already installed."
fi

if ! command_exists minikube; then
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
else
    echo "minikube is already installed."
fi

# Install Ansible
if ! command_exists ansible; then
    echo "Installing Ansible..."
    sudo apt install -y ansible
else
    echo "Ansible is already installed."
fi

# Install Terraform
if ! command_exists terraform; then
    echo "Installing Terraform..."
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    sudo apt update && sudo apt install -y terraform
else
    echo "Terraform is already installed."
fi

# Install AWS CLI
if ! command_exists aws; then
    echo "Installing AWS CLI..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf aws awscliv2.zip
else
    echo "AWS CLI is already installed."
fi

# Install Neovim
if ! command_exists nvim; then
    echo "Installing Neovim..."
    sudo apt install -y neovim
else
    echo "Neovim is already installed."
fi

# Setup Neovim configuration
echo "Setting up Neovim configuration..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CONFIG_SOURCE="$SCRIPT_DIR/../neovim/.config/nvim"
NVIM_CONFIG_TARGET="$HOME/.config/nvim"

if [ -d "$NVIM_CONFIG_SOURCE" ]; then
    echo "Found Neovim config at $NVIM_CONFIG_SOURCE"

    # Create .config directory if it doesn't exist
    mkdir -p "$HOME/.config"

    # Backup existing config if it exists
    if [ -d "$NVIM_CONFIG_TARGET" ]; then
        echo "Backing up existing Neovim config to ~/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$NVIM_CONFIG_TARGET" "$NVIM_CONFIG_TARGET.backup.$(date +%Y%m%d_%H%M%S)"
    fi

    # Copy the configuration
    cp -r "$NVIM_CONFIG_SOURCE" "$NVIM_CONFIG_TARGET"
    echo "Neovim configuration copied successfully!"
else
    echo "Warning: Neovim config not found at $NVIM_CONFIG_SOURCE"
fi

# Install bat (A cat clone with wings) from GitHub releases
if ! command_exists bat; then
    echo "Installing bat from GitHub releases..."

    # Get the latest version of bat
    BAT_VERSION=$(curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

    if [ -z "$BAT_VERSION" ]; then
        echo "Failed to get latest bat version, installing from apt..."
        sudo apt install -y bat
        # Create symbolic link if batcat is installed instead of bat
        if command_exists batcat && ! command_exists bat; then
            sudo ln -sf /usr/bin/batcat /usr/local/bin/bat
        fi
    else
        echo "Installing bat version $BAT_VERSION..."

        # Download and install the latest .deb package
        cd /tmp
        wget -q "https://github.com/sharkdp/bat/releases/download/${BAT_VERSION}/bat_${BAT_VERSION#v}_amd64.deb"

        if [ -f "bat_${BAT_VERSION#v}_amd64.deb" ]; then
            sudo dpkg -i "bat_${BAT_VERSION#v}_amd64.deb"
            rm -f "bat_${BAT_VERSION#v}_amd64.deb"
            echo "bat installed successfully from GitHub!"
        else
            echo "Failed to download bat package, installing from apt..."
            sudo apt install -y bat
            # Create symbolic link if batcat is installed instead of bat
            if command_exists batcat && ! command_exists bat; then
                sudo ln -sf /usr/bin/batcat /usr/local/bin/bat
            fi
        fi
    fi
else
    echo "bat is already installed."
fi

# Setup bat configuration with tokyonight theme
echo "Setting up bat configuration with tokyonight theme..."

# Create bat themes directory using bat's config-dir
echo "Creating bat themes directory..."
mkdir -p "$(bat --config-dir)/themes"

# Download and install tokyonight theme using bat-into-tokyonight
echo "Installing tokyonight theme for bat using bat-into-tokyonight..."
cd /tmp
git clone https://github.com/0xTadash1/bat-into-tokyonight
cd bat-into-tokyonight
./bat-into-tokyonight
cd ..
rm -rf bat-into-tokyonight
echo "Tokyonight theme installed successfully for bat!"

# Create bat config file with theme settings
BAT_CONFIG_DIR="$(bat --config-dir)"
cat <<EOF > "$BAT_CONFIG_DIR/config"
# Set the theme to tokyonight
--theme="tokyonight"

# Show line numbers, Git modifications and file header (but no grid)
--style="numbers,changes,header"

# Use italic text on the terminal (not supported on all terminals)
--italic-text=always

# Add mouse scrolling support in less (does not work with older versions of "less")
--pager="less -FR"

# Use C++ syntax (instead of C) for .h header files
--map-syntax "*.h:C++"

# Use "gitignore" highlighting for ".ignore" files
--map-syntax ".ignore:Git Ignore"
EOF

# Rebuild bat cache to include new theme
echo "Rebuilding bat cache..."
if command_exists bat; then
    bat cache --build
fi

echo "bat setup completed with tokyonight theme!"

# Install GeistMono Nerd Font
echo "Installing GeistMono Nerd Font..."

# Create fonts directory
mkdir -p ~/.local/share/fonts/GeistMonoNF

# Download and install GeistMono Nerd Font
echo "Downloading GeistMono Nerd Font..."
cd ~/.local/share/fonts/GeistMonoNF

# Download the latest GeistMono Nerd Font
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/GeistMono.zip

# Extract font files
echo "Extracting GeistMono font files..."
unzip GeistMono.zip

# Clean up zip file
rm GeistMono.zip

# Refresh font cache
echo "Refreshing font cache..."
fc-cache -fv

echo "GeistMono Nerd Font installed successfully!"

# Install fzf (fuzzy finder)
if ! command_exists fzf; then
    echo "Installing fzf (fuzzy finder)..."

    # Clone fzf repository
    if [ ! -d "$HOME/.fzf" ]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    fi

    # Install fzf with auto-completion and key bindings
    ~/.fzf/install --all --no-update-rc

    echo "fzf installed successfully!"
else
    echo "fzf is already installed."
fi

# Setup fzf configuration
echo "Setting up fzf configuration..."
FZF_CONFIG_DIR="$HOME/.config/fzf"
mkdir -p "$FZF_CONFIG_DIR"

# Create fzf configuration
cat <<EOF > "$FZF_CONFIG_DIR/config"
# fzf configuration
export FZF_DEFAULT_OPTS="
--height 40%
--layout=reverse
--border
--inline-info
--preview 'bat --color=always --style=numbers --line-range=:500 {}'
--preview-window right:50%:wrap
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796
"

# Use fd if available for better performance
if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="\$FZF_DEFAULT_COMMAND"
elif command -v rg >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git\.*" 2>/dev/null'

# Ctrl-R history search options
export FZF_CTRL_R_OPTS="
--preview 'echo {}'
--preview-window down:3:hidden:wrap
--bind '?:toggle-preview'
--color header:italic
"
EOF

echo "fzf configuration completed!"

# Configure Git
echo "Configuring Git..."
git config --global color.ui auto

# Prompt user to configure Git
if [ -z "$(git config --global user.name)" ] || [ -z "$(git config --global user.email)" ]; then
    echo "Please configure your Git username and email:"
    read -p "Enter your Git username: " git_username
    read -p "Enter your Git email: " git_email
    git config --global user.name "$git_username"
    git config --global user.email "$git_email"
else
    echo "Git is already configured with username and email."
fi

# Install Zsh
if ! command_exists zsh; then
    echo "Installing Zsh..."
    sudo apt install -y zsh
else
    echo "Zsh is already installed."
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh is already installed."
fi

# Set Zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Setting Zsh as default shell..."
    chsh -s $(which zsh)
else
    echo "Zsh is already the default shell."
fi

# Install Zsh plugins
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Installing Zsh plugins..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM}/plugins/zsh-completions
else
    echo "Zsh plugins are already installed."
fi

# Configure .zshrc
echo "Configuring .zshrc..."

# Clean up any existing problematic .bash_aliases file
if [ -f "$HOME/.bash_aliases" ]; then
    echo "Backing up existing .bash_aliases..."
    mv "$HOME/.bash_aliases" "$HOME/.bash_aliases.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Remove any conflicting alias sources from .zshrc
sed -i '/source.*\.bash_aliases/d' ~/.zshrc 2>/dev/null || true

# Ensure Oh My Zsh plugins are configured correctly
if ! grep -q "plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)" ~/.zshrc; then
    # Check if plugins line exists and update it
    if grep -q "^plugins=" ~/.zshrc; then
        sed -i 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)/' ~/.zshrc
    else
        # If no plugins line exists, add it after the Oh My Zsh path
        sed -i '/^export ZSH=/a plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)' ~/.zshrc
    fi
fi

# Ensure the Oh My Zsh source line exists
if ! grep -q "source \$ZSH/oh-my-zsh.sh" ~/.zshrc; then
    echo "source \$ZSH/oh-my-zsh.sh" >> ~/.zshrc
fi

# Add awesome DevOps configurations and aliases to .zshrc
if ! grep -q "# Awesome DevOps aliases and configurations" ~/.zshrc; then
    echo "Adding awesome DevOps configurations to .zshrc..."

    # First, ensure Oh My Zsh basic config exists
    if ! grep -q "export ZSH=" ~/.zshrc; then
        echo "Restoring Oh My Zsh basic configuration..."
        cat <<EOF > ~/.zshrc
# Path to your oh-my-zsh installation.
export ZSH="\$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo \$RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
# Standard plugins can be found in \$ZSH/plugins/
# Custom plugins may be added to \$ZSH_CUSTOM/plugins/
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)

source \$ZSH/oh-my-zsh.sh

EOF
    fi

    # Now append our DevOps configurations
    cat <<EOF >>~/.zshrc

# ===== Awesome DevOps aliases and configurations =====

# === System Management ===
alias cls='clear'
alias c='clear'
alias update='sudo apt update && sudo apt upgrade'
alias upgrade='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install'
alias search='apt search'
alias autoremove='sudo apt autoremove'
alias autoclean='sudo apt autoclean'

# === Navigation & File Operations ===
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'
alias md='mkdir -p'
alias rd='rmdir'
alias cat='bat'
alias less='bat'
alias more='bat'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# === Process Management ===
alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias myps='ps -f -u \$USER'
alias cpu='top -o cpu'
alias mem='top -o rsize'
alias kill9='kill -9'
alias jobs='jobs -l'

# === Networking ===
alias ping='ping -c 5'
alias fastping='ping -c 100 -s.2'
alias ports='netstat -tulanp'
alias listening='lsof -i -P | grep LISTEN'
alias myip='curl -s checkip.dyndns.org | grep -oE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"'
alias localip="ifconfig | grep 'inet ' | grep -v 127.0.0.1 | awk '{print \$2}'"

# === Docker Aliases ===
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs'
alias dstop='docker stop \$(docker ps -q)'
alias drm='docker rm \$(docker ps -aq)'
alias drmi='docker rmi \$(docker images -q)'
alias dprune='docker system prune -a'
alias dclean='docker system prune -af --volumes'

# === Kubernetes Aliases ===
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kgn='kubectl get nodes'
alias kdp='kubectl describe pod'
alias kds='kubectl describe service'
alias kdd='kubectl describe deployment'
alias kex='kubectl exec -it'
alias klog='kubectl logs'
alias kaf='kubectl apply -f'
alias kdf='kubectl delete -f'
alias kctx='kubectl config current-context'
alias kns='kubectl config set-context --current --namespace'

# === Git Aliases ===
alias g='git'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gs='git status'
alias gl='git log --oneline'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gm='git merge'
alias gd='git diff'
alias gf='git fetch'
alias gr='git reset'
alias grh='git reset --hard'
alias gst='git stash'
alias gstp='git stash pop'

# === Terraform Aliases ===
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias tfv='terraform validate'
alias tff='terraform fmt'
alias tfw='terraform workspace'
alias tfs='terraform show'

# === Ansible Aliases ===
alias ans='ansible'
alias ap='ansible-playbook'
alias av='ansible-vault'
alias ag='ansible-galaxy'

# === Node.js & NPM Aliases ===
alias ni='npm install'
alias nis='npm install --save'
alias nid='npm install --save-dev'
alias nig='npm install -g'
alias nu='npm uninstall'
alias nr='npm run'
alias ns='npm start'
alias nt='npm test'
alias nb='npm run build'
alias nls='npm list'
alias nlsg='npm list -g --depth=0'
alias y='yarn'
alias ya='yarn add'
alias yad='yarn add --dev'
alias yr='yarn remove'
alias ys='yarn start'
alias yt='yarn test'
alias yb='yarn build'

# === System Monitoring ===
alias df='df -H'
alias du='du -ch'
alias free='free -m'
alias pscpu='ps auxf | sort -nr -k 3'
alias psmem='ps auxf | sort -nr -k 4'
alias temp='sensors'
alias iostat='iostat -xtc 5 3'
alias nethogs='sudo nethogs'
alias iotop='sudo iotop'

# === File Compression ===
alias tarc='tar -czf'
alias tarx='tar -xzf'
alias untar='tar -xzf'
alias zip='zip -r'

# === Text Editors ===
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias nano='nano -w'

# === Utilities ===
alias h='history'
alias j='jobs -l'
alias path='echo -e \${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime='now'
alias nowdate='date +"%d-%m-%Y"'
alias week='date +%V'
alias myip='curl ipinfo.io/ip'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'
alias weather='curl wttr.in'

# === FZF Utilities ===
alias ff='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'
alias fh='history | fzf'
alias fp='ps aux | fzf'
alias fk='ps aux | fzf | awk "{print \$2}" | xargs kill'
alias fd='find . -type d | fzf'
alias fcd='cd \$(find . -type d | fzf)'
alias fe='nvim \$(fzf)'
alias fgb='git branch | fzf | xargs git checkout'

# === Safety Aliases ===
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# === Custom Functions ===
# Extract function for various archive formats
extract() {
    if [ -f \$1 ] ; then
        case \$1 in
            *.tar.bz2)   tar xjf \$1     ;;
            *.tar.gz)    tar xzf \$1     ;;
            *.bz2)       bunzip2 \$1     ;;
            *.rar)       unrar e \$1     ;;
            *.gz)        gunzip \$1      ;;
            *.tar)       tar xf \$1      ;;
            *.tbz2)      tar xjf \$1     ;;
            *.tgz)       tar xzf \$1     ;;
            *.zip)       unzip \$1       ;;
            *.Z)         uncompress \$1  ;;
            *.7z)        7z x \$1        ;;
            *)           echo "'\$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'\$1' is not a valid file"
    fi
}

# Create directory and navigate into it
mkcd() {
    mkdir -p "\$1" && cd "\$1"
}

# Find and kill process by name
fkill() {
    local pid
    if [ "\$UID" != "0" ]; then
        pid=\$(ps -f -u \$UID | sed 1d | fzf -m | awk '{print \$2}')
    else
        pid=\$(ps -ef | sed 1d | fzf -m | awk '{print \$2}')
    fi

    if [ "x\$pid" != "x" ]
    then
        echo \$pid | xargs kill -\${1:-9}
    fi
}

# === Enable autocompletion ===
# Enable kubectl autocompletion
if command -v kubectl >/dev/null 2>&1; then
    source <(kubectl completion zsh)
fi

# Enable Docker autocompletion
if [ \$commands[docker] ]; then
    source <(docker completion zsh)
fi

# Enable Terraform autocompletion
if command -v terraform >/dev/null 2>&1; then
    complete -C /usr/bin/terraform terraform
fi

# === Environment Variables ===
# Add local bin to PATH
export PATH=\$PATH:\$HOME/.local/bin

# Set default editor
export EDITOR='nvim'
export VISUAL='nvim'

# Set bat theme
export BAT_THEME='tokyonight_night'

# FZF configuration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.config/fzf/config ] && source ~/.config/fzf/config

# History settings
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zsh_history
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE

# NVM configuration (if you use Node Version Manager)
export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Welcome message
echo "🚀 Awesome DevOps environment loaded!"
echo "💡 Type 'alias' to see all available shortcuts"
echo "📖 Use 'extract <file>' to extract any archive"
echo "📁 Use 'mkcd <dir>' to create and enter directory"
echo "🔍 Use 'ff' for fuzzy file finder with preview"
echo "⚡ Use Ctrl+R for fuzzy history search"
echo "🎨 GeistMono Nerd Font installed for better terminal experience"
EOF
else
    echo "Awesome DevOps configurations already exist in .zshrc."
fi

echo "=== Setup completed! ==="

# Create a zshrc restore function
echo "Creating .zshrc backup and restore utilities..."
cat <<'EOF' > ~/.zshrc_restore.sh
#!/bin/bash
# .zshrc restore utility

restore_ohmyzsh_config() {
    echo "Restoring Oh My Zsh default configuration..."
    cat <<'ZSHRC' > ~/.zshrc
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications.
# For more details, see 'man strftime' or the 'man date' command.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
ZSHRC
    echo "Oh My Zsh configuration restored!"
    echo "Run 'source ~/.zshrc' to apply changes."
}

# Show usage
echo "Usage:"
echo "  source ~/.zshrc_restore.sh"
echo "  restore_ohmyzsh_config    # Restore clean Oh My Zsh config"
EOF

chmod +x ~/.zshrc_restore.sh

echo "📝 .zshrc restore utility created at ~/.zshrc_restore.sh"
echo "🔧 If your .zshrc gets corrupted, run: source ~/.zshrc_restore.sh && restore_ohmyzsh_config"

echo "=== Setup completed! ==="
echo "Please log out and log back in for Docker group changes to take effect."
echo "You may need to restart your terminal or run 'source ~/.zshrc' for some changes to apply."
echo ""
echo "🎉 Your awesome DevOps environment is ready!"
echo "🚀 Enjoy your enhanced terminal experience!"
