-- ========================================================================== --
-- 1. BASE SETTINGS
-- ========================================================================== --
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.termguicolors = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.list = true
vim.opt.listchars = {
  tab = "» ",
  trail = "·",
  lead = "·",
  nbsp = "␣",
}
vim.opt.colorcolumn = "81,101,121"
vim.opt.confirm = true

-- Enable autoread
vim.opt.autoread = true

-- Reload files on focus
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

-- Persistence & Directories
vim.opt.undofile = true
local cache_dir = vim.fn.expand("~/.cache/nvim/")
local dirs = {
  swap = cache_dir .. "swap//",
  undo = cache_dir .. "undo//",
  backup = cache_dir .. "backup//",
}

for _, d in pairs(dirs) do
  local path = d:match("(.*)//") or d
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end

vim.opt.directory = dirs.swap
vim.opt.undodir = dirs.undo
vim.opt.backupdir = dirs.backup

-- Disable swap files in headless/embedded instances to avoid aider-pop collisions
if #vim.api.nvim_list_uis() == 0 then
  vim.opt.swapfile = false
end

-- Native Wildmenu
vim.opt.wildmenu = true
vim.opt.wildoptions = "pum"
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignorecase = true
vim.opt.wildignore:append({ "*/node_modules/*", "*/.git/*", "*/vendor/*" })

-- Shim for Neovim 0.11 Treesitter changes (Telescope Compatibility)
if not vim.treesitter.parsers then
  vim.treesitter.parsers = {
    ft_to_lang = function(ft)
      return (vim.treesitter.language and vim.treesitter.language.get_lang(ft)) or ft
    end,
  }
end

-- ========================================================================== --
-- 2. BOOTSTRAP LAZY.NVIM
-- ========================================================================== --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ========================================================================== --
-- 3. PLUGIN SPECIFICATIONS
-- ========================================================================== --
require("lazy").setup({
  -- Core Libraries
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons" },

  -- Fuzzy Finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<A-b>"] = actions.close, -- Toggle off with Alt-b
            },
            n = {
              ["<A-b>"] = actions.close, -- Toggle off with Alt-b
            },
          },
        },
      }
    end,
  },

  -- Aider Integration
  {
    "possumtech/aider-pop.nvim",
    lazy = false,
    opts = {
      statusline = false,
      sync_buffers = true,
    },
  },

  -- Theme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = { transparent = true },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  -- LSP & Treesitter
  { "williamboman/mason.nvim", opts = {} },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = { ensure_installed = { "vtsls", "eslint", "biome" } },
  },
  { "neovim/nvim-lspconfig" },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "lua", "vim", "vimdoc", "javascript", "typescript", "markdown", "json", "html", "css", "bash" },
      highlight = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.config").setup(opts)
    end,
  },

  -- Copilot (Ghost Suggestions)
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<C-y>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = false },
    },
  },

  -- Completion Engine (Blink)
  {
    "saghen/blink.cmp",
    version = "*",
    opts = {
      keymap = { preset = "default" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_x = {
          { function() return require("aider-pop").status() end },
          "encoding", "fileformat", "filetype",
        },
      },
    },
  },
})

-- ========================================================================== --
-- 4. LSP & KEYBINDINGS (MODERN 0.11+)
-- ========================================================================== --
local capabilities = require("blink.cmp").get_lsp_capabilities()

-- Native Neovim 0.11 LSP API
-- Note: nvim-lspconfig provides the configurations automatically
vim.lsp.config("vtsls", { capabilities = capabilities })
vim.lsp.enable("vtsls")

vim.lsp.config("eslint", { capabilities = capabilities })
vim.lsp.enable("eslint")

vim.lsp.config("biome", {
  capabilities = capabilities,
  root_dir = vim.fs.root(0, { "biome.json", "biome.jsonc" }),
})
vim.lsp.enable("biome")

-- Standard way to set up LSP keybindings in 0.11+
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  end,
})

-- Global Keybindings
local map = vim.keymap.set

-- Navigation
map("n", "<A-b>", "<cmd>Telescope buffers<cr>", { desc = "Toggle Buffer List" })
map("n", "<leader>b", "<cmd>Telescope buffers<cr>", { desc = "Find Buffer" })
map("n", "<leader>f", "<cmd>Telescope find_files<cr>", { desc = "Find File" })
map("n", "<leader>s", "<cmd>Telescope live_grep<cr>", { desc = "Search Project" })
map("n", "<Left>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<Right>", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- Aider
map("n", "<A-a>", "<cmd>AiderPopToggle<cr>", { desc = "Toggle Aider" })
map("n", "<leader>a", "<cmd>AiderPopToggle<cr>", { desc = "Toggle Aider" })

-- UI Toggles
map("n", "<leader><tab>", function()
  vim.opt.expandtab = not vim.opt.expandtab:get()
  print(vim.opt.expandtab:get() and "Soft Tabs (2 spaces)" or "Hard Tabs")
end, { desc = "Toggle Tabs" })
