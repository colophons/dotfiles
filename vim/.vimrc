" hello and welcome.

" mappings
let mapleader = ","
nnoremap <leader><space> :noh<CR>
vnoremap <leader>+y :w !xsel -b<CR><CR>
inoremap <leader>+p <c-O>:read !xsel -b<CR><CR>
inoremap jj <C-\><C-n>
inoremap <leader>< <C-o>V<
inoremap <leader>> <C-o>V>
"noremap <leader>r :!clear; racket %<CR>
noremap <F5> :call ExecRacket()<CR>
nnoremap <leader>w :w<CR>:!./%<CR>
noremap <leader><tab> :call ToggleVimExplorer()<CR>

function! Scratch()
  silent! bdelete scratch
  split 
  enew
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  file scratch
  " wincmd p
  hide
  " wincmd executes <C-W> <C-<arg>> passed
endfunction

function! ExecRacket()
  "execute 'new | 0read ! racket' expand('%')
  let current_filename = expand('%')
  if current_filename == "scratch"
    bdelete!
  else
    silent call Scratch()
    split | buffer scratch
    echo "executing racket" current_filename
    silent execute 'read ! racket ' current_filename
  endif
endfunction

"ignore the top line of the file since that's where we write #lang directives
nmap <leader>gz gzV2G
nmap <leader>gx gxV2G 

" Enable meta key shit
let c='a'
while c <= 'z'
  exec "set <M-".c.">=\e".c
  exec "imap \e".c." <M-".c.">"
  let c = nr2char(1+char2nr(c))
endw

set ttimeout ttimeoutlen=50

" other config
set nocompatible
set history=50
set modeline

"search settings
set incsearch
set hlsearch


" backup file shit
set backup
set directory^=$HOME/.vim/swap//
set backupdir=~/.vim/backup//
set undofile 
set undodir=$HOME/.vim/undodir//
let g:netrw_home="$HOME/.vim/netrw"

" color stuff
syntax on
set background=dark
set t_Co=256
filetype plugin indent on

"display/ui stuff
set ruler " of course you can't see this with Eva theme
set number " turn on numbering
set relativenumber " turn on relative numbering
set showcmd " display commands
set wildmenu "menu globbing
set wildmode=list:longest,full "just the way I like it

set backspace=indent,eol,start
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
if has("autocmd")
  au BufReadPost *.rkt,*.rktl set filetype=scheme
endif

" install vimplug if we don't have it.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
  Plug 'wlangstroth/vim-racket'
  Plug 'jiangmiao/auto-pairs'
  Plug 'https://github.com/rafi/awesome-vim-colorschemes'
  Plug 'junegunn/goyo.vim'
  Plug 'junegunn/limelight.vim'

  Plug 'junegunn/seoul256.vim'
  Plug 'neomake/neomake'
  Plug 'gokcehan/vim-opex'
  Plug 'urbit/hoon.vim'
  Plug 'hylang/vim-hy'
  Plug 'neovimhaskell/haskell-vim'
  "Plug 'MicahElliott/vrod'
"  Plug 'luochen1990/rainbow'
call plug#end()

colorscheme seoul256

" Goyo configuration. Copied from junegunn/goyo.vim github repo
function! s:goyo_enter()
  silent !tmux set status off
  silent !i3-msg fullscreen
  "silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  set noshowmode
  set noshowcmd
  set scrolloff=999
  " ...
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  silent !i3-msg fullscreen
  "silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  set showmode
  set showcmd
  set scrolloff=5
  " ...

endfunction


autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

call neomake#configure#automake('w')

" let g:rainbow_active = 1

autocmd Filetype sicp set ft=racket
au Filetype racket let b:AutoPairs = {'(':')', '[':']', '{':'}','"':'"'}

au Filetype lisp let b:AutoPairs = {'(':')', '[':']', '{':'}','"':'"'}

let g:netrw_banner = 0
let g:netrw_liststyle = 3
" 1: open in new h split , 
" 2: open in new v split 
" 3: open in new tab, 
" 4: open prev window
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 15

augroup ProjectDrawer
  autocmd!
  autocmd VimEnter * :Vexplore
augroup END

function! ToggleVimExplorer()
  if exists("t:expl_buf_num")
      let expl_win_num = bufwinnr(t:expl_buf_num)
      if expl_win_num != -1
          let cur_win_nr = winnr()
          exec expl_win_num . 'wincmd w'
          close
          exec cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      exec '1wincmd w'
      Vexplore 
      " After switching to netwr buff, lets resize to 45
      vertical resize 45
      let t:expl_buf_num = bufnr("%")
  endif
endfunction
