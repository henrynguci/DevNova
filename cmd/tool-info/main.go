package main

import (
	"fmt"
	"os"
	"strings"

	"github.com/charmbracelet/bubbles/progress"
	"github.com/charmbracelet/bubbles/viewport"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

var (
	titleStyle = lipgloss.NewStyle().
			Bold(true).
			Foreground(lipgloss.Color("#7D56F4")).
			MarginLeft(2)

	descStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("#FAFAFA")).
			MarginLeft(2).
			MarginRight(2)

	progressBarStyle = lipgloss.NewStyle().
				Foreground(lipgloss.Color("#7D56F4"))
)

type model struct {
	viewport    viewport.Model
	progress    progress.Model
	toolName    string
	description string
	version     string
	features    []string
	percent     float64
	ready       bool
}

func initialModel(toolName, description, version string, features []string) model {
	vp := viewport.New(80, 20)
	vp.Style = lipgloss.NewStyle().
		Border(lipgloss.RoundedBorder()).
		BorderForeground(lipgloss.Color("#7D56F4")).
		Padding(1, 2)

	prog := progress.New(
		progress.WithDefaultGradient(),
		progress.WithWidth(60),
	)

	m := model{
		viewport:    vp,
		progress:    prog,
		toolName:    toolName,
		description: description,
		version:     version,
		features:    features,
		percent:     0.0,
	}

	m.updateViewportContent()
	return m
}

func (m *model) updateViewportContent() {
	var content strings.Builder

	content.WriteString(titleStyle.Render(fmt.Sprintf("📦 %s", m.toolName)))
	content.WriteString("\n\n")

	content.WriteString(descStyle.Render(fmt.Sprintf("Version: %s", m.version)))
	content.WriteString("\n\n")

	content.WriteString(descStyle.Render("Description:"))
	content.WriteString("\n")
	content.WriteString(descStyle.Render(m.description))
	content.WriteString("\n\n")

	if len(m.features) > 0 {
		content.WriteString(descStyle.Render("Features:"))
		content.WriteString("\n")
		for _, feature := range m.features {
			content.WriteString(descStyle.Render(fmt.Sprintf("  • %s", feature)))
			content.WriteString("\n")
		}
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
			return m, tea.Quit
		}

	case tea.WindowSizeMsg:
		if !m.ready {
			m.viewport.Width = msg.Width - 4
			m.viewport.Height = msg.Height - 8
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

	if m.percent > 0 {
		s.WriteString("  ")
		s.WriteString(m.progress.ViewAs(m.percent))
		s.WriteString("\n")
	}

	s.WriteString("\n  Press q to continue\n")

	return s.String()
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: tool-info <tool-name>")
		os.Exit(1)
	}

	toolName := os.Args[1]

	toolInfo := map[string]struct {
		description string
		version     string
		features    []string
	}{
		"Docker": {
			description: "Docker is a platform for developing, shipping, and running applications in containers. It enables you to separate your applications from your infrastructure for fast software delivery.",
			version:     "Latest (24.x)",
			features: []string{
				"Container orchestration and management",
				"Image building with Dockerfile",
				"Docker Compose for multi-container apps",
				"Integration with Kubernetes",
				"Cross-platform support (Linux, Windows, macOS)",
			},
		},
		"Kubernetes": {
			description: "Kubernetes is an open-source container orchestration platform that automates deployment, scaling, and management of containerized applications.",
			version:     "Latest (1.29.x)",
			features: []string{
				"Automated rollouts and rollbacks",
				"Service discovery and load balancing",
				"Storage orchestration",
				"Self-healing capabilities",
				"Horizontal scaling",
			},
		},
		"Terraform": {
			description: "Terraform is an infrastructure as code tool that lets you build, change, and version cloud and on-prem resources safely and efficiently.",
			version:     "Latest (1.7.x)",
			features: []string{
				"Multi-cloud infrastructure provisioning",
				"Declarative configuration language (HCL)",
				"State management",
				"Plan and apply workflow",
				"Module system for reusability",
			},
		},
		"Node.js": {
			description: "Node.js is a JavaScript runtime built on Chrome's V8 engine. It enables building scalable network applications using JavaScript on the server-side.",
			version:     "LTS (20.x) via NVM",
			features: []string{
				"Event-driven, non-blocking I/O",
				"NPM package manager with millions of packages",
				"Built-in modules for file system, HTTP, etc.",
				"Cross-platform compatibility",
				"Active community and ecosystem",
			},
		},
		"Python": {
			description: "Python is a high-level, interpreted programming language known for its simplicity and versatility. Perfect for web development, data science, automation, and more.",
			version:     "Latest (3.12.x) via pyenv",
			features: []string{
				"Simple and readable syntax",
				"Extensive standard library",
				"Rich ecosystem (Django, Flask, FastAPI, etc.)",
				"Data science tools (NumPy, Pandas, TensorFlow)",
				"Cross-platform support",
			},
		},
		"Neovim": {
			description: "Neovim is a hyperextensible Vim-based text editor. It's a modern, powerful IDE with LSP support, tree-sitter syntax highlighting, and extensive plugin ecosystem.",
			version:     "Latest (0.10.x)",
			features: []string{
				"Built-in LSP client for code intelligence",
				"Tree-sitter for advanced syntax highlighting",
				"Lua configuration and plugin API",
				"Async job control",
				"Terminal emulator integration",
			},
		},
		"Zsh": {
			description: "Zsh is a powerful shell with advanced features, plugins, and themes. Includes Oh My Zsh framework for easy customization.",
			version:     "Latest with Oh My Zsh",
			features: []string{
				"Advanced auto-completion",
				"Syntax highlighting",
				"Auto-suggestions based on history",
				"Extensive plugin ecosystem",
				"Customizable themes and prompts",
			},
		},
		"LazyDocker": {
			description: "LazyDocker is a simple terminal UI for Docker and Docker Compose. It provides an intuitive interface for managing containers, images, and volumes.",
			version:     "Latest",
			features: []string{
				"Interactive TUI for Docker management",
				"View container logs in real-time",
				"Manage images, containers, and volumes",
				"Execute commands in containers",
				"Docker Compose integration",
			},
		},
		"LazyGit": {
			description: "LazyGit is a simple terminal UI for git commands. It makes complex git operations easy with an intuitive keyboard-driven interface.",
			version:     "Latest",
			features: []string{
				"Interactive staging and committing",
				"Branch management and visualization",
				"Merge conflict resolution",
				"Stash management",
				"Rebase and cherry-pick operations",
			},
		},
		"Monaspace Fonts": {
			description: "Monaspace is an innovative superfamily of fonts for code by GitHub Next. Features texture healing and multiple font styles for different coding contexts.",
			version:     "v1.300",
			features: []string{
				"Five font families (Argon, Krypton, Neon, Radon, Xenon)",
				"Texture healing for better readability",
				"Code ligatures support",
				"Variable font axes",
				"Optimized for programming",
			},
		},
		"btop": {
			description: "btop is a resource monitor that shows usage and stats for processor, memory, disks, network and processes. Beautiful and feature-rich alternative to htop.",
			version:     "Latest",
			features: []string{
				"Real-time system monitoring",
				"Beautiful and customizable interface",
				"Process management",
				"Network monitoring",
				"Disk I/O statistics",
			},
		},
	}

	info, exists := toolInfo[toolName]
	if !exists {
		info = struct {
			description string
			version     string
			features    []string
		}{
			description: "No detailed information available for this tool.",
			version:     "Latest",
			features:    []string{"Installation and basic configuration"},
		}
	}

	p := tea.NewProgram(
		initialModel(toolName, info.description, info.version, info.features),
		tea.WithAltScreen(),
	)

	if _, err := p.Run(); err != nil {
		fmt.Printf("Error: %v", err)
		os.Exit(1)
	}
}
