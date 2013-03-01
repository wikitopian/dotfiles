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
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'tpope/vim-fugitive'
Bundle 'wikitopian/hardmode'
Bundle 'tpope/vim-sleuth'
Bundle 'vim-scripts/ShowMarks'
Bundle 'wikitopian/dbext.vim'
Bundle 'mattn/webapi-vim'
Bundle 'mattn/gist-vim'
Bundle 'ludovicPelle/vim-xdebug'
Bundle 'plasticboy/vim-markdown'
Bundle 'ludovicPelle/vim-xdebug'
Bundle 'vim-scripts/taglist.vim'

syntax enable
filetype plugin indent on

" Window
set splitbelow
set splitright
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

"Gist
let g:gist_detect_filetype = 1
let g:gist_show_privates = 1
let g:gist_post_private = 1

let g:Powerline_symbols = 'fancy'

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

nnoremap <leader>h <Esc>:call EasyMode()<CR>
nnoremap <leader>H <Esc>:call HardMode()<CR>
autocmd VimEnter,BufNewFile,BufReadPost * call HardMode()

let g:indentwizard_preferred_expandtab = 0
let g:indentwizard_preferred_indent = 4

" Check PHP syntax
function! Php_lint()
    :1,$ w! ~/.vim/backup/lint.php
    :!php -l ~/.vim/backup/lint.php
endfunction
nnoremap <leader>x <Esc>:call Php_lint()<CR>

let g:phpcs_std_list="WordPress"
nnoremap <leader>X <Esc>:Phpcs<CR>

" Tags
let Tlist_Ctags_Cmd = "/usr/bin/ctags"
let Tlist_WinWidth = 50

set tags=~/.tags

function! Tag_list()
:TlistToggle
endfunction
nnoremap <leader>t <Esc>:call Tag_list()<CR>

" Email syntax highlighting
au BufRead,BufNewFile .followup,.article,.letter,/tmp/pico*,nn.*,snd.*,/tmp/mutt* :set ft=mail

" Set the status line the way i like it
set stl=%f\ %m\ %r%{fugitive#statusline()}\ Line:%l/%L[%p%%]\ Col:%v\ Buf:#%n\ [%b][0x%B]%=%{v:servername}

" Convert MarkDown to HTML and show preview
function! MarkdownPreview()
	silent exec ":1,$ w! ~/.vim/backup/scratch.md"
	silent exec '!php -f ~/.vim/scratch.php ~/.vim/backup/scratch.md > ~/.vim/backup/scratch.html'
	silent exec '!google-chrome ~/.vim/backup/scratch.html >> /dev/null'
endfunction
map <leader>p <Esc>:call MarkdownPreview()<CR>

map <leader>r <Esc>:reg<CR>
map <leader>m <Esc>:marks<CR>

au BufRead,BufNewFile *.creole set filetype=creole
au BufRead,BufNewFile *.wiki set filetype=creole

" dbext directives
source ~/.vim/db.vim

" XDebug map keys
nnoremap <leader>d1 :python debugger_resize()<cr>
nnoremap <leader>d2 :python debugger_command('step_into')<cr>
nnoremap <leader>d3 :python debugger_command('step_over')<cr>
nnoremap <leader>d4 :python debugger_command('step_out')<cr>
nnoremap <leader>d5 :call <SID>startDebugging()<cr>
nnoremap <leader>d6 :call <SID>stopDebugging()<cr>
nnoremap <leader>d7 :python debugger_context()<cr>
nnoremap <leader>d8 :python debugger_property()<cr>
nnoremap <leader>d9 :python debugger_watch_input("context_get")<cr>A<cr>
nnoremap <leader>d0 :python debugger_watch_input("property_get", '<cword>')<cr>A<cr>
nnoremap <leader>d- :python debugger_watch_input("eval")<cr>A
