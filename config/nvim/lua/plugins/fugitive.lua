return {
  "tpope/vim-fugitive",
  lazy = false, -- Keep the full :Git / :G* command family available.
  keys = {
    { "<leader>gs", "<cmd>Git<CR>", desc = "Git status" },
    { "<leader>gd", "<cmd>Gvdiffsplit<CR>", desc = "Git diff (index)" },
    { "<leader>gb", "<cmd>Git blame<CR>", desc = "Git blame" },
  },
}
