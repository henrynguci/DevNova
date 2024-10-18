#!/bin/bash

# Đặt tên cho script
echo "=== DevOps Environment Setup Script ==="

# Cập nhật hệ thống
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Cài đặt các công cụ cơ bản
echo "Installing basic tools..."
sudo apt install -y curl wget git unzip apt-transport-https ca-certificates gnupg lsb-release

# Cài đặt Docker
echo "Installing Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER

# Cài đặt Docker Compose
echo "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Cài đặt Kubernetes tools (kubectl, minikube)
echo "Installing Kubernetes tools..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Cài đặt Ansible
echo "Installing Ansible..."
sudo apt install -y ansible

# Cài đặt Terraform
echo "Installing Terraform..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update && sudo apt install -y terraform

# Cài đặt AWS CLI
echo "Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip

# Cài đặt Visual Studio Code
echo "Installing Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install -y code

# Tạo thư mục cho theme JSON tùy chỉnh
echo "Setting up custom JSON theme..."
mkdir -p ~/.vscode/extensions/themes
cat <<EOF >~/.vscode/extensions/themes/custom-devops-theme.json
{
    "name": "Custom DevOps Theme",
    "type": "dark",
    "colors": {
        "editor.background": "#1E1E1E",
        "editor.foreground": "#D4D4D4",
        "activityBarBadge.background": "#007ACC",
        "sideBarTitle.foreground": "#BBBBBB",
        "statusBar.background": "#007ACC",
        "statusBar.noFolderBackground": "#8C8C8C",
        "statusBar.debuggingBackground": "#CC6633"
    },
    "tokenColors": [
        {
            "scope": ["comment", "punctuation.definition.comment"],
            "settings": {
                "fontStyle": "italic",
                "foreground": "#6A9955"
            }
        },
        {
            "scope": ["string", "constant.other.symbol"],
            "settings": {
                "foreground": "#CE9178"
            }
        },
        {
            "scope": ["constant.numeric", "constant.language", "constant.character", "constant.other"],
            "settings": {
                "foreground": "#B5CEA8"
            }
        },
        {
            "scope": ["keyword", "storage.type", "storage.modifier"],
            "settings": {
                "foreground": "#569CD6"
            }
        }
    ]
}
EOF

# Cài đặt một số extension hữu ích cho VS Code
echo "Installing useful VS Code extensions for DevOps..."
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
code --install-extension redhat.vscode-yaml
code --install-extension hashicorp.terraform
code --install-extension ms-python.python
code --install-extension vscoss.vscode-ansible

# Cài đặt và cấu hình Git
echo "Configuring Git..."
git config --global color.ui auto

# Nhắc người dùng cấu hình Git
echo "Please configure your Git username and email:"
read -p "Enter your Git username: " git_username
read -p "Enter your Git email: " git_email
git config --global user.name "$git_username"
git config --global user.email "$git_email"

echo "=== Setup completed! ==="
echo "Please log out and log back in for Docker group changes to take effect."
echo "You may need to restart your terminal for some changes to apply."
