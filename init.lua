-- ========================================================================== --
-- 1. BASE SETTINGS & APPEARANCE
-- ========================================================================== --
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.cmd.colorscheme("default")
for _, group in ipairs({ "Normal", "NormalNC", "SignColumn", "EndOfBuffer" }) do
  vim.api.nvim_set_hl(0, group, { bg = "NONE" })
end

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
vim.opt.completeopt = { "menuone", "noselect", "popup" }
vim.opt.laststatus = 3

-- Native global statusline (zero plugins)
_G.DotfilesStatusline = function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local lsp_names = {}
  for _, client in ipairs(clients) do
    lsp_names[#lsp_names + 1] = client.name
  end
  local diag = vim.diagnostic.status()
  local right = {}
  if diag ~= "" then right[#right + 1] = diag end
  if #lsp_names > 0 then right[#right + 1] = "[" .. table.concat(lsp_names, ",") .. "]" end
  if vim.bo.filetype ~= "" then right[#right + 1] = vim.bo.filetype end
  right[#right + 1] = "%l:%c"
  return " %f %m%r%=" .. table.concat(right, "  ") .. " "
end
vim.opt.statusline = "%!v:lua.DotfilesStatusline()"

-- Reload externally modified files on focus
vim.opt.autoread = true
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

-- Netrw
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25

-- ========================================================================== --
-- 2. PLUGINS (BUILT-IN NVIM 0.12 vim.pack — 4 PLUGINS TOTAL)
-- ========================================================================== --
vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-mini/mini.pick",
  "https://github.com/milanglacier/minuet-ai.nvim",
  "https://github.com/folke/which-key.nvim",
}, { confirm = false, load = true })

require("which-key").setup({
  icons = {
    mappings = false,
  },
})

-- Tree-sitter
local treesitter_languages = {
  "lua", "vim", "vimdoc", "javascript", "typescript", "tsx",
  "markdown", "json", "html", "css", "bash", "yaml", "dockerfile", "graphql",
  "sql", "scss", "toml", "regex", "gitignore", "python", "go", "rust",
}
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
  require("nvim-treesitter").install(treesitter_languages):wait(300000)
end, { desc = "Install the configured Tree-sitter parsers" })

-- Fuzzy Picker (mini.pick)
require("mini.pick").setup({
  mappings = {
    move_down = "<C-j>",
    move_up = "<C-k>",
    stop = "<A-b>",
  },
  options = {
    use_icons = false,
  },
})

-- Predictive Completion (DeepSeek FIM ghost text)
require("minuet").setup({
  provider = "openai_fim_compatible",
  n_completions = 1,
  context_window = 16000,
  context_ratio = 0.75,
  throttle = 1000,
  debounce = 400,
  request_timeout = 3,
  virtualtext = {
    auto_trigger_ft = { "*" },
  },
  provider_options = {
    openai_fim_compatible = {
      model = "deepseek-v4-flash",
      end_point = "https://api.deepseek.com/beta/completions",
      api_key = "DEEPSEEK_API_KEY",
      stream = true,
      optional = {
        max_tokens = 256,
        top_p = 0.9,
      },
    },
  },
})

do
  local action = require("minuet.virtualtext").action
  vim.keymap.set("i", "<C-y>", function()
    if vim.fn.pumvisible() == 0 and action.is_visible() then
      action.accept_line()
      return ""
    end
    return "<C-y>"
  end, { desc = "Accept Completion Line", expr = true, silent = true })
end

-- ========================================================================== --
-- 3. NATIVE LSP (ZERO WRAPPER OR PACKAGE-MANAGER PLUGINS)
-- ========================================================================== --
local managed_lsp_bin = vim.fn.stdpath("data") .. "/lsp/node_modules/.bin"

local function resolve_lsp_cmd(binary, root_dir, prefer_local)
  if prefer_local and root_dir then
    local local_bin = vim.fs.joinpath(root_dir, "node_modules/.bin", binary)
    if vim.fn.executable(local_bin) == 1 then
      return local_bin
    end
  end
  local tracked_bin = vim.fs.joinpath(managed_lsp_bin, binary)
  if vim.fn.executable(tracked_bin) == 1 then
    return tracked_bin
  end
  return binary
end

local js_lock_markers = {
  { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" },
  { ".git" },
}

vim.lsp.config("vtsls", {
  cmd = function(dispatchers, config)
    local bin = resolve_lsp_cmd("vtsls", (config or {}).root_dir, false)
    return vim.lsp.rpc.start({ bin, "--stdio" }, dispatchers)
  end,
  init_options = { hostInfo = "neovim" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_dir = function(bufnr, on_dir)
    if vim.fs.root(bufnr, { "deno.json", "deno.jsonc", "deno.lock" }) then
      return
    end
    on_dir(vim.fs.root(bufnr, js_lock_markers) or vim.fn.getcwd())
  end,
})

vim.lsp.config("biome", {
  cmd = function(dispatchers, config)
    local bin = resolve_lsp_cmd("biome", (config or {}).root_dir, true)
    return vim.lsp.rpc.start({ bin, "lsp-proxy" }, dispatchers)
  end,
  filetypes = {
    "css", "graphql", "html", "javascript", "javascriptreact",
    "json", "jsonc", "typescript", "typescriptreact",
  },
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local filename = vim.api.nvim_buf_get_name(bufnr)
    if filename == "" then return end
    local project_root = vim.fs.root(bufnr, {
      { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" },
      { "biome.json", "biome.jsonc" },
      { ".git" },
    }) or vim.fn.getcwd()
    local has_biome = vim.fs.find({ "biome.json", "biome.jsonc" }, {
      path = filename,
      type = "file",
      limit = 1,
      upward = true,
      stop = vim.fs.dirname(project_root),
    })[1]
    if has_biome then
      on_dir(project_root)
    end
  end,
})

local eslint_configs = {
  ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.yaml", ".eslintrc.yml", ".eslintrc.json",
  "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs",
  "eslint.config.ts", "eslint.config.mts", "eslint.config.cts",
}

vim.lsp.config("eslint", {
  cmd = function(dispatchers, config)
    local bin = resolve_lsp_cmd("vscode-eslint-language-server", (config or {}).root_dir, true)
    return vim.lsp.rpc.start({ bin, "--stdio" }, dispatchers)
  end,
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local filename = vim.api.nvim_buf_get_name(bufnr)
    if filename == "" or vim.fs.root(bufnr, { "deno.json", "deno.jsonc", "deno.lock" }) then
      return
    end
    local project_root = vim.fs.root(bufnr, js_lock_markers) or vim.fn.getcwd()
    local has_eslint = vim.fs.find(eslint_configs, {
      path = filename,
      type = "file",
      limit = 1,
      upward = true,
      stop = vim.fs.dirname(project_root),
    })[1]
    if has_eslint then
      on_dir(project_root)
    end
  end,
  settings = {
    validate = "on",
    useESLintClass = false,
    experimental = {},
    codeActionOnSave = { enable = false, mode = "all" },
    format = true,
    quiet = false,
    onIgnoredFiles = "off",
    rulesCustomizations = {},
    run = "onType",
    problems = { shortenToSingleLine = false },
    nodePath = "",
    workingDirectory = { mode = "auto" },
    codeAction = {
      disableRuleComment = { enable = true, location = "separateLine" },
      showDocumentation = { enable = true },
    },
  },
  before_init = function(_, config)
    if config.root_dir then
      config.settings = config.settings or {}
      config.settings.workspaceFolder = {
        uri = vim.uri_from_fname(config.root_dir),
        name = vim.fn.fnamemodify(config.root_dir, ":t"),
      }
    end
  end,
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, "LspEslintFixAll", function()
      client:request_sync("workspace/executeCommand", {
        command = "eslint.applyAllFixes",
        arguments = { { uri = vim.uri_from_bufnr(bufnr), version = vim.lsp.util.buf_versions[bufnr] } },
      }, nil, bufnr)
    end, {})
  end,
  handlers = {
    ["eslint/openDoc"] = function(_, result)
      if result then vim.ui.open(result.url) end
      return {}
    end,
    ["eslint/confirmESLintExecution"] = function(_, result)
      if result then return 4 end
    end,
    ["eslint/probeFailed"] = function()
      vim.notify("ESLint probe failed.", vim.log.levels.WARN)
      return {}
    end,
    ["eslint/noLibrary"] = function()
      vim.notify("Unable to find ESLint library.", vim.log.levels.WARN)
      return {}
    end,
  },
})

vim.lsp.enable({ "vtsls", "biome", "eslint" })

-- Format on save (Biome when attached, otherwise vtsls)
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

-- Buffer-local LSP keybindings & explicit completion
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local opts = { buffer = args.buf }
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })
    end
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

-- ========================================================================== --
-- 4. KEYBINDINGS
-- ========================================================================== --
local map = vim.keymap.set

map("i", "<C-Space>", vim.lsp.completion.get, { desc = "LSP Completion" })

-- Fuzzy Navigation (mini.pick) & Buffers
map("n", "<Leader>b", function() MiniPick.builtin.buffers() end, { desc = "Pick Buffers" })
map("n", "<Leader>p", function() MiniPick.builtin.files() end, { desc = "Pick Files" })
map("n", "<Leader>s", function() MiniPick.builtin.grep_live() end, { desc = "Live Grep" })
map("n", "<Left>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<Right>", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- Directory Navigation (Netrw)
map("n", "-", "<cmd>Explore<cr>", { desc = "Open Parent Directory" })
map("n", "<Leader>f", function()
  if vim.g.netrw_liststyle == 3 and vim.fn.exists("t:netrw_lexbufnr") == 1 then
    vim.cmd("Lexplore")
  else
    vim.cmd("Lexplore 30")
  end
end, { desc = "Toggle Netrw Sidebar" })

-- Markdown + Mermaid HTML Preview
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
