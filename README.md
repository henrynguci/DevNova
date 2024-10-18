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

Minh-Hung Trinh

## Contact

If you have any questions, suggestions, or just want to say hi, feel free to reach out:

- Email: moingucidev@gmail.com
- GitHub: (https://github.com/henrynguci)
- LinkedIn: (https://www.linkedin.com/in/trinh-hung194/)

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

## Conclusion

This Ubuntu DevOps Environment Setup project provides a comprehensive solution for quickly setting up a powerful development environment. By automating the installation and configuration of essential tools, it saves time and ensures consistency across different machines.

We encourage users to contribute to this project, whether by suggesting improvements, reporting bugs, or adding new features. Your feedback and contributions are valuable in making this tool even more useful for the DevOps community.

Thank you for using this setup tool, and happy coding!

