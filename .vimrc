syntax on
filetype plugin indent on
set autoread

set nocp
set ai
set bs=indent,eol,start
set hls is ic scs
set sw=4 sts=4 et
set ruler
set hidden
set tabstop=2
set shiftwidth=2
set expandtab
set ffs=dos,unix
set nocompatible
set showcmd
set nofoldenable

set relativenumber

nnoremap <SPACE> <Nop>
let mapleader=" "
map <leader>qa :qa<cr>

set belloff=all

set cursorline

set wildmenu
set wildmode=longest,list,full

noremap <F3> :set invnumber<CR>

set splitbelow
set splitright

" reformat json, insert before and after
nnoremap <F2> :exec "execute '%!python -m json.tool'" <CR>
nnoremap cc :exec "normal i".nr2char(getchar())."\e"<CR>
nnoremap cl :exec "normal a".nr2char(getchar())."\e"<CR>
" end reformat

map <leader>tn :tabnew<cr>
map <leader>tl :tabnext<cr>
map <leader>th :tabprevious<cr>
map <leader>tc :tabclose<cr>

hi CursorLine cterm=NONE ctermbg=darkred ctermfg=white
hi Visual term=reverse cterm=reverse guibg=Grey

set laststatus=2
set statusline=
set statusline+=%<\                       " cut at start
set statusline+=%2*[%n%H%M%R%W]%*\        " flags and buf no
set statusline+=%-40f\                    " path
set statusline+=%=%1*%y%*%*\              " file type
set statusline+=%10((%l,%c)%)\            " line and column
set statusline+=%P                        " percentage of file
