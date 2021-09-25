call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'tomasr/molokai'
Plug 'ervandew/supertab'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'Raimondi/delimitMate'
Plug 'plasticboy/vim-markdown'
Plug 'fatih/vim-go'
Plug 'elzr/vim-json', {'for' : 'json'}
Plug 'ekalinin/Dockerfile.vim', {'for' : 'Dockerfile'}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'


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

" color
syntax enable
set t_Co=256
set background=dark
let g:molokai_original = 1
let g:rehash256 = 1
colorscheme molokai


" ==============
"   Plugins
" ==============

" =============== Nerdtree
noremap <C-n> :NERDTreeToggle<cr>
noreamp <C-f> :NERDTreeFind<cr>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
