" I use the same vimrc for both nvim and vim
if &shell =~# 'fish$'
    set shell=sh
endif

call plug#begin('~/.vim/plugged')

Plug 'SirVer/ultisnips'
Plug 'arthurxavierx/vim-caser'
Plug 'ekalinin/Dockerfile.vim', {'for' : 'Dockerfile'}
Plug 'elzr/vim-json', {'for' : 'json'}
Plug 'ervandew/supertab'
Plug 'gruvbox-community/gruvbox'
Plug 'edkolev/tmuxline.vim'
Plug 'vim-airline/vim-airline'
Plug 'fatih/vim-go'
Plug 'fatih/vim-nginx' , {'for' : 'nginx'}
Plug 'godlygeek/tabular'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'plasticboy/vim-markdown'
Plug 'roxma/vim-tmux-clipboard'
Plug 'scrooloose/nerdtree'
Plug 't9md/vim-choosewin'
Plug 'tmux-plugins/vim-tmux', {'for': 'tmux'}
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tyru/open-browser.vim'
Plug 'dag/vim-fish'

call plug#end()


" ==============
"   Settings
" ==============
set encoding=utf-8
set incsearch                " Shows the match while typing
set hlsearch                 " Highlight found searches
set showcmd                  " Show me what I'm typing
set nobackup                 " Don't create annoying backup files
set splitright               " Split vertical windows right to the current windows
set splitbelow               " Split horizontal windows below to the current windows
set noshowmode               " We show the mode with airline or lightline
set ignorecase               " Search case insensitive...
set nocursorcolumn           " speed up syntax highlighting
set nocursorline
set noerrorbells             " No beeps
set viminfo='1000            " Fzf uses it for history


" configure hybrid line number setting
:set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END


" increase max memory to show syntax highlighting for large files
set maxmempattern=20000


" ==============
"   Mappings
" ==============

" Better split switching
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
