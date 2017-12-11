set nocompatible

"""
"   SYSTEM-SPECIFIC
"""

if has("unix")
    let $CTAGS = 'ctags'

    if $TERM == "xterm-256color" || $TERM == "screen-256color" || $COLORTERM == "gnome-terminal"
        set t_Co=256
    endif
elseif has("win32")
    set guifont=Consolas:cEASTEUROPE

    let $HOME = $USERPROFILE
    let $VIM = "C:/Program Files (x86)/Vim"
endif

"""
"   PLUGINS
"""

"""
" FZF / https://github.com/junegunn/fzf
"""
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

nmap <C-p> :execute 'FZF' FindProjectRoot(expand('%:p'))<CR>

"""
" CtrlP
"""
let g:ctrlp_extensions = [ 'buffertag', 'tag', 'line', 'dir' ]

"""
" ack-vim
"""

let g:ackprg = 'ag --nogroup --nocolor --column'

source $HOME/.vim/vundle.vimrc
set laststatus=2

"""
"   GENERAL
"""
filetype plugin indent on

set nobackup
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set ruler
set noswapfile

set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
"au BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl,*.vs,*.fs set ft=glsl
"au BufNewFile,BufRead *.hx set ft=haxe
au BufNewFile,BufRead *.teccen set ft=teccen

au BufNewFile,BufRead *.tex setlocal tabstop=2
au BufNewFile,BufRead *.tex setlocal shiftwidth=2

au BufNewFile,BufRead *.sls set ts=2 sts=2 sw=2

set backupcopy=yes
set showcmd
set showmatch
set autowrite
set number
set relativenumber
set nobackup
set scrolloff=10

" always show status bar
set laststatus=2

" searching
set ignorecase
set incsearch
set smartcase
set hlsearch

" folding
set foldmethod=syntax
"set foldmethod=manual
set foldnestmax=10
set nofoldenable
set foldlevelstart=1

let javaScript_fold=1
let perl_fold=1
let php_folding=1
let r_syntax_folding=1
let ruby_fold=1
let sh_fold_enabled=1
let vimsyn_folding='af'
let xml_syntax_folding=1

" wildcard tab-completion
set wildmode=longest,list,full
set wildmenu

" file encoding
set fenc=utf8
set enc=utf8

" syntax coloring
syn on

set completeopt=longest,menuone

" row/column highlighting
set cursorline
set cursorcolumn

" recursive cwd search
set path+=**

" persistent undo
"if has('undofile')
    set undofile
    set undodir=$HOME/.vim/undo
    set undolevels=1000
    set undoreload=10000
"endif

let g:netrw_liststyle=3

" fix slight delay after pressing <Esc>O
" http://ksjoberg.com/vim-esckeys.html
set timeout timeoutlen=1000 ttimeoutlen=100

" fix shift-typos :W, :Q
:command! W w
:command! Q q

"""
"   COLOR SCHEME
"""

let myCurrentTheme=1

if isdirectory($HOME."/.vim/bundle/vim-colorschemes")
    if myCurrentTheme == 0
        source $HOME/.vim/bundle/vim-colorschemes/colors/busierbee.vim
    elseif myCurrentTheme == 1
        source $HOME/.vim/bundle/vim-colorschemes/colors/jelleybeans.vim
    elseif myCurrentTheme == 2
        source $HOME/.vim/bundle/vim-colorschemes/colors/wombat256mod.vim
    elseif myCurrentTheme == 3
        source $HOME/.vim/bundle/vim-colorschemes/colors/solarized.vim
    endif
endif

" common scheme tweaks
hi Normal ctermbg=None
hi NonText ctermbg=None
hi Comment ctermfg=240 guifg=#333333

" diff tweaks
hi DiffAdd ctermbg=22 guifg=#005f00
hi DiffChange ctermbg=100 guifg=#878700
hi DiffDelete ctermbg=52 guifg=#5f0000

unlet myCurrentTheme

"""
"   USEFUL AUTOCMDS
"""

" EOL whitespaces highlighting
hi default link EndOfLineSpace ErrorMsg
hi default link AnyTab ErrorMsg
match EndOfLineSpace /\s\+$/
match AnyTab /\t/
autocmd InsertEnter * hi default link EndOfLineSpace Normal
autocmd InsertLeave * hi default link EndOfLineSpace ErrorMsg

" octave
au BufNewFile,BufRead *.m octave
au BufNewFile,BufRead *.m syntax=matlab

"""
"   CODE COMPLETION
"""

set ofu=syntaxcomplete#Complete

function! CleverTab()
    if pumvisible()
        return "\<C-N>"
    endif
    if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
        return "\<Tab>"
    elseif exists('&omnifunc') && &omnifunc != ''
        return "\<C-X>\<C-O>"
    else
        return "\<C-N>"
    endif
endfunction

"""
"   MAPPINGS
"""

" fix syntax coloring
inoremap <F9> <C-o>:syntax sync fromstart<CR>

" colorcolumn at 80. character: toggle
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

" fold toggle in normal mode
nnoremap \ft za

" fold block
nnoremap \fb vaBzf

" clear search highlights
nmap \q :nohlsearch<CR>

nmap \td :make -j9 CXXFLAGS='-Wno-non-virtual-dtor -Wno-cpp'<CR>
nmap \th :make -j9 CXX='clang++' CXXFLAGS='-Wno-mismatched-tags -Wno-non-virtual-dtor'<CR>

" buffers
nmap [b :bprev<CR>
nmap ]b :bnext<CR>

" quickfix list
let g:makeopts = "-j9"
nmap \b :execute 'make' g:makeopts<CR>
nmap \B :make clean<CR>:execute 'make' makeopts<CR>

autocmd filetype rust compiler cargo
autocmd filetype rust let makeopts='build'

nmap \o :copen<CR>
nmap [q :cprev<CR>
nmap ]q :cnext<CR>

" tag list
nmap ]t :tnext<CR>
nmap [t :tprevious<CR>

" LaTeX
nmap \l :!export TEMP=`mktemp -d`
        \ && pdflatex -output-directory $TEMP -halt-on-error %
        \ && echo "biber --output-directory $TEMP --input-directory $TEMP %<"
        \ && echo "pdflatex -output-directory $TEMP -halt-on-error %"
        \ && mkdir -p ./out
        \ && cp $TEMP/%<.pdf out/<CR>

" IntelliJ-like commenting on ctrl+/
nmap <C-_> \c<Space>j
vmap <C-_> \c<Space>'>j

" JavaScript context coloring
nmap \C :JSContextColorToggle<CR>

" semanting highlighting
nmap \S :SemanticHighlightToggle<CR>

function! RegenerateCTags()
    let result = system("sh -c \"ag -g '.*\\.(c|h|cc|cpp)$' --ignore-dir=CMakeFiles | xargs ctags\"")
    echo "CTags regenerated: " . result
endfunction

" regenerate tags
nmap \T :call RegenerateCTags()<CR>

" get manual page
function! FindManualPage(name, section)
    let manpage = system("man " . a:section . " " . a:name)

    if (v:shell_error)
        if (a:section < 3)
            return FindManualPage(a:name, a:section + 1)
        else
            return ""
        endif
    endif

    return manpage
endfunction

" find struct definition in header files
function! FindStructDef(name)
    let regexp = "\\s*struct " . a:name . "\\s*{[^}]*};"
    let result = system("find /usr/include -type f -exec grep -HPzo '" . regexp . "' {} \\;")

    if (v:shell_error)
        return ""
    else
        return result
    endif
endfunction

" open manual page in split window
function! FindAndOpenManual()
    let word = expand("<cword>")
    let manpage = FindManualPage(word, 2)

    let winnr = bufwinnr("__manual__")

    if (manpage == "")
        let manpage = FindStructDef(word)
    endif

    if (manpage == "")
        " close the window, nothing to see there
        if (winnr >= 0)
            execute winnr . "wincmd w"
            wincmd q
        endif

        echo "No manual entry for " . word . "(returned: " . v:shell_error . ")"
    else
        " check if window is already opened
        if (winnr >= 0)
            " yup, jump there
            execute winnr . "wincmd w"
        else
            " nope, create it
            vsplit __manual__
        endif

        " set buffer options and content
        set filetype=man
        set buftype=nofile
        normal! gg"_dG
        call append(0, split(manpage, "\n"))

        " return to previous window
        wincmd p
    endif
endfunction

"nmap K :call FindAndOpenManual()<CR>

