set showtabline=2
set wildmenu
set wildmode=list:longest
set showmatch
set encoding=utf8
set number
set hidden
set spelllang=en
set incsearch
set nopaste
set autoindent
set fileformats=unix,dos
set comments=sr:/*,mb:*,ex:*/
set shiftwidth=4
set tabstop=4
set laststatus=2
set nowb
set cursorline
set scrolloff=3
set autowrite
set autochdir
set linespace=0
set diffopt+=horizontal
set colorcolumn=80

syntax enable
filetype on
filetype plugin indent on
colorscheme desert

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

augroup wspace
	autocmd!
	" Visual warning about trailing whitespace
	highlight ExtraWhitespace ctermbg=red guibg=red
	match ExtraWhitespace /\s\+$/
	autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
	autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
	autocmd InsertLeave * match ExtraWhitespace /\s\+$/
	autocmd BufWinLeave * call clearmatches()
augroup END

" Check PHP syntax
function! Php_lint()
	:1,$ w! ~/.vim/archive/lint.php
	:!php -l ~/.vim/archive/lint.php
endfunction
map <leader>r <Esc>:call Php_lint()<CR>

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

nnoremap h <nop>
nnoremap j <nop>
nnoremap k <nop>
nnoremap l <nop>

function! Hard_Mode()
	nnoremap h <nop>
	nnoremap j <nop>
	nnoremap k <nop>
	nnoremap l <nop>
	:echom "VIM: Hard Mode!"
endfunction
function! Easy_Mode()
	nnoremap h h
	nnoremap j j
	nnoremap k k
	nnoremap l l
	:echom "You are weak..."
endfunction
noremap <F3> <ESC>:call Easy_Mode()<CR>
noremap <F4> <ESC>:call Hard_Mode()<CR>

" Easily edit .vimrc
nnoremap <leader>v :vsplit $MYVIMRC<cr>

" Email syntax highlighting
au BufRead,BufNewFile .followup,.article,.letter,/tmp/pico*,nn.*,snd.*,/tmp/mutt* :set ft=mail

" Set the status line the way i like it
let VCSCommandEnableBufferSetup=1
set stl=%f\ %m\ %r%{VCSCommandGetStatusLine()}\ Line:%l/%L[%p%%]\ Col:%v\ Buf:#%n\ [%b][0x%B]

" dbext directives
source ~/.vim/db.vim

" rotating wallpaper!
nnoremap <leader>1 :execute '!'."pcmanfm --set-wallpaper=/home/matt/Dropbox/train/bg1.png"<CR><CR>
nnoremap <leader>2 :execute '!'."pcmanfm --set-wallpaper=/home/matt/Dropbox/train/bg2.png"<CR><CR>
nnoremap <leader>3 :execute '!'."pcmanfm --set-wallpaper=/home/matt/Dropbox/train/bg3.png"<CR><CR>
nnoremap <leader>4 :execute '!'."pcmanfm --set-wallpaper=/home/matt/Dropbox/train/bg4.png"<CR><CR>
nnoremap <leader>5 :execute '!'."pcmanfm --set-wallpaper=/home/matt/Dropbox/train/bg5.png"<CR><CR>
nnoremap <leader>6 :execute '!'."pcmanfm --set-wallpaper=/home/matt/Dropbox/train/bg6.png"<CR><CR>
nnoremap <leader>7 :execute '!'."pcmanfm --set-wallpaper=/home/matt/Dropbox/train/bg7.png"<CR><CR>
nnoremap <leader>8 :execute '!'."pcmanfm --set-wallpaper=/home/matt/Dropbox/train/bg8.png"<CR><CR>
nnoremap <leader>9 :execute '!'."pcmanfm --set-wallpaper=/home/matt/Dropbox/train/bg9.png"<CR><CR>
nnoremap <leader>0 :execute '!'."pcmanfm --set-wallpaper=/home/matt/Dropbox/train/bg0.png"<CR><CR>
