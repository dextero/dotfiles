filetype off
call plug#begin()

" Powerline-style status bar
" ==========================
Plug 'vim-airline/vim-airline'

let g:airline_powerline_fonts=1

" Show buffer names in the status line
" ====================================
Plug 'bling/vim-bufferline'

" Seamless navigation between vim splits and tmux panes
" =====================================================
Plug 'christoomey/vim-tmux-navigator'

" Colorscheme pack
" ================
Plug 'flazz/vim-colorschemes'

" Different colors for different identifiers
" ==========================================
Plug 'jaxbot/semantic-highlight.vim'

nmap \S :SemanticHighlightToggle<CR>

" Grep a directory, return results in quickfix list
" =================================================
Plug 'mileszs/ack.vim'

" Use silversearcher-ag instead of ack-grep
let g:ackprg = 'ag --nogroup --nocolor --column'

" Write HTML/XML quickly
" ======================
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}

" Comment/uncomment parts of code
Plug 'scrooloose/nerdcommenter'

" (un)comment and goto next line
nmap <C-_> \c<Space>j
vmap <C-_> \c<Space>'>j

" Syntax checker/linter integration
" =================================
Plug 'scrooloose/syntastic'

" Checker commands for various languages
let g:syntastic_python_python_exec = 'python3 -m py_compile'
let g:syntastic_python_flake8_args = '--max-line-length=119'

let g:syntastic_python_python_exe = 'python3 -m py_compile'
let g:syntastic_python_pylint_exe = 'pylint3'

" Force checking headers as well
let g:syntastic_c_check_header = 1

" Undo tree visualization
" =======================
Plug 'simnalamburt/vim-mundo'

" Convenience shortcut
nmap \G :MundoToggle<CR>

" Syntax highlighting for GLSL
" ============================
Plug 'tikhomirov/vim-glsl'

" Symbol case converter and other utilities
" =========================================
Plug 'tpope/vim-abolish'

" Extra character info on `ga`
" ============================
Plug 'tpope/vim-characterize'

" Utilities for working with Git repos
" ====================================
Plug 'tpope/vim-fugitive'

" `.` support for actions introduced in some plugins
" ==================================================
Plug 'tpope/vim-repeat'

" Add/delete/change parens, quotes etc.
" =====================================
Plug 'tpope/vim-surround'

" Alternate between matching .h/.c with :A
" ========================================
Plug 'vim-scripts/a.vim'

" cscope code browser support
" ===========================
Plug 'vim-scripts/cscope.vim'

source $HOME/.vim/cscope_maps.vim

" Extra features for writing ReStructuredText
" ===========================================
Plug 'Rykka/riv.vim'

let g:riv_disable_folding = 1

" Automatic code formatting with clang-format 
" ============================================
Plug 'rhysd/vim-clang-format'

" Auto-format on save
"autocmd FileType c,cpp ClangFormatAutoEnable

" Vim configuration for Rust
" ==========================
Plug 'rust-lang/rust.vim'

" Auto-format on save
let g:rustfmt_autosave = 1

" Quickfix list filtering
" =======================
Plug 'sk1418/QFGrep'

" PowerShell support
" ==================
Plug 'PProvost/vim-ps1'

" Clang-based code indexing
" =========================
Plug 'lyuts/vim-rtags'

" Language Server Protocol client
" ===============================
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}

" Asynchronous completion engine
" ==============================
" TODO: requires manual `pip3 install neovim`
if has('nvim')
  Plug 'Shougo/deoplete.nvim'
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

let g:deoplete#enable_at_startup = 1
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" Function signature in command line
" ==================================
Plug 'Shougo/echodoc.vim'

" Side pane with tag overview for C/C++
" =====================================
Plug 'majutsushi/tagbar'

" Mark uncommitted changes in gutter
" ==================================
Plug 'airblade/vim-gitgutter'

" Table of contents generator for Markdown
" ========================================
Plug 'mzlogin/vim-markdown-toc'

call plug#end()
