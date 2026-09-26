local M = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "folke/neodev.nvim",
      "Hoffs/omnisharp-extended-lsp.nvim"
    },
  },
}

local function lsp_keymaps(bufnr)
-- going to try using which-key for now
--   local opts = { noremap = true, silent = true }
--   local keymap = vim.api.nvim_buf_set_keymap
--   keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
--   keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
--   keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
--   keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
--   keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
--   keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
end

M.on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)

  if client.supports_method "textDocument/inlayHint" then
    vim.lsp.inlay_hint.enable(bufnr, true)
  end
end

function M.common_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return capabilities
end

M.toggle_inlay_hints = function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.lsp.inlay_hint.enable(bufnr, not vim.lsp.inlay_hint.is_enabled(bufnr))
end

function M.config()
  local wk = require "which-key"
  wk.register {
    ["<leader>la"] = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    -- ["<C-.>"] = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    ["<leader>lf"] = {
      "<cmd>lua vim.lsp.buf.format({async = true, filter = function(client) return client.name ~= 'typescript-tools' end})<cr>",
      "Format",
    },
    ["<leader>li"] = { "<cmd>LspInfo<cr>", "Info" },
    ["<leader>lj"] = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next Diagnostic" },
    ["<leader>lh"] = { "<cmd>lua require('user.lspconfig').toggle_inlay_hints()<cr>", "Hints" },
    ["<leader>lk"] = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Prev Diagnostic" },
    ["<leader>ll"] = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
    -- ["<leader>lq"] = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
    ["<leader>lr"] = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
    ["<leader>lwa"] = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", "[W]orkspace [A]dd Dir" },
    ["<leader>lwr"] = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", "[W]orkspace [R]emove Dir" },
    ["<leader>lwl"] = { "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", "[W]orkspace [L]ist Dirs" },
    ["gl"] = { "<cmd>lua vim.diagnostic.open_float()<cr>", "Diagnostics at point" },
    -- A bunch of these are definied in telescope's config right now...
    -- ["gd"] = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Definition" },
    -- ["gD"] = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Declaration" },
    -- ["gI"] = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Implementations" },
    -- ["gr"] = { "<cmd>lua vim.lsp.buf.references()<cr>", "References to symbol" },
    -- ["<C-l>"] = { "<cmd>lua vim.diagnostic.open_float()<cr>", "[G]et [D]iagnostics at point" },
    -- ["<C-k>"] =  { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover" },
    ["L"] = { "<cmd>lua vim.diagnostic.open_float()<cr>", "[G]et [D]iagnostics at point" },
    ["K"] =  { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover" },
    ["<leader>l<space>"] =  { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover" },
    ["<leader>ls"] =  { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature Help" },
  }

  wk.register {
    ["<leader>la"] = {
      name = "LSP",
      a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action", mode = "v" },
    },
  }

  local lspconfig = require "lspconfig"
  local icons = require "user.icons"

  local servers = {
    "clangd",
    "lua_ls",
    "cssls",
    "helm_ls",
    "azure_pipelines_ls",
    "html",
    "ts_ls",
    "eslint",
    "pyright",
    "bashls",
    "jsonls",
    "yamlls",
    "omnisharp",
    "marksman",
    "gopls",
    "rust_analyzer",
    "powershell_es",
    "tflint",
    "terraformls"
  }

  local default_diagnostic_config = {
    signs = {
      active = true,
      values = {
        { name = "DiagnosticSignError", text = icons.diagnostics.Error },
        { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
        { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
        { name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
      },
    },
    virtual_text = false,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(default_diagnostic_config)

  for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config(), "signs", "values") or {}) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
  require("lspconfig.ui.windows").default_options.border = "rounded"

  for _, server in pairs(servers) do
    local opts = {
      on_attach = M.on_attach,
      capabilities = M.common_capabilities(),
    }

    -- tbl_deep_extend recursively merges tables
    -- so, we try and extract the `settings` table from a given lspsetting file
    -- then merge it in with the opts
    local require_ok, settings = pcall(require, "user.lspsettings." .. server)
    if require_ok then
      opts = vim.tbl_deep_extend("force", settings, opts)
    end

    if server == "lua_ls" then
      require("neodev").setup {}
    end

    lspconfig[server].setup(opts)
  end
end

return M
