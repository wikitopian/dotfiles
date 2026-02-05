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

  -- AI Completion (Gemini)
  {
    "milanglacier/minuet-ai.nvim",
    opts = {
      provider = "gemini",
      provider_options = {
        gemini = {
          model = "gemini-2.0-flash",
          system = {
            prompt = "You are a developer. Write concise, terse, modern, standard code.",
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
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'minuet' },
        providers = {
          minuet = {
            name = 'minuet',
            module = 'minuet.blink',
            score_offset = 8,
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
-- 4. LSP CONFIGURATION (The Native 0.11 Way)
-- ========================================================================== --
-- This enables Biome (or any other server) natively
vim.lsp.enable('biome')

-- Create Keybindings when LSP attaches
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  end,
})
