execute pathogen#infect()

syntax on
filetype plugin indent on
colorscheme elflord

" variables
set nocp
set bs=indent,eol,start
set hls is ic scs
set sw=4 sts=4 et
set ruler
set hidden
set tabstop=2
set shiftwidth=2
set expandtab
set number
set ffs=dos,unix
set nocompatible              
set number
set showcmd

set cursorline
hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white

set wildmenu
set wildmode=longest,list,full

noremap <F3> :set invnumber<CR>

set wildignore+=node_modules/**,*.pyc
set runtimepath^=~/.vim/bundle/ctrlp.vim

vmap <C-c> <Esc> 
set timeout timeoutlen=1000 ttimeoutlen=100
imap jk <Esc>

" split window stuff
nnoremap <C-j> <C-w><C-J>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>

set splitbelow
set splitright
" end split window stuff

" reformat jason, insert before and after
nnoremap <F2> :exec "execute '%!python -m json.tool'" <CR>
nnoremap cc :exec "normal i".nr2char(getchar())."\e"<CR>
nnoremap cl :exec "normal a".nr2char(getchar())."\e"<CR>
" end reformat

autocmd BufNewFile,BufRead *.json set ft=javascript

" ctrl-p
nnoremap <leader>. :CtrlPTag<cr>
nnoremap <leader>] :!ctags -R -f<cr>
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist)|(\.(swp|ico|git|svn))$'
let g:ctrlp_working_path_mode = 'a'
" end ctrl-p

" NERDTree
let g:NERDTreeQuitOnOpen = 1
"

" go-vim 
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)

au FileType go nmap <Leader>dd <Plug>(go-def)
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)

au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)

au FileType go nmap <Leader>gb <Plug>(go-doc-browser)
au FileType go nmap <Leader>s <Plug>(go-implements)

au FileType go nmap <Leader>i <Plug>(go-info)
au FileType go nmap <Leader>e <Plug>(go-rename)

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1
let g:go_fmt_autosave = 1
let g:go_play_open_browser = 0

" end go-vim 

set laststatus=2
set statusline=
set statusline+=%<\                       " cut at start
set statusline+=%2*[%n%H%M%R%W]%*\        " flags and buf no
set statusline+=%-40f\                    " path
set statusline+=%=%1*%y%*%*\              " file type
set statusline+=%10((%l,%c)%)\            " line and column
set statusline+=%P                        " percentage of file
