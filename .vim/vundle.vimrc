filetype off
set rtp+=$HOME/.vim/bundle/Vundle.vim/
call vundle#begin()

" Let Vundle manage itself
" ========================
Plugin 'VundleVim/Vundle.vim'

" Powerline-style status bar
" ==========================
Plugin 'vim-airline/vim-airline'

let g:airline_powerline_fonts=1

" Show buffer names in the status line
" ====================================
Plugin 'bling/vim-bufferline'

" Seamless navigation between vim splits and tmux panes
" =====================================================
Plugin 'christoomey/vim-tmux-navigator'

" Colorscheme pack
" ================
Plugin 'flazz/vim-colorschemes'

" Different colors for different identifiers
" ==========================================
Plugin 'jaxbot/semantic-highlight.vim'

nmap \S :SemanticHighlightToggle<CR>

" Grep a directory, return results in quickfix list
" =================================================
Plugin 'mileszs/ack.vim'

" Use silversearcher-ag instead of ack-grep
let g:ackprg = 'ag --nogroup --nocolor --column'

" Write HTML/XML quickly
" ======================
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" Comment/uncomment parts of code
Plugin 'scrooloose/nerdcommenter'

" (un)comment and goto next line
nmap <C-_> \c<Space>j
vmap <C-_> \c<Space>'>j

" Syntax checker/linter integration
" =================================
Plugin 'scrooloose/syntastic'

" Checker commands for various languages
let g:syntastic_c_checkers = [ 'gcc' ]
let g:syntastic_cpp_checkers = [ 'gcc' ]
let g:syntastic_python_chechers = [ 'pep8' ]

" Force checking headers as well
let g:syntastic_c_check_header = 1

" Undo tree visualization
" =======================
Plugin 'simnalamburt/vim-mundo'

" Convenience shortcut
nmap \G :MundoToggle<CR>

" Syntax highlighting for GLSL
" ============================
Plugin 'tikhomirov/vim-glsl'

" Symbol case converter and other utilities
" =========================================
Plugin 'tpope/vim-abolish'

" Extra character info on `ga`
" ============================
Plugin 'tpope/vim-characterize'

" Utilities for working with Git repos
" ====================================
Plugin 'tpope/vim-fugitive'

" `.` support for actions introduced in some plugins
" ==================================================
Plugin 'tpope/vim-repeat'

" Add/delete/change parens, quotes etc.
" =====================================
Plugin 'tpope/vim-surround'

" Alternate between matching .h/.c with :A
" ========================================
Plugin 'vim-scripts/a.vim'

" cscope code browser support
" ===========================
Plugin 'vim-scripts/cscope.vim'

" Extra features for writing ReStructuredText
" ===========================================
Plugin 'Rykka/riv.vim'

" Automatic code formatting with clang-format 
" ============================================
Plugin 'rhysd/vim-clang-format'

" Auto-format on save
autocmd FileType c,cpp ClangFormatAutoEnable

" Vim configuration for Rust
" ==========================
Plugin 'rust-lang/rust.vim'

" Auto-format on save
let g:rustfmt_autosave = 1

" Quickfix list filtering
" =======================
Plugin 'sk1418/QFGrep'

" PowerShell support
" ==================
Plugin 'PProvost/vim-ps1'

" Clang-based code indexing
" =========================
Plugin 'lyuts/vim-rtags'

" Tag list in a separate split
" ============================
Plugin 'majutsushi/tagbar'

" Language Server Protocol client
" ===============================
" TODO: requires manual installation of cquery, python-language-server
Plugin 'autozimu/LanguageClient-neovim'

let g:LanguageClient_serverCommands = {
    \ 'c': ['cquery', '--log-file=/tmp/cq.log'],
    \ 'cpp': ['cquery', '--log-file=/tmp/cq.log'],
    \ 'py': ['pyls'],
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ }
let g:LanguageClient_loadSettings = 1
let g:LanguageClient_settingsPath = $HOME . '/.vim/cquery-settings.json'

nnoremap <Space> :call LanguageClient_contextMenu()<CR>
nnoremap <C-]> :call LanguageClient#textDocument_definition()<CR>

" Asynchronous completion engine
" ==============================
" TODO: requires manual `pip3 install neovim`
if has('nvim')
  Plugin 'Shougo/deoplete.nvim'
else
  Plugin 'Shougo/deoplete.nvim'
  Plugin 'roxma/nvim-yarp'
  Plugin 'roxma/vim-hug-neovim-rpc'
endif

let g:deoplete#enable_at_startup = 1

" Function signature in command line
" ==================================
Plugin 'Shougo/echodoc.vim'

call vundle#end()
