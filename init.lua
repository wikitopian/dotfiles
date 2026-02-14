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

-- Enable autoread to reload files changed outside Neovim
vim.opt.autoread = true

-- Trigger checktime to detect changes when focus returns to Neovim or the buffer is entered
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

vim.o.directory = "~/.cache/nvim/swap//"

-- ========================================================================== --
-- 2. BOOTSTRAP LAZY.NVIM
-- ========================================================================== --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
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

  -- LSP & Treesitter (The Brains)
  {
    "williamboman/mason.nvim",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "vtsls", "eslint", "biome" },
    },
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

  -- AI Completion (Ollama)
  {
    "milanglacier/minuet-ai.nvim",
    opts = {
      provider = "openai_compatible",
      provider_options = {
        openai_compatible = {
          model = "qwen3-coder:30b",
          end_point = "http://192.168.0.88:11434/v1/chat/completions",
          name = "Ollama",
          stream = true,
          api_key = "TERM",
          optional = {
            max_tokens = 512,
            top_p = 0.9,
          },
        },
      },
    },
  },





  -- Completion Engine (Blink)
  {
    "saghen/blink.cmp",
    version = "*",
    opts = {
      keymap = { preset = 'default' },
      completion = {
        trigger = {
          show_on_keyword = false,
          show_on_trigger_character = false,
        },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'minuet' },
        providers = {
          minuet = {
            name = 'minuet',
            module = 'minuet.blink',
          },
        },
      },
    },
  },

  -- Powerline Buffoonery (Lualine + Tmux integration)
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        section_separators = { left = '', right = '' },
      },
    },
  },
})

-- ========================================================================== --
-- 4. LSP CONFIGURATION
-- ========================================================================== --
local capabilities = require('blink.cmp').get_lsp_capabilities()

-- TypeScript (vtsls)
vim.lsp.config('vtsls', { capabilities = capabilities })
vim.lsp.enable('vtsls')

-- ESLint
vim.lsp.config('eslint', { capabilities = capabilities })
vim.lsp.enable('eslint')

-- Biome (Only starts if biome.json is present)
vim.lsp.config('biome', { capabilities = capabilities })
vim.lsp.enable('biome')

-- Create Keybindings when LSP attaches
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  end,
})

-- Toggle between soft tabs (expandtab) and hard tabs (noexpandtab)
vim.keymap.set('n', '<leader><tab>', function()
  if vim.opt.expandtab:get() then
    vim.opt.expandtab = false
    print("Hard Tabs")
  else
    vim.opt.expandtab = true
    print("Soft Tabs (2 spaces)")
  end
end, { desc = 'Toggle soft/hard tabs' })
