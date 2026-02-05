-- 1. BASIC SETTINGS
vim.opt.number = true            -- set number
vim.opt.colorcolumn = "81,101,121" -- colorcolumn lines
vim.opt.list = true              -- set list
vim.opt.listchars = {            -- listchars setup
  tab = "»·",
  trail = "·",
  precedes = "<",
  extends = ">",
}

-- 2. BOOTSTRAP LAZY.NVIM
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- 3. PLUGIN SPECIFICATIONS
require("lazy").setup({
  -- LSP & Mason (Installer)
  { "williamboman/mason.nvim", config = true },
  { "neovim/nvim-lspconfig" },

-- The Completion Engine (blink.cmp)
  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = { "milanglacier/minuet-ai.nvim" },
    opts = {
      keymap = { preset = "default" },
      sources = {
        -- 'minuet' is added to your default completion list
        default = { "lsp", "path", "snippets", "buffer", "minuet" },
        providers = {
          minuet = {
            name = "minuet",
            module = "minuet.blink",
            score_offset = 100, -- Give AI suggestions high priority
          },
        },
      },
    },
  },

  -- Gemini Integration (The Copilot Replacement)
  {
    "milanglacier/minuet-ai.nvim",
    opts = {
      provider = "gemini",
      provider_options = {
        gemini = {
          model = "gemini-2.0-flash",
          system = "Provide concise, terse, modern, standard code completions.",
        },
      },
    },
  },

  -- Formatter (Manual Only - No Auto-Writes)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "biome" },
        typescript = { "biome" },
        json = { "biome" },
      },
      -- HATE auto-writes? We leave 'format_on_save' out entirely.
      -- You now trigger it manually with :ConformInfo or a custom map.
    },
  },

  -- Database (Dadbod)
  { "tpope/vim-dadbod" },
  { "kristijanhusak/vim-dadbod-ui", dependencies = { "tpope/vim-dadbod" } },
})

-- 4. LSP SETUP (BIOME & OTHERS)
local lspconfig = require("lspconfig")

-- Biome automatically detects biome.json in your project root
lspconfig.biome.setup({})

-- 5. KEYMAPS
-- Manual format trigger (since you hate auto-writes)
vim.keymap.set("n", "<leader>f", function()
  require("conform").format({ async = true, lsp_fallback = true })
  print("Buffer Formatted.")
end, { desc = "Manual Format" })
