-- ========================================================================== --
-- 1. BASE SETTINGS
-- ========================================================================== --
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.termguicolors = true
if vim.env.TMUX then
  vim.g.clipboard = "tmux"
end
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

-- Prose mode for markdown and text files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
  end,
})

-- Netrw Configuration (Sidebar)
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25

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
local lsp_servers = {
  { name = "vtsls", version = "0.3.0" },
  { name = "eslint", version = "4.10.0" },
  { name = "biome", version = "2.4.8" },
}
local lsp_server_names = {}
local mason_lsp_servers = {}

for _, server in ipairs(lsp_servers) do
  lsp_server_names[#lsp_server_names + 1] = server.name
  mason_lsp_servers[#mason_lsp_servers + 1] = server.name .. "@" .. server.version
end

local treesitter_languages = {
  "lua", "vim", "vimdoc", "javascript", "typescript", "tsx",
  "markdown", "json", "html", "css", "bash", "yaml", "dockerfile", "graphql",
  "sql", "scss", "toml", "regex", "gitignore", "python", "go", "rust",
}

require("lazy").setup({
  -- Core Libraries
  { "nvim-tree/nvim-web-devicons" },
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },

  -- Buffer Tabs
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        mode = "tabs",
        separator_style = "thin",
        show_close_icon = false,
        show_buffer_close_icons = false,
        diagnostics = "nvim_lsp",
        offsets = {
          {
            filetype = "netrw",
            text = "Files",
            highlight = "Directory",
            separator = true,
          },
        },
      },
    },
  },

  -- Git
  { "tpope/vim-fugitive" },

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
    opts = {
      ensure_installed = mason_lsp_servers,
      automatic_enable = false,
    },
  },
  { "neovim/nvim-lspconfig" },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")
      local configured_languages = {}

      for _, language in ipairs(treesitter_languages) do
        configured_languages[language] = true
      end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local filetype = vim.bo[args.buf].filetype
          local language = vim.treesitter.language.get_lang(filetype)
          if language and configured_languages[language] then
            vim.treesitter.start(args.buf, language)
          end
        end,
      })

      vim.api.nvim_create_user_command("DotfilesSyncTreesitter", function()
        treesitter.install(treesitter_languages):wait(300000)
      end, { desc = "Install the configured Tree-sitter parsers" })
    end,
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
      completion = {
        menu = {
          min_width = 40,
          max_height = 25,
          draw = {
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
            components = {
              label = { width = { fill = true, max = 100 } },
            },
          },
        },
        trigger = { prefetch_on_insert = false },
      },
    },
  },

  -- AI Client
  {
    "plurnk/plurnk.nvim",
    opts = {},
    config = function(_, opts)
      require("plurnk").setup(opts)
      require("plurnk").apply_default_keymaps()
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      return {
        options = {
          theme = "auto",
          globalstatus = true,
          section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_b = { { "filename", path = 1 } },
        lualine_x = {
          function() return require("plurnk").statusline() end,
          "encoding", "fileformat", "filetype",
        },
      },
    }
    end,
  },
})

-- ========================================================================== --
-- 4. LSP & KEYBINDINGS (MODERN 0.11+)
-- ========================================================================== --
local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.config("*", { capabilities = capabilities })
vim.lsp.enable(lsp_server_names)

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    local clients = vim.lsp.get_clients({ bufnr = args.buf, method = "textDocument/formatting" })
    local formatter

    for _, client in ipairs(clients) do
      if client.name == "biome" then
        formatter = "biome"
        break
      elseif client.name == "vtsls" then
        formatter = "vtsls"
      end
    end

    if formatter then
      vim.lsp.buf.format({
        bufnr = args.buf,
        filter = function(client) return client.name == formatter end,
        timeout_ms = 2000,
      })
    end
  end,
})

-- Buffer-local LSP keybindings
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
  end,
})

-- Global Keybindings
local map = vim.keymap.set

-- Navigation
map("n", "<Leader>b", "<cmd>Telescope buffers<cr>", { desc = "Toggle Buffer List" })
map("n", "<Leader>s", "<cmd>Telescope live_grep<cr>", { desc = "Search Project" })
map("n", "<Left>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
map("n", "<Right>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
map("n", "<S-Left>", "<cmd>BufferLineMovePrev<cr>", { desc = "Move Buffer Left" })
map("n", "<S-Right>", "<cmd>BufferLineMoveNext<cr>", { desc = "Move Buffer Right" })

-- Netrw Sidebar
map("n", "<Leader>f", function()
  -- Toggle netrw (Lexplore)
  if vim.g.netrw_liststyle == 3 and vim.fn.exists("t:netrw_lexbufnr") == 1 then
    vim.cmd("Lexplore")
  else
    vim.cmd("Lexplore 30")
  end
end, { desc = "Toggle netrw Sidebar" })

-- Markdown Preview
map("n", "<Leader>aq", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then return vim.notify("No file to preview", vim.log.levels.WARN) end
  local out = vim.fn.expand("~/repo/preview/index.html")
  vim.fn.system({
    "pandoc", "--standalone", "--embed-resources",
    "--lua-filter=" .. vim.fn.expand("~/.local/share/pandoc/filters/mermaid.lua"),
    "--metadata", "title=" .. vim.fn.fnamemodify(file, ":t:r"),
    "-f", "markdown", "-t", "html", file, "-o", out,
  })
  if vim.v.shell_error ~= 0 then return vim.notify("Pandoc failed", vim.log.levels.ERROR) end
  vim.notify("Preview updated")
end, { desc = "Export markdown to preview HTML" })

-- UI Toggles
map("n", "<leader><tab>", function()
  vim.opt.expandtab = not vim.opt.expandtab:get()
  print(vim.opt.expandtab:get() and "Soft Tabs (2 spaces)" or "Hard Tabs")
end, { desc = "Toggle Tabs" })
