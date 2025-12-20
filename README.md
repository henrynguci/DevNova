# DevNova

Ubuntu DevOps Environment Setup - Automated installation toolkit

## Quick Start

```bash
git clone https://github.com/henrynguci/DevNova.git
cd DevNova
./install.sh
```

## Features

### Core DevOps Tools
- Docker & Docker Compose
- Kubernetes (kubectl, minikube)
- Terraform
- Ansible
- AWS CLI

### Development Tools
- Node.js, npm & Yarn
- Python 3 & pip
- Neovim with LSP

### Shell Environment
- Zsh & Oh My Zsh
- 100+ DevOps aliases
- Auto-suggestions & syntax highlighting

## Installation Options

| Option | Component |
|--------|-----------|
| 1 | System Setup |
| 2 | Docker |
| 3 | Kubernetes |
| 4 | Terraform |
| 5 | Ansible |
| 6 | AWS CLI |
| 7 | Node.js |
| 8 | Python |
| 9 | Neovim |
| 10 | Zsh |
| 20 | All Core Tools (1-6) |
| 21 | All Dev Tools (7-9) |
| 22 | Shell Tools (10) |
| 99 | Everything |

## Structure

```
devnova/
├── install.sh
├── scripts/
│   ├── utils/
│   ├── core/
│   ├── development/
│   └── shell/
└── configs/
    └── .config/
```

## Post-Installation

```bash
# Apply configs
cp -r configs/.config/* ~/.config/

# Start Zsh
zsh

# Verify
docker --version
kubectl version --client
terraform version
node --version
nvim --version
```

## Aliases

```bash
# Docker
d, dc, dps, dex, dlog, dprune

# Kubernetes
k, kgp, kgs, kex, klog, kaf

# Git
gfeat, gfix, gref, gdocs
gafeat, gafix

# Terraform
tf, tfi, tfp, tfa, tfd

# Navigation
.., ..., mkcd
```

## Requirements

- Ubuntu 20.04+
- 4GB RAM (8GB recommended)
- 20GB disk space
- Sudo access
- Internet connection

## License

MIT License

## Author

Minh-Hung Trinh
- Email: moingucidev@gmail.com
- GitHub: [@henrynguci](https://github.com/henrynguci)
