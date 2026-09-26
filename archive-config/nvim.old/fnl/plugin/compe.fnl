(set vim.o.completeopt "menuone,noselect")
(local cmp (require :cmp))

(let [cmp (require :cmp)]
  (when cmp
    (cmp.setup
      {:enabled true
       :autocomplete true
       :debug false
       :min_length 1
       :preselect "enable"
       :throttle_time 80
       :source_timeout 200
       :incomplete_delay 400
       :max_abbr_width 100
       :max_kind_width 100
       :max_menu_width 100
       :window {:documentation {:border :solid} :completion {:border :solid} }
       :mapping { "<C-Space>" (cmp.mapping.complete)
                 "<space>" (cmp.mapping.confirm {:select false})
                 "<Tab>" (cmp.mapping (fn [fallback]
                                           (if (cmp.visible)
                                            (if (= 1 (length (cmp.get_entries)))
                                              (cmp.confirm {:select true})
                                              (cmp.select_next_item))
                                           (fallback) )))
                 
                  "<S-Tab>" (cmp.mapping.confirm {:select true}) ; I would like this to cycle...
                 "<up>" (cmp.mapping.select_prev_item)
                 "<down>" (cmp.mapping.select_next_item)
                  "<C-e>" (cmp.mapping.close)
                  "<C-b>" (cmp.mapping.scroll_docs -4)
                  "<C-f>" (cmp.mapping.scroll_docs 4)
                  ;"<Tab>" (cmp.mapping ( fn [fallback]
                  ;                       (if (cmp.visible) (cmp.select_next_item)
                  ;                         (luasnip.expand_or_jumpable) (luasnip.expand_or_jump)
                  ;                         (fallback))
                                        
                 }
       :sources [{:name :path }
                {:name :buffer }
                {:name :calc }
                {:name :nvim_lsp }
                {:name :nvim_lua }
                {:name :conjure}]
       })))
