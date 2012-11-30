set showtabline=1
set wildmenu
set wildmode=list:longest
set encoding=utf8
set number
set hidden
set spelllang=en
set nopaste
set autoindent
set fileformats=unix,dos
set comments=sr:/*,mb:*,ex:*/
set laststatus=2
set nowb
set cursorline
set scrolloff=3
set autochdir
set linespace=0
set diffopt+=horizontal
syntax enable
filetype plugin indent on

"Backup
set backupdir=~/.vim/backup
set directory=~/.vim/backup

"Marks
set viminfo='100,f1

"Folding
"set foldmethod=indent
"set foldlevel=1

"Search
set history=500 " keep 500 lines of command line history
set ignorecase		" ignores case
set hlsearch        " highlight search
set incsearch		" do incremental searching
set lazyredraw  " for quickfixtags
set showmode		" show current mode
set showmatch		" show matching bookends
set smartcase		" search case sensitive if search contains caps

nmap <silent> <leader>/ :nohlsearch<CR>

" The final answer to the Tab Question
set colorcolumn=80
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set list listchars=tab:»·,trail:·

function! SwitchTab()
    setlocal expandtab!
endfunction
vnoremap <Leader><tab> <Esc>:call SwitchTab()<CR>
inoremap <Leader><tab> <Esc>:call SwitchTab()<CR>
nnoremap <Leader><tab> <Esc>:call SwitchTab()<CR>

augroup wspace
    autocmd!
    " Visual warning about trailing whitespace and mixed up spacing
    highlight ExtraWhitespace ctermbg=red guibg=red
    match ExtraWhitespace /\s\+$\| \+\t\|\t \+/
    autocmd BufWinEnter * match ExtraWhitespace /\s\+$\| \+\t\|\t \+/
    autocmd InsertEnter * match ExtraWhitespace /\s\+$\| \+\t\|\t \+/
    autocmd InsertLeave * match ExtraWhitespace /\s\+$\| \+\t\|\t \+/
    autocmd BufWinLeave * call clearmatches()
augroup END

" Check PHP syntax
function! Php_lint()
    :1,$ w! ~/.vim/backup/lint.php
    :!php -l ~/.vim/backup/lint.php
endfunction
nnoremap <leader>r <Esc>:call Php_lint()<CR>

" Tags
let Tlist_Ctags_Cmd = "/usr/bin/ctags"
let Tlist_WinWidth = 50

function! Tag_list()
    :TlistToggle
endfunction
nnoremap <leader>t <Esc>:call Tag_list()<CR>

" Train myself to think and edit in patterns rather than characters
noremap <Left> \
noremap <Right> \
noremap <Up> \
noremap <Down> \
noremap <PageUp> \
noremap <PageDown> \

inoremap <Left> <nop>
inoremap <Right> <nop>
inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <PageUp> <nop>
inoremap <PageDown> <nop>

noremap <CR> <nop>

" nnoremap h <nop>
" nnoremap j <nop>
" nnoremap k <nop>
" nnoremap l <nop>

function! Hard_Mode()
    nnoremap <buffer> h <Esc>:echom "VIM: Hard Mode! (leader-h to exit)"<CR>
    nnoremap <buffer> j <Esc>:echom "VIM: Hard Mode! (leader-h to exit)"<CR>
    nnoremap <buffer> k <Esc>:echom "VIM: Hard Mode! (leader-h to exit)"<CR>
    nnoremap <buffer> l <Esc>:echom "VIM: Hard Mode! (leader-h to exit)"<CR>
    nnoremap <buffer> - <Esc>:echom "VIM: Hard Mode! (leader-h to exit)"<CR>
    nnoremap <buffer> + <Esc>:echom "VIM: Hard Mode! (leader-h to exit)"<CR>
endfunction
function! Easy_Mode()
    nnoremap <buffer> h h
    nnoremap <buffer> j j
    nnoremap <buffer> k k
    nnoremap <buffer> l l
    nnoremap <buffer> - -
    nnoremap <buffer> + +
    :echo "You are weak..."
endfunction
noremap <leader>h <Esc>:call Easy_Mode()<CR>
noremap <leader>H <Esc>:call Hard_Mode()<CR>
call Hard_Mode()

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
map <leader>m <Esc>:call MarkdownPreview()<CR>

au BufRead,BufNewFile *.creole set filetype=creole
au BufRead,BufNewFile *.wiki set filetype=creole

" dbext directives
source ~/.vim/db.vim

" rotating wallpaper!
let g:wallpaper = 'pcmanfm --set-wallpaper=/home/matt/Dropbox/train/bg'
nnoremap <leader>1 :execute '!'.g:wallpaper.'1'.'.png'<CR><CR>
nnoremap <leader>2 :execute '!'.g:wallpaper.'2'.'.png'<CR><CR>
nnoremap <leader>3 :execute '!'.g:wallpaper.'3'.'.png'<CR><CR>
nnoremap <leader>4 :execute '!'.g:wallpaper.'4'.'.png'<CR><CR>
nnoremap <leader>5 :execute '!'.g:wallpaper.'5'.'.png'<CR><CR>
nnoremap <leader>6 :execute '!'.g:wallpaper.'6'.'.png'<CR><CR>
nnoremap <leader>7 :execute '!'.g:wallpaper.'7'.'.png'<CR><CR>
nnoremap <leader>8 :execute '!'.g:wallpaper.'8'.'.png'<CR><CR>
nnoremap <leader>9 :execute '!'.g:wallpaper.'9'.'.png'<CR><CR>
nnoremap <leader>0 :execute '!'.g:wallpaper.'0'.'.png'<CR><CR>
