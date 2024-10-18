#!/bin/bash

# Đặt tên cho script
echo "=== Web Development Environment Setup Script ==="

# Cập nhật hệ thống
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Cài đặt các công cụ cơ bản
echo "Installing basic tools..."
sudo apt install -y curl wget git unzip

# Cài đặt Node.js và npm
echo "Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs
sudo npm install -g npm@latest

# Cài đặt Yarn
echo "Installing Yarn..."
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y yarn

# Cài đặt Docker
echo "Installing Docker..."
sudo apt install -y apt-transport-https ca-certificates gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER

# Cài đặt Docker Compose
echo "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

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
cat <<EOF >~/.vscode/extensions/themes/custom-theme.json
{
    "name": "Custom Theme",
    "type": "dark",
    "colors": {
        "editor.background": "#1E1E1E",
        "editor.foreground": "#D4D4D4",
        "activityBarBadge.background": "#007ACC",
        "sideBarTitle.foreground": "#BBBBBB"
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
            "scope": ["string"],
            "settings": {
                "foreground": "#CE9178"
            }
        }
    ]
}
EOF

# Cài đặt một số extension hữu ích cho VS Code
echo "Installing useful VS Code extensions..."
code --install-extension dbaeumer.vscode-eslint
code --install-extension esbenp.prettier-vscode
code --install-extension ms-azuretools.vscode-docker
code --install-extension ritwickdey.LiveServer

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
