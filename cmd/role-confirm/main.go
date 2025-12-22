package main

import (
	"fmt"
	"os"
	"strings"

	"github.com/charmbracelet/bubbles/viewport"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

var (
	titleStyle = lipgloss.NewStyle().
			Bold(true).
			Foreground(lipgloss.Color("#7D56F4")).
			MarginLeft(2).
			MarginBottom(1)

	toolNameStyle = lipgloss.NewStyle().
			Bold(true).
			Foreground(lipgloss.Color("#00D7FF"))

	versionStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("#FFD700"))

	descStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("#FAFAFA")).
			MarginLeft(4)

	featureStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("#98C379")).
			MarginLeft(6)

	borderStyle = lipgloss.NewStyle().
			Border(lipgloss.RoundedBorder()).
			BorderForeground(lipgloss.Color("#7D56F4")).
			Padding(1, 2)

	selectedButtonStyle = lipgloss.NewStyle().
				Bold(true).
				Foreground(lipgloss.Color("#FFFFFF")).
				Background(lipgloss.Color("#7D56F4")).
				Padding(0, 3)

	buttonStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("#7D56F4")).
			Padding(0, 3)
)

type ToolInfo struct {
	Name        string
	Version     string
	Description string
	Features    []string
	Customizes  []string
}

type model struct {
	viewport       viewport.Model
	tools          []ToolInfo
	ready          bool
	selectedButton int
	confirmed      bool
	changeOptions  bool
	role           string
}

func getToolsForRole(role string) []ToolInfo {
	roleTools := map[string][]string{
		"DevOps Engineer": {
			"System Setup", "Docker", "Kubernetes", "Terraform",
			"Ansible", "AWS CLI", "Python", "Neovim", "Zsh",
			"LazyDocker", "LazyGit", "Gum", "btop", "Bat Tokyo Night", "Unclutter",
		},
		"Backend Developer": {
			"System Setup", "Docker", "Node.js", "Python", "Neovim",
			"Zsh", "LazyDocker", "LazyGit", "Gum", "btop", "Bat Tokyo Night", "Unclutter",
		},
		"Frontend Developer": {
			"System Setup", "Node.js", "Neovim", "Zsh", "LazyGit",
			"Gum", "btop", "Bat Tokyo Night", "Unclutter",
		},
		"Cloud Engineer": {
			"System Setup", "Docker", "Kubernetes", "Terraform", "AWS CLI",
			"Python", "Neovim", "Zsh", "LazyDocker", "Gum", "btop", "Bat Tokyo Night", "Unclutter",
		},
		"Network Engineer": {
			"System Setup", "Docker", "Ansible", "Python", "Neovim",
			"Zsh", "Gum", "btop", "Bat Tokyo Night", "Unclutter",
		},
		"Fullstack Developer": {
			"System Setup", "Docker", "Kubernetes", "Node.js", "Python",
			"Neovim", "Zsh", "WezTerm", "Monaspace Fonts", "LazyDocker",
			"LazyGit", "Gum", "btop", "Bat Tokyo Night", "Unclutter",
		},
	}

	toolNames, exists := roleTools[role]
	if !exists {
		return []ToolInfo{}
	}

	var tools []ToolInfo
	for _, name := range toolNames {
		tools = append(tools, getToolInfo(name))
	}
	return tools
}

func getToolInfo(name string) ToolInfo {
	toolData := map[string]ToolInfo{
		"System Setup": {
			Name:        "System Setup",
			Version:     "Core",
			Description: "Essential system configuration and package installation",
			Features: []string{
				"Determine project root directory",
				"Load logging utilities and common helper functions",
				"Define list of required system tools",
				"Detect operating system",
				"Update system package index",
			},
			Customizes: []string{
				"Check installed tools",
				"Install missing system tools",
				"Upgrade system packages",
			},
		},
		"Docker": {
			Name:        "Docker",
			Version:     "Latest",
			Description: "Container platform for developing, shipping, and running applications",
			Features: []string{
				"Add Docker official GPG key",
				"Configure Docker official repository",
				"Install Docker Engine and components",
				"Start and enable Docker service",
				"Add user to Docker group",
			},
			Customizes: []string{
				"Docker Compose installation",
				"User group configuration",
				"Service auto-start setup",
			},
		},
		"Kubernetes": {
			Name:        "Kubernetes",
			Version:     "Latest",
			Description: "Container orchestration platform",
			Features: []string{
				"kubectl CLI installation",
				"minikube local cluster",
				"Helm package manager",
				"Auto-completion setup",
			},
			Customizes: []string{
				"Shell completion",
				"Cluster configuration",
			},
		},
		"Terraform": {
			Name:        "Terraform",
			Version:     "Latest",
			Description: "Infrastructure as Code tool",
			Features: []string{
				"Download latest Terraform binary",
				"Install to /usr/local/bin",
				"Verify installation",
			},
			Customizes: []string{
				"Auto-completion",
			},
		},
		"Ansible": {
			Name:        "Ansible",
			Version:     "Latest",
			Description: "IT automation platform",
			Features: []string{
				"Install via package manager",
				"Python dependencies",
			},
			Customizes: []string{
				"Configuration directory setup",
			},
		},
		"AWS CLI": {
			Name:        "AWS CLI",
			Version:     "Latest",
			Description: "Amazon Web Services command line interface",
			Features: []string{
				"Download AWS CLI v2",
				"Install system-wide",
				"Verify installation",
			},
			Customizes: []string{
				"Auto-completion",
			},
		},
		"Node.js": {
			Name:        "Node.js",
			Version:     "Latest LTS via NVM",
			Description: "JavaScript runtime for server-side development",
			Features: []string{
				"Install NVM (Node Version Manager)",
				"Install Node.js LTS version",
				"Configure npm global packages",
			},
			Customizes: []string{
				"NVM auto-load in shell",
				"npm global directory",
			},
		},
		"Python": {
			Name:        "Python",
			Version:     "Latest via pyenv",
			Description: "High-level programming language",
			Features: []string{
				"Install pyenv",
				"Install Python latest version",
				"Install pip and virtualenv",
			},
			Customizes: []string{
				"pyenv auto-load in shell",
				"Virtual environment setup",
			},
		},
		"Neovim": {
			Name:        "Neovim",
			Version:     "Latest",
			Description: "Hyperextensible Vim-based text editor",
			Features: []string{
				"Install Neovim from PPA",
				"Install ripgrep, fd, bat",
				"Install LSP servers",
				"Setup Lazy.nvim plugin manager",
			},
			Customizes: []string{
				"LSP configuration",
				"Plugin manager setup",
				"Development tools integration",
			},
		},
		"Zsh": {
			Name:        "Zsh",
			Version:     "Latest",
			Description: "Powerful shell with advanced features and Oh My Zsh",
			Features: []string{
				"Install Zsh shell",
				"Install Oh My Zsh framework",
				"Install plugins (autosuggestions, syntax-highlighting)",
			},
			Customizes: []string{
				"Custom aliases",
				"History configuration",
				"Set as default shell",
			},
		},
		"WezTerm": {
			Name:        "WezTerm",
			Version:     "Latest",
			Description: "GPU-accelerated terminal emulator",
			Features: []string{
				"Download and install WezTerm",
				"Setup configuration",
			},
			Customizes: []string{
				"Font configuration",
				"Color scheme",
			},
		},
		"Monaspace Fonts": {
			Name:        "Monaspace Fonts",
			Version:     "Latest",
			Description: "Innovative superfamily of fonts for code",
			Features: []string{
				"Download Monaspace fonts",
				"Install OTF and Variable fonts",
				"Rebuild font cache",
			},
			Customizes: []string{
				"5 font families available",
				"Terminal configuration examples",
			},
		},
		"LazyDocker": {
			Name:        "LazyDocker",
			Version:     "Latest",
			Description: "Terminal UI for Docker management",
			Features: []string{
				"Download LazyDocker binary",
				"Install to /usr/local/bin",
			},
			Customizes: []string{
				"Interactive TUI",
			},
		},
		"LazyGit": {
			Name:        "LazyGit",
			Version:     "Latest",
			Description: "Terminal UI for git commands",
			Features: []string{
				"Download LazyGit binary",
				"Install to /usr/local/bin",
			},
			Customizes: []string{
				"Git workflow integration",
			},
		},
		"Gum": {
			Name:        "Gum",
			Version:     "Latest",
			Description: "Tool for glamorous shell scripts",
			Features: []string{
				"Already installed",
			},
			Customizes: []string{
				"Used by DevNova installer",
			},
		},
		"btop": {
			Name:        "btop",
			Version:     "Latest",
			Description: "Resource monitor with beautiful interface",
			Features: []string{
				"Install via package manager",
				"Setup configuration",
			},
			Customizes: []string{
				"Theme customization",
			},
		},
		"Bat Tokyo Night": {
			Name:        "Bat Tokyo Night Theme",
			Version:     "Latest",
			Description: "Tokyo Night theme for bat",
			Features: []string{
				"Clone theme repository",
				"Install to bat themes directory",
				"Rebuild bat cache",
			},
			Customizes: []string{
				"Theme activation",
			},
		},
		"Unclutter": {
			Name:        "Unclutter",
			Version:     "Latest",
			Description: "Hide mouse cursor when typing",
			Features: []string{
				"Install unclutter package",
				"Setup autostart configuration",
			},
			Customizes: []string{
				"Auto-start on login",
				"Timeout configuration",
			},
		},
	}

	info, exists := toolData[name]
	if !exists {
		return ToolInfo{
			Name:        name,
			Version:     "Latest",
			Description: "Tool installation and configuration",
			Features:    []string{"Standard installation"},
			Customizes:  []string{"Default configuration"},
		}
	}
	return info
}

func initialModel(role string) model {
	tools := getToolsForRole(role)
	vp := viewport.New(100, 20)
	vp.Style = borderStyle

	m := model{
		viewport:       vp,
		tools:          tools,
		selectedButton: 0,
		confirmed:      false,
		role:           role,
	}

	m.updateViewportContent()
	return m
}

func getRoleDescription(role string) string {
	descriptions := map[string]string{
		"DevOps Engineer":     "Complete DevOps toolkit with containerization, orchestration, IaC, and automation tools",
		"Backend Developer":   "Backend development environment with containers, runtime environments, and development tools",
		"Frontend Developer":  "Frontend development setup with Node.js, modern editor, and essential utilities",
		"Cloud Engineer":      "Cloud infrastructure tools including container orchestration, IaC, and cloud CLI",
		"Network Engineer":    "Network automation and management tools with Docker and Ansible",
		"Fullstack Developer": "Comprehensive full-stack development environment with frontend and backend tools",
	}

	desc, exists := descriptions[role]
	if !exists {
		return "Custom development environment setup"
	}
	return desc
}

func (m *model) updateViewportContent() {
	var content strings.Builder

	if m.role != "" {
		roleHeaderStyle := lipgloss.NewStyle().
			Bold(true).
			Foreground(lipgloss.Color("#FF79C6")).
			Background(lipgloss.Color("#282A36")).
			Padding(0, 2).
			MarginLeft(2).
			MarginBottom(1)

		roleDescStyle := lipgloss.NewStyle().
			Foreground(lipgloss.Color("#F8F8F2")).
			Italic(true).
			MarginLeft(2).
			MarginBottom(2)

		content.WriteString(roleHeaderStyle.Render(fmt.Sprintf("🚀 %s", m.role)))
		content.WriteString("\n")
		content.WriteString(roleDescStyle.Render(getRoleDescription(m.role)))
		content.WriteString("\n\n")
	}

	content.WriteString(titleStyle.Render("Selected tools for installation:"))
	content.WriteString("\n\n")

	if len(m.tools) == 0 {
		errorStyle := lipgloss.NewStyle().
			Foreground(lipgloss.Color("#FF5555")).
			MarginLeft(2)
		content.WriteString(errorStyle.Render("⚠ No tools selected"))
		content.WriteString("\n")
		m.viewport.SetContent(content.String())
		return
	}

	for i, tool := range m.tools {
		content.WriteString(toolNameStyle.Render(fmt.Sprintf("%d. %s", i+1, tool.Name)))
		content.WriteString(" ")
		content.WriteString(versionStyle.Render(fmt.Sprintf("(%s)", tool.Version)))
		content.WriteString("\n")

		content.WriteString(descStyle.Render(tool.Description))
		content.WriteString("\n\n")

		if len(tool.Features) > 0 {
			content.WriteString(descStyle.Render("Features:"))
			content.WriteString("\n")
			for _, feature := range tool.Features {
				content.WriteString(featureStyle.Render(fmt.Sprintf("• %s", feature)))
				content.WriteString("\n")
			}
		}

		if len(tool.Customizes) > 0 {
			content.WriteString("\n")
			content.WriteString(descStyle.Render("Customizations:"))
			content.WriteString("\n")
			for _, customize := range tool.Customizes {
				content.WriteString(featureStyle.Render(fmt.Sprintf("⚙ %s", customize)))
				content.WriteString("\n")
			}
		}

		content.WriteString("\n")
	}

	m.viewport.SetContent(content.String())
}

func (m model) Init() tea.Cmd {
	return nil
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.KeyMsg:
		switch msg.String() {
		case "q", "ctrl+c", "esc":
			m.confirmed = false
			return m, tea.Quit

		case "left", "h":
			if m.selectedButton > 0 {
				m.selectedButton--
			}

		case "right", "l":
			if m.selectedButton < 2 {
				m.selectedButton++
			}

		case "enter":
			if m.selectedButton == 0 {
				m.confirmed = true
				m.changeOptions = false
			} else if m.selectedButton == 1 {
				m.confirmed = false
				m.changeOptions = true
			} else {
				m.confirmed = false
				m.changeOptions = false
			}
			return m, tea.Quit
		}

	case tea.WindowSizeMsg:
		if !m.ready {
			m.viewport.Width = msg.Width - 4
			m.viewport.Height = msg.Height - 10
			m.ready = true
		}
	}

	var cmd tea.Cmd
	m.viewport, cmd = m.viewport.Update(msg)
	return m, cmd
}

func (m model) View() string {
	if !m.ready {
		return "\n  Initializing..."
	}

	var s strings.Builder

	s.WriteString("\n")
	s.WriteString(m.viewport.View())
	s.WriteString("\n\n")

	s.WriteString("  Do you want to install these tools?\n\n")

	yesButton := "Yes"
	changeButton := "Change Options"
	noButton := "No"

	if m.selectedButton == 0 {
		yesButton = selectedButtonStyle.Render("Yes")
		changeButton = buttonStyle.Render("Change Options")
		noButton = buttonStyle.Render("No")
	} else if m.selectedButton == 1 {
		yesButton = buttonStyle.Render("Yes")
		changeButton = selectedButtonStyle.Render("Change Options")
		noButton = buttonStyle.Render("No")
	} else {
		yesButton = buttonStyle.Render("Yes")
		changeButton = buttonStyle.Render("Change Options")
		noButton = selectedButtonStyle.Render("No")
	}

	s.WriteString(fmt.Sprintf("    %s        %s        %s\n\n", yesButton, changeButton, noButton))
	s.WriteString("  Use ← → or h/l to select, Enter to confirm, q to cancel\n")

	return s.String()
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: role-confirm <role-name>")
		os.Exit(1)
	}

	role := os.Args[1]

	p := tea.NewProgram(
		initialModel(role),
		tea.WithAltScreen(),
	)

	finalModel, err := p.Run()
	if err != nil {
		fmt.Printf("Error: %v", err)
		os.Exit(1)
	}

	m := finalModel.(model)
	if m.confirmed {
		os.Exit(0)
	} else if m.changeOptions {
		os.Exit(2)
	} else {
		os.Exit(1)
	}
}
