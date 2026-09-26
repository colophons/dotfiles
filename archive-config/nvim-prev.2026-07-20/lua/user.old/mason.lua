local M = {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
  },
}


function M.config()
  local servers = {
    "clangd",
    "lua_ls",
    "yamlls",
    "helm_ls",
    "azure_pipelines_ls",
    "cssls",
    "html",
    "ts_ls",
    "pyright",
    "bashls",
    "jsonls",
    "omnisharp",
    "marksman",
    "gopls",
    "rust_analyzer",
    "tflint",
    "terraformls"
  }

  require("mason").setup {
    ui = {
      border = "rounded",
    },
  }

  require("mason-lspconfig").setup {
    ensure_installed = servers,
  }
end

return M
