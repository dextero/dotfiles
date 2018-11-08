set nocompatible

" FZF fuzzy searcher: https://github.com/junegunn/fzf
" ===================================================
set rtp+=$HOME/.fzf/

function! FindFileDir(path, maxdepth, file)
    if a:maxdepth == 0
        return ''
    endif

    let dirname = fnamemodify(a:path, ':h')

    if filereadable(l:dirname . '/' . a:file) || isdirectory(l:dirname . '/' . a:file)
        return l:dirname
    endif

    return FindFileDir(l:dirname, a:maxdepth - 1, a:file)
endfunction

" Looks for the closest parent directorythat looks like a project root
function! FindProjectRoot(path)
    if a:path == ''
        let p = getcwd()
    else
        let p = a:path
    endif

    for filename in [ '.git', '.ycm_extra_conf.py', 'build' ]
        let filedir = FindFileDir(p, 10, filename)
        if l:filedir != ''
            return l:filedir
        endif
    endfor

    return fnamemodify(a:path, ':h')
endfunction

" Attempt to detect a project root to perform search in
nmap <C-p> :execute 'FZF' FindProjectRoot(expand('%:p'))<CR>


" Load all plugins managed by Vundle
" ==================================
source $HOME/.vim/vundle.vimrc


" Settings
" ========
"
" Force 256-color mode
set t_Co=256

" Always display a status line 
set laststatus=2

" Detect filetype, load appropriate plugins and indent.vim
filetype plugin indent on

" Do not leave garbage files behind
set nobackup
set noswapfile

" Set indent width to 4 spaces, add overrides for some file types
set tabstop=4
set shiftwidth=4
set expandtab

au BufNewFile,BufRead *.tex setlocal tabstop=2 shiftwidth=2
au BufNewFile,BufRead *.sls setlocal tabstop=2 shiftwidth=2 " Saltstack state files

" Auto-indent code
set autoindent
set smartindent

" Show cursor line/column in status bar
set ruler

" Filename suffixes ignored for file name completion
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" When saving, make a copt and overwrite the original
set backupcopy=yes

" Show partial commands in the status line
set showcmd

" Show matching brackets
set showmatch

" Show relative line numbers
set number
set relativenumber

" Leave a N-line margin when scrolling
set scrolloff=10

" Search options
set incsearch  " search as you type
set ignorecase " case-insensitive by default
set smartcase  " switch to case-sensitive if pattern has an uppercase character
set hlsearch   " highlight search results

" Folding options
set foldmethod=syntax
"set foldmethod=manual
set foldnestmax=10
set nofoldenable
set foldlevelstart=1

" Wildcard tab-completion
set wildmode=longest,list,full
set wildmenu

" Syntax tab-completion mode
set completeopt=longest,menuone

" File encoding
set fenc=utf8
set enc=utf8

" Syntax coloring
syntax on

" row/column highlighting
set cursorline
set cursorcolumn

" Recursive cwd search on `gf`, `:find` etc.
set path+=**

" Persistent undo
set undofile
set undodir=$HOME/.vim/undo
set undolevels=1000
set undoreload=10000

let g:netrw_liststyle=3

" Fix slight delay after pressing <Esc>O
" http://ksjoberg.com/vim-esckeys.html
set timeout timeoutlen=1000 ttimeoutlen=100

" Always show the signcolumn; see :h signs
" deoplete + LSC derp hard without this
set signcolumn=yes

" Allow unsaved background buffers
set hidden


" Colorscheme tweaks
" ==================

colorscheme jelleybeans

" Dim comments
hi Normal ctermbg=None
hi NonText ctermbg=None
hi Comment ctermfg=240 guifg=#333333

" Diff color tweaks
hi DiffAdd ctermbg=22 guifg=#005f00
hi DiffChange ctermbg=100 guifg=#878700
hi DiffDelete ctermbg=52 guifg=#5f0000

" Highlight tabs and EOL whitespaces
highlight default link EndOfLineSpace ErrorMsg
highlight default link AnyTab ErrorMsg
match EndOfLineSpace /\s\+$/
match AnyTab /\t/
autocmd InsertEnter * hi default link EndOfLineSpace Normal
autocmd InsertLeave * hi default link EndOfLineSpace ErrorMsg


" Mappings
" ========

" Auto-interpret common shift-typos :W, :Q
:command! W w
:command! Q q

" Fix broken syntax coloring
inoremap <F9> <C-o>:syntax sync fromstart<CR>

" Highlight 80. column
function! ToggleColorColumn()
    if (&l:colorcolumn > 0)
        set colorcolumn=0
    else
        let &colorcolumn=join(range(81,999),",")
    endif
endfunction

highlight ColorColumn ctermbg=233 guibg=#555555
nmap \8 :call ToggleColorColumn()<CR>

" Make j/k move to next visual line instead of physical line
" http://yubinkim.com/?p=6
nnoremap k gk
nnoremap j gj
nnoremap gk k
nnoremap gj j

" Fold toggle in normal mode
nnoremap \ft za

" Fold block
nnoremap \fb vaBzf

" Clear search highlights
nmap \q :nohlsearch<CR>

" Toggle buffers
nmap [b :bprev<CR>
nmap ]b :bnext<CR>

" :make options
let g:makeopts = "-j9"
nmap \b :execute 'make' g:makeopts<CR>
nmap \B :make clean<CR>:execute 'make' makeopts<CR>
nmap \t :execute 'make test' g:makeopts<CR>

autocmd BufNewFile,BufRead Cargo.toml setf rust
autocmd filetype rust compiler cargo
autocmd filetype rust let makeopts='build'

" Quickfix list
nmap \o :copen<CR>
nmap [q :cprev<CR>
nmap ]q :cnext<CR>

" Tag list
nmap ]t :tnext<CR>
nmap [t :tprevious<CR>
