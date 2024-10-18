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
else
    echo "Zsh plugins are already installed."
fi

# Configure .zshrc
echo "Configuring .zshrc..."
if ! grep -q "plugins=(git zsh-autosuggestions zsh-syntax-highlighting)" ~/.zshrc; then
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
fi

# Add DevOps configurations to .zshrc
if ! grep -q "# DevOps aliases and configurations" ~/.zshrc; then
    echo "Adding DevOps configurations to .zshrc..."
    cat <<EOF >>~/.zshrc

# DevOps aliases and configurations
alias d='docker'
alias dc='docker-compose'
alias k='kubectl'
alias tf='terraform'
alias ans='ansible'

# Enable kubectl autocompletion
source <(kubectl completion zsh)

# Enable Docker autocompletion
if [ $commands[docker] ]; then
  source <(docker completion zsh)
fi

# Add local bin to PATH
export PATH=\$PATH:\$HOME/.local/bin

# NVM configuration (if you use Node Version Manager)
export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOF
else
    echo "DevOps configurations already exist in .zshrc."
fi

echo "=== Setup completed! ==="
echo "Please log out and log back in for Docker group changes to take effect."
echo "You may need to restart your terminal or run 'source ~/.zshrc' for some changes to apply."
