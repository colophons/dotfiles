-- Native Neovim 0.12 LSP, with the useful bindings from the old config.
vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  virtual_text = false, -- Keep code quiet; gl / L / <leader>lD show diagnostics.
  update_in_insert = false,
  float = { source = true },
})

vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Diagnostics at point" })
vim.keymap.set("n", "L", vim.diagnostic.open_float, { desc = "Diagnostics at point" })
vim.keymap.set("n", "<leader>lj", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>lk", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })
vim.keymap.set("n", "<leader>li", "<cmd>checkhealth vim.lsp<CR>", { desc = "LSP info / health" })

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user.lsp", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
    end

    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
    map("n", "gI", function()
      require("telescope.builtin").lsp_implementations()
    end, "Find implementations")
    -- gr is now a native LSP prefix (grn/gra/gri/grt/etc.); don't shadow it.
    map("n", "grr", function()
      require("telescope.builtin").lsp_references()
    end, "Find references")
    map("n", "K", vim.lsp.buf.hover, "Hover")
    map("n", "<leader>l<Space>", vim.lsp.buf.hover, "Hover")
    map("n", "<leader>ls", vim.lsp.buf.signature_help, "Signature help")
    map("n", "<leader>lr", vim.lsp.buf.rename, "Rename")
    map({ "n", "x" }, "<leader>la", vim.lsp.buf.code_action, "Code action")
    map({ "n", "x" }, "<leader>lf", function()
      vim.lsp.buf.format({ bufnr = event.buf, async = false, timeout_ms = 5000 })
    end, "Format buffer / selection")
    map("n", "<leader>lh", function()
      local filter = { bufnr = event.buf }
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter), filter)
    end, "Toggle inlay hints")

    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
    end
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
      map("i", "<C-Space>", vim.lsp.completion.get, "LSP completion")
    end
  end,
})
