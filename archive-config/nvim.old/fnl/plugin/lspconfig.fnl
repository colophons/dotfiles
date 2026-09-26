(fn nnoremap [from to opts]
  ;; converts 'a' to ':a<cr>'
  (let [to (.. ":" to "<cr>")]
      (vim.keymap.set :n from to)))

(fn map [from to]
  (nnoremap from to))

(let [(ok? lsp) (pcall (require :lspconfig))]
  (when ok?
    (lsp.clojure_lsp.setup {})
    (lsp.tsserver.setup {})
    (lsp.sumneko_lua.setup
      {:cmd ["lua-language-server"]
       :settings {:Lua {:telemetry {:enable false}}}})
    (lsp.omnisharp.setup 
      {:cmd ["omnisharp"]
       :enable_editorconfig_support true
       :enable_msbuild_load_projects_on_demand false
       :enable_roslyn_analyzers true
       :organize_imports_on_format true
       :enable_import_completion true
       :analyze_open_documents_only true})

    ;; https://www.chrisatmachine.com/Neovim/27-native-lsp/
    (map :gd "lua vim.lsp.buf.definition()")
    (map :gD "lua vim.lsp.buf.declaration()")
    (map :gr "lua vim.lsp.buf.references()")
    (map :gi "lua vim.lsp.buf.implementation()")
    (map :K "lua vim.lsp.buf.hover()")
    (map :<c-k> "lua vim.lsp.buf.signature_help()")
    (map :<c-p> "lua vim.diagnostic.goto_prev()")
    (map :<c-n> "lua vim.diagnostic.goto_next()")

    (map :<leader>lr "lua vim.lsp.buf.rename()")
    (map :<leader>lf "lua vim.lsp.buf.formatting()")))
