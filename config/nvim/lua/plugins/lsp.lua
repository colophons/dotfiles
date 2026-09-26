return {
  "neovim/nvim-lspconfig",
  lazy = false,
  dependencies = {
    { "mason-org/mason.nvim", lazy = false, opts = {} },
  },
  config = function()
    -- Upstream server definitions; Neovim owns attachment and completion.
    -- Mason adds installed servers to PATH before these are enabled.
    vim.lsp.enable({ "rust_analyzer", "ts_ls" })
  end,
}
