(fn nnoremap [from to opts]
  (print from to opts)
  (let [map-opts {:noremap true}
        to (.. ":" to "<cr>")]
      (vim.keymap.set :n from to map-opts)))

(fn lnnoremap [from to]
  (nnoremap (.. "<leader>" from) to))


(let [(ok? telescope) (pcall (require :telescope))]
  (when ok?
    (telescope.setup
      {:defaults
       {:vimgrep_arguments ["rg" "--color=never" "--no-heading"
                            "--with-filename" "--line-number" "--column"
                            "--smart-case" "--hidden" "--follow"
                            "-g" "!.git/"]}})

    (vim.keymap.set "<leader>ff" ":Telescope find_files hidden=true<CR>")
    (lnnoremap :f- "Telescope file_browser")
    (lnnoremap :fg "Telescope live_grep")
    (lnnoremap :* "Telescope grep_string")
    (lnnoremap :fb "Telescope buffers")
    (lnnoremap :fH "Telescope help_tags")
    (lnnoremap :fm "Telescope keymaps")
    (lnnoremap :fM "Telescope marks")
    (lnnoremap :fh "Telescope oldfiles")
    (lnnoremap :ft "Telescope filetypes")
    (lnnoremap :fc "Telescope commands")
    (lnnoremap :fC "Telescope command_history")
    (lnnoremap :fq "Telescope quickfix")
    (lnnoremap :fl "Telescope loclist")
    (lnnoremap :fsa "Telescope lsp_code_actions")
    (lnnoremap :fsi "Telescope lsp_implementations")
    (lnnoremap :fsr "Telescope lsp_references")
    (lnnoremap :fsS "Telescope lsp_document_symbols")
    (lnnoremap :fss "Telescope lsp_workspace_symbols")))
