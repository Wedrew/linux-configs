set nocompatible
filetype off                  
syntax on
set backspace=indent,eol,start
set shiftwidth=4

"set editing-mode vi
"set keymap vi

set tabstop=4
set softtabstop=4
set expandtab

set incsearch          
set hlsearch

set modifiable
set number
set relativenumber
set lazyredraw
set wildmenu
set autoindent
set smartindent
set smarttab
set shiftround
set nobackup
set noswapfile
let python_highlight_all = 1

autocmd vimenter * NERDTree
autocmd VimEnter * wincmd w
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'bling/vim-airline'

call vundle#end()            
filetype plugin indent on    

map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
