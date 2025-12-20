return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Set header with "MHUNG"
    dashboard.section.header.val = {
      "                                                     ",
      "                                                     ",
      "  ███╗   ███╗██╗  ██╗██╗   ██╗███╗   ██╗ ██████╗     ",
      "  ████╗ ████║██║  ██║██║   ██║████╗  ██║██╔════╝     ",
      "  ██╔████╔██║███████║██║   ██║██╔██╗ ██║██║  ███╗    ",
      "  ██║╚██╔╝██║██╔══██║██║   ██║██║╚██╗██║██║   ██║    ",
      "  ██║ ╚═╝ ██║██║  ██║╚██████╔╝██║ ╚████║╚██████╔╝    ",
      "  ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝     ",
      "                                                     ",
      "                                                     ",
    }

    -- Set menu with beautiful icons
    dashboard.section.buttons.val = {
      dashboard.button("e", "  New File", "<cmd>ene<CR>"),
      dashboard.button("SPC ee", "  Toggle Explorer", "<cmd>NvimTreeToggle<CR>"),
      dashboard.button("SPC ff", "  Find File", "<cmd>Telescope find_files<CR>"),
      dashboard.button("SPC fs", "  Find Text", "<cmd>Telescope live_grep<CR>"),
      dashboard.button("SPC fo", "  Recent Files", "<cmd>Telescope oldfiles<CR>"),
      dashboard.button("SPC wr", "  Restore Session", "<cmd>SessionRestore<CR>"),
      dashboard.button("c", "  Configuration", "<cmd>edit ~/.config/nvim/init.lua<CR>"),
      dashboard.button("u", "  Update Plugins", "<cmd>Lazy update<CR>"),
      dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
    }

    -- Set footer with dynamic info
    local function footer()
      local total_plugins = #vim.tbl_keys(require("lazy").plugins())
      local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
      local version = vim.version()
      local nvim_version_info = "  v" .. version.major .. "." .. version.minor .. "." .. version.patch

      return datetime .. "   " .. total_plugins .. " plugins" .. nvim_version_info
    end

    dashboard.section.footer.val = footer()

    -- Layout configuration
    dashboard.config.layout = {
      { type = "padding", val = 2 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      dashboard.section.footer,
    }

    -- Customize colors
    dashboard.section.header.opts.hl = "Include"
    dashboard.section.buttons.opts.hl = "Keyword"
    dashboard.section.footer.opts.hl = "Type"

    -- Send config to alpha
    alpha.setup(dashboard.config)

    -- Disable folding on alpha buffer
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
  end,
}
