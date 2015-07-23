set nocompatible
set showtabline=1
set wildmenu
set wildmode=list:longest
set number
set hidden
set spelllang=en
set nopaste
set fileformats=unix,dos
set comments=sr:/*,mb:*,ex:*/
set laststatus=2
set nowb
set scrolloff=3
set autochdir
set linespace=0
set diffopt+=horizontal
set colorcolumn=80
set encoding=utf-8
set termencoding=utf-8

" Manage all plugins with Vundle
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'wikitopian/dbext.vim'
Bundle 'joonty/vim-phpqa.git'
Bundle 'joonty/vdebug.git'

syntax enable
filetype plugin indent on

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

" Window
set splitbelow
set splitright

" Ctrl-w conflicts with Chromebook terminal
nnoremap <Leader>w <C-w>

" Move pane to new tab
nnoremap <C-w>o <Esc><C-w>t<CR>
" Horizontal split
nnoremap <C-w>- <Esc>:new<CR>
" Vertical split
nnoremap <C-w><Bar> <Esc>:vnew<CR>
" Next tab
nnoremap <C-w>t <Esc>gt<CR>
" Previous tab
nnoremap <C-w>T <Esc>gT<CR>
" Next tab
nnoremap <C-w><Right> <Esc>gt<CR>
" Previous tab
nnoremap <C-w><Left> <Esc>gT<CR>
" New tab
nnoremap <C-w>n <Esc>:tabnew<CR>
" Close current tab
nnoremap <C-w>W <Esc>:tabclose<CR>
" Close current pane
nnoremap <C-w>w <Esc>:bd<CR>
" Resize window horizontally smaller
nnoremap <C-w><C-j> <Esc>:resize -1<CR>
" Resize window horizontally larger
nnoremap <C-w><C-k> <Esc>:resize +1<CR>
" Resize window vertically smaller
nnoremap <C-w><C-h> <Esc>:vertical resize -1<CR>
" Resize window vertically larger
nnoremap <C-w><C-l> <Esc>:vertical resize +1<CR>

"Backup
set backupdir=~/.vim/backup
set directory=~/.vim/backup

"Marks
set viminfo='100,f1

"Search
set history=500 " keep 500 lines of command line history
set ignorecase		" ignores case
set hlsearch        " highlight search
set incsearch		" do incremental searching
set lazyredraw  " for quickfixtags
set showmode		" show current mode
set showmatch		" show matching bookends
set smartcase		" search case sensitive if search contains caps

" clear lingering search results
nnoremap <silent> <C-l> :noh<CR><C-l>

set tags=~/.tags

" Syntax highlighting
au BufRead,BufNewFile .followup,.article,.letter,/tmp/pico*,nn.*,snd.*,/tmp/mutt* :set ft=mail
au BufRead,BufNewFile *.creole set filetype=creole
au BufRead,BufNewFile *.wiki set filetype=creole

set stl=%f\ %m\ %r\ Line:%l/%L[%p%%]\ Col:%v\ Buf:#%n\ [%b][0x%B]%=%{v:servername}

" dbext directives
source ~/.vim/db.vim

let g:phpqa_codesniffer_args = "--standard=WordPress"
