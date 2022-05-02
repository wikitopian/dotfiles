" Manually install PlugInstall

call plug#begin()

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dadbod'
Plug 'tpope/vim-vinegar'

call plug#end()

set colorcolumn=81
set number

" The final answer to the Tab Question
set shiftwidth=4
set tabstop=4
set softtabstop=4
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
