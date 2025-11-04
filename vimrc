call plug#begin()

Plug 'folke/tokyonight.nvim'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-dadbod'
Plug 'tpope/vim-vinegar'
Plug 'github/copilot.vim'

call plug#end()

set backupdir=~/.vim/backup/
set directory=~/.vim/backup/
set undodir=~/.vim/backup/

set colorscheme=industry
set colorcolumn=81
set number

" The final answer to the Tab Question
set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab
set list listchars=tab:»·,trail:·,precedes:<,extends:>

" toggle between tab styles
function! SwitchTab()
	setlocal expandtab!
endfunction
vnoremap <Leader><tab> <Esc>:call SwitchTab()<CR>
inoremap <Leader><tab> <Esc>:call SwitchTab()<CR>
nnoremap <Leader><tab> <Esc>:call SwitchTab()<CR>

" database client
vnoremap <Leader>dq :DB<CR>
source ~/repo/dadbod.vim
" example:
" nnoremap <Leader>d1 <Esc>:DB t:db = mysql://user:pass@host/db<CR>
