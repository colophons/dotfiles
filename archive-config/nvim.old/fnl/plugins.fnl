(let [packer (require :packer)]

(fn safe-require-plugin-config [name]
  "Safely require a module under the magic.plugin.* prefix. Will catch errors
  and print them while continuing execution, allowing other plugins to load
  even if one configuration module is broken."
  (let [(ok? val-or-err) (pcall require (.. "plugin." name))]
    (when (not ok?)
      (print (.. "Plugin config error: " val-or-err)))))

(safe-require-plugin-config :which)

(fn req [name]
  "A shortcut to building a require string for your plugin
  configuration. Intended for use with packer's config or setup
  configuration options. Will prefix the name with `magic.plugin.`
  before requiring."
  (.. "require('magic.plugin." name "')"))
;
;(fn use [...]
;  "Iterates through the arguments as pairs and calls packer's use function for
;  each of them. Works around Fennel not liking mixed associative and sequential
;  tables as well.
;
;  This is just a helper / syntax sugar function to make interacting with packer
;  a little more concise."
;  (let [pkgs [...]]
;    (packer.startup
;      (fn [use]
;        (for [i 1 (a.count pkgs) 2]
;          (let [name (. pkgs i)
;                opts (. pkgs (+ i 1))]
;            (-?> (. opts :mod) (safe-require-plugin-config))
;            (use (a.assoc opts 1 name)))))))

;
;  nil)
;
  (packer.startup
    (fn [use]
      (fn usep [name module-name]
        (print name module-name)
        (use {1 name 
              :config (fn [] (require (.. "plugin." module-name)))
              :depends :rktjmp/hotpot.nvim}))

      (use :bakpakin/fennel.vim)
      (use :rktjmp/hotpot.nvim)
      (use :wbthomason/packer.nvim)
      (use :ggandor/lightspeed.nvim)
      (use {1 :folke/which-key.nvim
            :config (fn [] (require :plugin.which))})
      (use {1 :liuchengxu/vim-better-default 
            :config (fn [] (require :plugin.better-default))})


      (use :radenling/vim-dispatch-neovim)

      (use :PeterRincker/vim-argumentative)
      (use :Olical/nvim-local-fennel) ; this might not work


      ;; Undoing
      (use {1 :mbbill/undotree 
            :config (fn [] (require :plugin.undotree))})

      ;; Language server stuff
      (use {1 :neovim/nvim-lspconfig 
            :config (fn [] (require :plugin.lspconfig))})

      ;; ugly telescope declaration.
      (use {1 :nvim-telescope/telescope.nvim 
            :config (fn [] (require :plugin.tele))
            :requires [[:nvim-lua/popup.nvim] [:nvim-lua/plenary.nvim] [:BurntSushi/ripgrep]] })

      (use {1 :nvim-treesitter/nvim-treesitter
            :run ":TSUpdate"})

      ;; neovim compe
      (use {1 :hrsh7th/nvim-cmp 
            :config (fn [] (require :plugin.compe))
            :requires [[:neovim/nvim-lspconfig]
                       [:Olical/conjure]
                       [:PaterJason/cmp-conjure]
                       [:hrsh7th/cmp-path]
                       [:hrsh7th/cmp-cmdline]
                       [:hrsh7th/cmp-buffer]
                       [:hrsh7th/cmp-nvim-lsp]]})

      ;; dockerfile support and tooling
      (use {1 :skanehira/denops-docker.vim
            :requires [[:vim-denops/denops.vim]]})


      ;; here's a big one
      (use {1 :Olical/conjure 
            :config (fn [] (require :plugin.conjure))})

      (use :PaterJason/cmp-conjure)

      ;; lispin
      (use {1 :guns/vim-sexp 
            :config (fn [] (require :plugin.sexp))})

      (use {1 :jiangmiao/auto-pairs 
            :config (fn [] (require :plugin.auto-pairs))})

      (use :tpope/vim-sexp-mappings-for-regular-people)
      (use {1 :w0rp/ale 
            :config (fn [] (require :plugin.linting))})

      ;; tim pope megapack
      (use :tpope/vim-repeat)         ; repeat plugin maps
      (use :tpope/vim-dispatch)   ; dispatchin
      (use :tpope/vim-fugitive)       ; gitin
      (use :tpope/vim-eunuch)         ; unix commands lel
      (use :tpope/vim-abolish)    ; better s-ing?
      (use :tpope/vim-commentary) ; better commenting
      (use :tpope/vim-sleuth)     ; filetype guessing
      (use :tpope/vim-surround)   ; surrounding everything
      (use :tpope/vim-unimpaired) ; a bunch of paired things I dont understand yet
      (use :tpope/vim-vinegar)    ; better project drawer
      ))
  ;(packer.sync)
)
