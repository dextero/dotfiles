filetype off
call plug#begin('$HOME/.vim/plugged')

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
let g:syntastic_c_checkers = [ 'gcc' ]
let g:syntastic_cpp_checkers = [ 'gcc' ]
let g:syntastic_python_chechers = [ 'pep8' ]

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
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

let g:gitgutter_sign_added='┃'
let g:gitgutter_sign_modified='┃'
let g:gitgutter_sign_removed='◢'
let g:gitgutter_sign_removed_first_line='◥'
let g:gitgutter_sign_modified_removed='◢'

" `.` support for actions introduced in some plugins
" ==================================================
Plug 'tpope/vim-repeat'

" Add/delete/change parens, quotes etc.
" =====================================
Plug 'tpope/vim-surround'

" Alternate between matching .h/.c with :A
" ========================================
Plug 'vim-scripts/a.vim'

" Extra features for writing ReStructuredText
" ===========================================
Plug 'Rykka/riv.vim'

" Automatic code formatting with clang-format
" ===========================================
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

" Tag list in a separate split
" ============================
Plug 'majutsushi/tagbar'

" Language Server Protocol client
" ===============================
" TODO: requires manual installation of cquery, python-language-server
"Plug 'autozimu/LanguageClient-neovim'
"
"let g:LanguageClient_serverCommands = {
"    \ 'c': ['ccls', '--log-file=/tmp/cc.log'],
"    \ 'cpp': ['ccls', '--log-file=/tmp/cc.log'],
"    \ 'cuda': ['ccls', '--log-file=/tmp/cc.log'],
"    \ 'objc': ['ccls', '--log-file=/tmp/cc.log'],
"    \ 'py': ['pyls'],
"    \ 'rust': ['rustup', 'run', system('rustup show active-toolchain | sed -e s/-.*$//'), 'rls'],
"    \ }
"let g:LanguageClient_loadSettings = 1
"let g:LanguageClient_settingsPath = $HOME . '/.vim/cquery-settings.json'
"
"nnoremap <Space> :call LanguageClient_contextMenu()<CR>
"nnoremap <C-]> :call LanguageClient#textDocument_definition()<CR>

Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install() } }

" if hidden not set, TextEdit might fail.
"set hidden

" Better display for messages
set cmdheight=2

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
"autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` for format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` for fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)


" Add diagnostic info for https://github.com/itchyny/lightline.vim
let g:lightline = {
      \ 'colorscheme': 'jelleybeans',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status'
      \ },
      \ }



" Shortcuts for denite interface
" Show extension list
nnoremap <silent> <space>e  :<C-u>Denite coc-extension<cr>
" Show symbols of current buffer
nnoremap <silent> <space>o  :<C-u>Denite coc-symbols<cr>
" Search symbols of current workspace
nnoremap <silent> <space>t  :<C-u>Denite coc-workspace<cr>
" Show diagnostics of current workspace
nnoremap <silent> <space>a  :<C-u>Denite coc-diagnostic<cr>
" Show available commands
nnoremap <silent> <space>c  :<C-u>Denite coc-command<cr>
" Show available services
nnoremap <silent> <space>s  :<C-u>Denite coc-service<cr>
" Show links of current buffer
nnoremap <silent> <space>l  :<C-u>Denite coc-link<cr>

" Asynchronous completion engine
" ==============================
" TODO: requires manual `pip3 install neovim`
"if has('nvim')
"  Plug 'Shougo/deoplete.nvim'
"else
"  Plug 'Shougo/deoplete.nvim'
"  Plug 'roxma/nvim-yarp'
"  Plug 'roxma/vim-hug-neovim-rpc'
"endif
"
"let g:deoplete#enable_at_startup = 1
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" Function signature in command line
" ==================================
Plug 'Shougo/echodoc.vim'

call plug#end()
