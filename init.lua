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
vim.opt.swapfile = false

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
require("lazy").setup({
  -- Core Libraries
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons" },

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

  -- Nzi Integration
  {
    "possumtech/nzi",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      python_cmd = { "/home/frith/.local/share/nvim/lazy/nzi/.venv/bin/python3" },
      active_model = "xfast",
      models = {
        qwenzel = {
          model = "ollama/qwenzel:latest",
          api_base = "http://192.168.1.17:11434",
        },
        qwen = {
          model = "openrouter/qwen/qwen3.5-flash-02-23",
          api_base = "https://openrouter.ai/api/v1",
          api_key = os.getenv("OPENROUTER_API_KEY"),
        },
        gflash = {
          model = "openrouter/google/gemini-3.1-flash-lite-preview",
          api_base = "https://openrouter.ai/api/v1",
          api_key = os.getenv("OPENROUTER_API_KEY"),
        },
        gpro = {
          model = "openrouter/google/gemini-3.1-pro-preview",
          api_base = "https://openrouter.ai/api/v1",
          api_key = os.getenv("OPENROUTER_API_KEY"),
        },
        xfast = {
          model = "openrouter/x-ai/grok-4.1-fast",
          api_base = "https://openrouter.ai/api/v1",
          api_key = os.getenv("OPENROUTER_API_KEY"),
        },
        ccp = {
          model = "openrouter/deepseek/deepseek-chat",
          api_base = "https://openrouter.ai/api/v1",
          api_key = os.getenv("OPENROUTER_API_KEY"),
        },
        minimax = {
          model = "openrouter/minimax/minimax-m2.5",
          api_base = "https://openrouter.ai/api/v1",
          api_key = os.getenv("OPENROUTER_API_KEY"),
        },
        opus = {
          model = "openrouter/anthropic/claude-opus-4.6",
          api_base = "https://openrouter.ai/api/v1",
          api_key = os.getenv("OPENROUTER_API_KEY"),
        },
        sonnet = {
          model = "openrouter/anthropic/claude-sonnet-4.6",
          api_base = "https://openrouter.ai/api/v1",
          api_key = os.getenv("OPENROUTER_API_KEY"),
        },
        ibm = {
          model = "openrouter/ibm-granite/granite-4.0-h-micro",
          api_base = "https://openrouter.ai/api/v1",
          api_key = os.getenv("OPENROUTER_API_KEY"),
        },
        dance = {
          model = "openrouter/bytedance-seed/seed-2.0-lite",
          api_base = "https://openrouter.ai/api/v1",
          api_key = os.getenv("OPENROUTER_API_KEY"),
        },
        zai = {
          model = "openrouter/z-ai/glm-5",
          api_base = "https://openrouter.ai/api/v1",
          api_key = os.getenv("OPENROUTER_API_KEY"),
        },
        kimi = {
          model = "openrouter/moonshotai/kimi-k2.5",
          api_base = "https://openrouter.ai/api/v1",
          api_key = os.getenv("OPENROUTER_API_KEY"),
        },
        gpt = {
          model = "openrouter/openai/gpt-5.4",
          api_base = "https://openrouter.ai/api/v1",
          api_key = os.getenv("OPENROUTER_API_KEY"),
        },
        gptpro = {
          model = "openrouter/openai/gpt-5.4-pro",
          api_base = "https://openrouter.ai/api/v1",
          api_key = os.getenv("OPENROUTER_API_KEY"),
        },
        nitro = {
          model = "openrouter/openai/gpt-oss-20b:nitro",
          api_base = "https://openrouter.ai/api/v1",
          api_key = os.getenv("OPENROUTER_API_KEY"),
        },
        search = {
          model = "openrouter/openai/gpt-4o-search-preview",
          api_base = "https://openrouter.ai/api/v1",
          api_key = os.getenv("OPENROUTER_API_KEY"),
        },
        research = {
          model = "openrouter/perplexity/sonar-deep-research",
          api_base = "https://openrouter.ai/api/v1",
          api_key = os.getenv("OPENROUTER_API_KEY"),
        },
      },
      context = {
        ignore_filetypes = { "NvimTree", "TelescopePrompt", "TelescopeResults", "fzf", "qf" },
        sitter_queries = {
          lua = [[
            (function_definition) @name
            (assignment_statement (variable_list [ (variable (identifier) @name) (variable (dot_index_expression) @name) ]) (expression_list (function_definition parameters: (parameters) @args)))
          ]],
          javascript = [[
            (function_declaration name: (identifier) @name)
            (method_definition name: (property_identifier) @name)
            (variable_declarator id: (identifier) @name value: (arrow_function))
          ]],
          typescript = [[
            (function_declaration name: (identifier) @name)
            (method_definition name: (property_identifier) @name)
            (variable_declarator id: (identifier) @name value: (arrow_function))
            (interface_declaration name: (identifier) @name)
            (type_alias_declaration name: (type_identifier) @name)
          ]]
        }
      },
      modal = {
        show_context = true,
      },
      visuals = {
        enabled = true,
      },
    },
    config = function(_, opts)
      require("nzi").setup(opts)
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
    opts = { ensure_installed = { "vtsls", "eslint", "biome" } },
  },
  { "neovim/nvim-lspconfig" },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = { 
        "lua", "vim", "vimdoc", "javascript", "typescript", "tsx", "javascriptreact", 
        "markdown", "json", "html", "css", "bash", "yaml", "dockerfile", "graphql", 
        "sql", "scss", "toml", "regex", "gitignore", "python", "go", "rust"
      },
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
        lualine_b = { { "filename", path = 2 } },
        lualine_x = {
          { function() return _G.nzi_statusline() end },
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
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
  end,
})

-- Global Keybindings
local map = vim.keymap.set

-- Nzi
map("n", "<Leader>aa", "<cmd>AI/toggle<cr>", { desc = "Toggle Nzi Modal" })
map("n", "<Leader>ax", "<cmd>AI/stop<cr>", { desc = "Abort Generation" })
map("n", "<Leader>ay", "<cmd>AI/yank<cr>", { desc = "Yank Last Response" })
map("n", "<Leader>ac", "<cmd>AI/clear<cr>", { desc = "Clear History" })
map("n", "<Leader>au", "<cmd>AI/undo<cr>", { desc = "Undo Last Turn" })

-- Interaction
map("n", "<Leader>a?", ":AI? ", { desc = "Ask Question" })
map("n", "<Leader>a:", ":AI: ", { desc = "Give Directive" })
map("n", "<Leader>a!", ":AI! ", { desc = "Shell Command" })
map("n", "<Leader>a/", ":AI/ ", { desc = "Internal Command" })

-- Context Management
map("n", "<Leader>aA", "<cmd>AI/active<cr>", { desc = "Set Buffer Active" })
map("n", "<Leader>aR", "<cmd>AI/read<cr>", { desc = "Set Buffer Read-only" })
map("n", "<Leader>aI", "<cmd>AI/ignore<cr>", { desc = "Ignore Buffer" })
map("n", "<Leader>aS", "<cmd>AI/state<cr>", { desc = "View Buffer State" })
map("n", "<Leader>at", "<cmd>AI/tree<cr>", { desc = "Context Tree" })
map("n", "<Leader>aT", "<cmd>AI/Tree<cr>", { desc = "Universe Tree" })
map("n", "<Leader>ab", "<cmd>AI/buffers<cr>", { desc = "Buffer Context Manager" })

-- Navigation & Models
map("n", "<Leader>an", "<cmd>AI/next<cr>", { desc = "Next Pending Diff" })
map("n", "<Leader>ap", "<cmd>AI/prev<cr>", { desc = "Prev Pending Diff" })
map("n", "<Leader>aN", "<cmd>AI/next_task<cr>", { desc = "Perform Next Task" })
map("n", "<Leader>aD", "<cmd>AI/accept<cr>", { desc = "Accept Diff" })
map("n", "<Leader>ad", "<cmd>AI/reject<cr>", { desc = "Reject Diff" })
map("n", "<Leader>am", "<cmd>AI/model<cr>", { desc = "Model Menu" })

-- Session & Projects
map("n", "<Leader>aw", "<cmd>AI/save<cr>", { desc = "Save Session" })
map("n", "<Leader>ae", "<cmd>AI/load<cr>", { desc = "Load Session" })
map("n", "<Leader>ar", "<cmd>AI/test<cr>", { desc = "Run Tests" })
map("n", "<Leader>af", "<cmd>AI/ralph<cr>", { desc = "Ralph Loop" })

-- Navigation
map("n", "<Leader>b", "<cmd>Telescope buffers<cr>", { desc = "Toggle Buffer List" })
map("n", "<Leader>s", "<cmd>Telescope live_grep<cr>", { desc = "Search Project" })
map("n", "<Left>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<Right>", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- Netrw Sidebar
map("n", "<Leader>f", function()
  -- Toggle netrw (Lexplore)
  if vim.g.netrw_liststyle == 3 and vim.fn.exists("t:netrw_lexbufnr") == 1 then
    vim.cmd("Lexplore")
  else
    vim.cmd("Lexplore 30")
  end
end, { desc = "Toggle netrw Sidebar" })

-- UI Toggles
map("n", "<leader><tab>", function()
  vim.opt.expandtab = not vim.opt.expandtab:get()
  print(vim.opt.expandtab:get() and "Soft Tabs (2 spaces)" or "Hard Tabs")
end, { desc = "Toggle Tabs" })
