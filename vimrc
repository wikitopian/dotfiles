set nocompatible
set showtabline=2
set wildmenu
set wildmode=list:longest
set number
set hidden
set spelllang=en
set paste
set fileformats=unix,dos
set comments=sr:/*,mb:*,ex:*/
set laststatus=0
set nowb
set scrolloff=3
set autochdir
set linespace=0
set diffopt+=horizontal
set colorcolumn=81
set encoding=utf-8
set termencoding=utf-8

colorscheme elflord

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-dadbod'
Plugin 'tpope/vim-vinegar'
Plugin 'gcmt/taboo.vim'
Plugin 'fholgado/minibufexpl.vim'
Plugin 'takac/vim-hardtime'

call vundle#end()
filetype plugin indent on

syntax enable

" The final answer to the Tab Question
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set list listchars=tab:»·,trail:·,precedes:<,extends:>

function! SwitchTab()
	setlocal expandtab!
endfunction
vnoremap <Leader><tab> <Esc>:call SwitchTab()<CR>
inoremap <Leader><tab> <Esc>:call SwitchTab()<CR>
nnoremap <Leader><tab> <Esc>:call SwitchTab()<CR>

nnoremap <Leader>, <Esc>:TabooRename<Space>
vnoremap <Leader>, <Esc>:TabooRename<Space>

" Window
set splitbelow
set splitright
set winwidth=80
set winminwidth=50

"Backup
set backupdir=~/.vim/backup
set directory=~/.vim/backup

"Search
set history=500 " keep 500 lines of command line history
set ignorecase		" ignores case
set hlsearch        " highlight search
set incsearch		" do incremental searching
set lazyredraw  " for quickfixtags
set showmode		" show current mode
set showmatch		" show matching bookends
set smartcase		" search case sensitive if search contains caps

" for vi mode syntax hightlighting
au BufRead,BufNewFile bash-fc-* set filetype=sh

" clear lingering search results
nnoremap <silent> <C-l> :noh<CR><C-l>

set tags=~/.tags

" dadbod directives
source ~/.vim/dadbod.vim
