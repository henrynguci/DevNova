# Ubuntu DevOps Environment Setup

## Table of Contents
1. [Introduction](#introduction)
2. [Features](#features)
3. [System Requirements](#system-requirements)
4. [Installation](#installation)
5. [Usage](#usage)
6. [Project Structure](#project-structure)
7. [Customization](#customization)
8. [Troubleshooting](#troubleshooting)
9. [Contributing](#contributing)
10. [License](#license)
11. [Author](#author)
12. [Contact](#contact)
13. [Acknowledgements](#acknowledgements)
14. [Changelog](#changelog)
15. [Roadmap](#roadmap)
16. [Disclaimer](#disclaimer)

## Introduction

This project provides a comprehensive set of automated scripts to install and configure a DevOps environment on Ubuntu, with a focus on Neovim setup and system configuration. The aim is to quickly establish a fully-featured working environment after a fresh Ubuntu installation, tailored for DevOps professionals and developers.

## Features

- **System Updates and Essential Packages**: Ensures your Ubuntu system is up-to-date and installs essential development packages.
- **DevOps Tools Installation**:
  - Docker and Docker Compose
  - Kubernetes (kubectl, minikube)
  - Ansible
  - Terraform
  - Git with advanced configuration
- **Neovim Setup**:
  - Installation of the latest Neovim version
  - Custom configuration optimized for development
  - Plugin management using vim-plug
  - Language server protocols (LSP) setup for various programming languages
  - Fuzzy finder (fzf) integration
  - Custom keybindings and themes
- **Shell Environment Configuration**:
  - Oh My Posh installation with a custom theme
  - Bash and Zsh configurations with useful aliases
  - Integration of fzf for enhanced command-line navigation
- **PostgreSQL Installation and Configuration**
- **Python Development Environment**:
  - Python 3 installation
  - pip and virtual environment setup
  - Installation of common data science libraries (numpy, pandas, matplotlib)
- **Node.js and npm Installation**
- **Visual Studio Code Installation** (optional)

## System Requirements

- Ubuntu 20.04 LTS or newer
- Minimum 4GB RAM (8GB recommended)
- At least 20GB of free disk space
- Sudo privileges
- Internet connection for downloading packages and tools

## Installation

1. Clone this repository:
   ```
   git clone https://github.com/your-username/ubuntu-devops-setup.git
   ```

2. Navigate to the project directory:
   ```
   cd ubuntu-devops-setup
   ```

3. Make the setup script executable:
   ```
   chmod +x setup.sh
   ```

4. Run the setup script:
   ```
   ./setup.sh
   ```

5. Follow the on-screen prompts to customize your installation.

## Usage

After installation, you can start using your newly configured environment:

- Launch Neovim by typing `nvim` in the terminal
- Access Docker commands directly from the terminal
- Use `kubectl` for Kubernetes operations
- Run Ansible playbooks with the `ansible-playbook` command
- Manage infrastructure with Terraform using the `terraform` command
- Enjoy your customized shell environment with Oh My Posh

For detailed usage instructions of specific tools, refer to their respective documentation.

## Project Structure

```
ubuntu-devops-setup/
│
├── setup.sh                 # Main setup script
├── configs/                 # Configuration files
│   ├── neovim/
│   │   ├── init.vim         # Neovim configuration
│   │   └── plugins.vim      # Neovim plugins list
│   ├── oh-my-posh/
│   │   └── custom.omp.json  # Oh My Posh theme
│   ├── git/
│   │   └── .gitconfig       # Git global configuration
│   └── shell/
│       ├── .bashrc          # Bash configuration
│       └── .zshrc           # Zsh configuration
├── scripts/
│   ├── install_docker.sh    # Docker installation script
│   ├── install_kubernetes.sh # Kubernetes installation script
│   ├── setup_python_env.sh  # Python environment setup
│   └── configure_postgres.sh # PostgreSQL configuration script
├── LICENSE
└── README.md
```

## Customization

- Neovim: Edit `configs/neovim/init.vim` and `configs/neovim/plugins.vim`
- Oh My Posh: Modify `configs/oh-my-posh/custom.omp.json`
- Shell: Adjust `configs/shell/.bashrc` or `configs/shell/.zshrc`
- Git: Update `configs/git/.gitconfig`

To add or remove features, edit the main `setup.sh` script.

## Troubleshooting

If you encounter any issues during installation or usage:

1. Check the logs in `~/setup_logs.txt`
2. Ensure all system requirements are met
3. Verify your internet connection
4. For Neovim issues, try running `:checkhealth` within Neovim

If problems persist, please open an issue on the GitHub repository.

## Contributing

Contributions are welcome and appreciated! Here's how you can contribute:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please ensure your code adheres to the project's coding standards and include appropriate tests if applicable.

## License

This project is distributed under the MIT License. See the `LICENSE` file for more information.

## Author

[Your Name]

## Contact

If you have any questions, suggestions, or just want to say hi, feel free to reach out:

- Email: [your.email@example.com]
- GitHub: [@your-username](https://github.com/your-username)
- LinkedIn: [Your LinkedIn Profile](https://www.linkedin.com/in/your-profile/)

## Acknowledgements

- [Neovim](https://neovim.io/) - The core of our text editing experience
- [Oh My Posh](https://ohmyposh.dev/) - For the beautiful terminal prompts
- [Docker](https://www.docker.com/) - Containerization made easy
- [Kubernetes](https://kubernetes.io/) - For container orchestration
- [Ansible](https://www.ansible.com/) - Automation for everyone
- [Terraform](https://www.terraform.io/) - Infrastructure as Code
- [PostgreSQL](https://www.postgresql.org/) - The world's most advanced open source database

## Changelog

- v1.0.0 (2024-10-18)
  - Initial release
  - Basic DevOps tools installation
  - Neovim configuration
  - Shell environment setup

## Roadmap

- [ ] Add support for additional Linux distributions
- [ ] Implement CI/CD pipeline configurations
- [ ] Include more language-specific development environments
- [ ] Create a web-based configuration tool
- [ ] Add automatic backup and restore functionality

## Disclaimer

This script is provided as-is, without any warranty. While we've taken care to ensure it works correctly, please review the scripts before running them on your system. Always backup your important data before making significant system changes.

---

## Appendix: Key Configuration Files

### Neovim Configuration (init.vim)

```vim
" Basic Settings
set number
set relativenumber
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent
set nowrap
set ignorecase
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
set noshowmode
set updatetime=300
set encoding=UTF-8
set mouse=a

" Plugins (using vim-plug)
call plug#begin('~/.vim/plugged')
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'kyazdani42/nvim-web-devicons'
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'folke/tokyonight.nvim'
call plug#end()

" Color Scheme
colorscheme tokyonight

" Key Mappings
let mapleader = " "
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" LSP Configuration
lua << EOF
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap=true, silent=true }

  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

local servers = { 'pyright', 'tsserver', 'gopls' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF

" Treesitter Configuration
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
  },
}
EOF

" Lualine Configuration
lua << EOF
require('lualine').setup {
  options = {
    theme = 'tokyonight'
  }
}
EOF

" GitSigns Configuration
lua << EOF
require('gitsigns').setup()
EOF
```

### Oh My Posh Configuration (custom.omp.json)

```json
{
  "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
  "blocks": [
    {
      "alignment": "left",
      "segments": [
        {
          "background": "#ff479c",
          "foreground": "#ffffff",
          "leading_diamond": "\ue0b6",
          "style": "diamond",
          "template": " {{ .UserName }} ",
          "type": "session"
        },
        {
          "background": "#ff8a65",
          "foreground": "#ffffff",
          "powerline_symbol": "\ue0b0",
          "properties": {
            "style": "folder"
          },
          "style": "powerline",
          "template": " {{ .Path }} ",
          "type": "path"
        },
        {
          "background": "#c5e478",
          "foreground": "#193549",
          "powerline_symbol": "\ue0b0",
          "properties": {
            "branch_icon": "\ue725 ",
            "fetch_stash_count": true,
            "fetch_status": true,
            "fetch_upstream_icon": true
          },
          "style": "powerline",
          "template": " {{ .HEAD }} {{ if .BranchStatus }}{{ .BranchStatus }}{{ end }}{{ if .Staged }} \uf046 {{ .Staged }}{{ end }}{{ if .Modified }} \uf044 {{ .Modified }}{{ end }}{{ if .Stashes }} \uf692 {{ .Stashes }}{{ end }} ",
          "type": "git"
        }
      ],
      "type": "prompt"
    }
  ],
  "final_space": true,
  "version": 2
}
```

### Bash Configuration (.bashrc additions)

```bash
# Oh My Posh initialization
eval "$(oh-my-posh init bash --config ~/.poshthemes/custom.omp.json)"

# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias update='sudo apt update && sudo apt upgrade -y'
alias k='kubectl'
alias d='docker'
alias tf='terraform'

# fzf integration
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# NVM (Node Version Manager) setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Python virtual environment
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/projects
source /usr/local/bin/virtualenvwrapper.sh

# Go language setup
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# Rust setup
source $HOME/.cargo/env
```

### Zsh Configuration (.zshrc additions)

```zsh
# Oh My Posh initialization
eval "$(oh-my-posh init zsh --config ~/.poshthemes/custom.omp.json)"

# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias update='sudo apt update && sudo apt upgrade -y'
alias k='kubectl'
alias d='docker'
alias tf='terraform'

# fzf integration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# NVM (Node Version Manager) setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Python virtual environment
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/projects
source /usr/local/bin/virtualenvwrapper.sh

# Go language setup
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# Rust setup
source $HOME/.cargo/env

# ZSH-specific settings
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
```

### Git Configuration (.gitconfig)

```ini
[user]
    name = Your Name
    email = your.email@example.com
[core]
    editor = nvim
    whitespace = fix,-indent-with-non-tab,trailing-space,cr-at-eol
    excludesfile = ~/.gitignore_global
[color]
    ui = auto
[alias]
    st = status
    ci = commit
    br = branch
    co = checkout
    df = diff
    lg = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
[pull]
    rebase = false
[init]
    defaultBranch = main
```

## Additional Setup Instructions

### PostgreSQL Setup

After installation, you may want to secure your PostgreSQL installation:

1. Switch to the postgres user:
   ```
   sudo -i -u postgres
   ```

2. Access the PostgreSQL prompt:
   ```
   psql
   ```

3. Set a password for the postgres user:
   ```sql
   ALTER USER postgres WITH PASSWORD 'your_password';
   ```

4. Exit the PostgreSQL prompt:
   ```
   \q
   ```

5. Exit the postgres user shell:
   ```
   exit
   ```

### Docker Post-installation Steps

To use Docker without sudo, add your user to the docker group:

```bash
sudo usermod -aG docker $USER
```

Log out and back in for this to take effect.

### Kubernetes (Minikube) Post-installation Steps

Start Minikube:

```bash
minikube start
```

Verify the installation:

```bash
kubectl get nodes
```

### Python Virtual Environment Usage

Create a new virtual environment:

```bash
mkvirtualenv my_project
```

Activate a virtual environment:

```bash
workon my_project
```

Deactivate the current virtual environment:

```bash
deactivate
```

## Maintenance and Updates

To keep your development environment up-to-date:

1. Regularly update your system:
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

2. Update Neovim plugins:
   - Open Neovim and run `:PlugUpdate`

3. Update Oh My Posh:
   ```bash
   sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
   sudo chmod +x /usr/local/bin/oh-my-posh
   ```

4. Update Docker:
   ```bash
   sudo apt-get update
   sudo apt-get install docker-ce docker-ce-cli containerd.io
   ```

5. Update Kubernetes tools:
   ```bash
   sudo apt-get update
   sudo apt-get install -y kubectl
   ```

6. Update Minikube:
   ```bash
   minikube update-check
   minikube delete
   curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
   sudo install minikube-linux-amd64 /usr/local/bin/minikube
   ```

7. Update Ansible:
   ```bash
   sudo apt update
   sudo apt install --only-upgrade ansible
   ```

8. Update Terraform:
   ```bash
   sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
   wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
   sudo apt update && sudo apt install terraform
   ```

Remember to check the official documentation of each tool for the most up-to-date upgrade instructions.

## Conclusion

This Ubuntu DevOps Environment Setup project provides a comprehensive solution for quickly setting up a powerful development environment. By automating the installation and configuration of essential tools, it saves time and ensures consistency across different machines.

We encourage users to contribute to this project, whether by suggesting improvements, reporting bugs, or adding new features. Your feedback and contributions are valuable in making this tool even more useful for the DevOps community.

Thank you for using this setup tool, and happy coding!

