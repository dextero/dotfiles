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
let g:syntastic_python_pylint_exe = 'pylint'

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

" Quickfix list filtering
" =======================
Plug 'sk1418/QFGrep'

" PowerShell support
" ==================
Plug 'PProvost/vim-ps1'

" Clang-based code indexing
" =========================
Plug 'lyuts/vim-rtags'

" Function signature in command line
" ==================================
Plug 'Shougo/echodoc.vim'

" Side pane with tag overview for C/C++
" =====================================
Plug 'majutsushi/tagbar'

" Mark uncommitted changes in gutter
" ==================================
"Plug 'airblade/vim-gitgutter'

" Table of contents generator for Markdown
" ========================================
Plug 'mzlogin/vim-markdown-toc'
Plug 'junegunn/vim-easy-align'

au FileType markdown vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>

" Rust stuff
" ==========

" source: https://github.com/sharksforarms/vim-rust/blob/master/neovim-init-lsp-cmp-rust-tools.vim
" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'

" Autocompletion framework
Plug 'hrsh7th/nvim-cmp', { 'branch': 'main' }
" cmp LSP completion
Plug 'hrsh7th/cmp-nvim-lsp', { 'branch': 'main' }
" cmp Snippet completion
Plug 'hrsh7th/cmp-vsnip', { 'branch': 'main' }
" cmp Path completion
Plug 'hrsh7th/cmp-path', { 'branch': 'main' }
Plug 'hrsh7th/cmp-buffer', { 'branch': 'main' }
" See hrsh7th other plugins for more great completion sources!

" Adds extra functionality over rust analyzer
Plug 'simrat39/rust-tools.nvim'
autocmd FileType rs setf rust

" Snippet engine
Plug 'hrsh7th/vim-vsnip'

" Optional
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" ActivityWatch watcher
"Plug 'ActivityWatch/aw-watcher-vim'

call plug#end()

if has('nvim')
    " Set completeopt to have a better completion experience
    " :help completeopt
    " menuone: popup even when there's only one match
    " noinsert: Do not insert text until a selection is made
    " noselect: Do not select, force user to select one from the menu
    set completeopt=menuone,noinsert,noselect

    " Avoid showing extra messages when using completion
    set shortmess+=c

    " Configure LSP through rust-tools.nvim plugin.
    " rust-tools will configure and enable certain LSP features for us.
    " See https://github.com/simrat39/rust-tools.nvim#configuration
    lua <<EOF

    -- nvim_lsp object
    require'lspconfig'
    require'lspconfig'.clangd.setup{}

    local opts = {
        tools = {
            autoSetHints = true,
            hover_with_actions = true,
            runnables = {
                use_telescope = true
            },
            inlay_hints = {
                show_parameter_hints = false,
                parameter_hints_prefix = "",
                other_hints_prefix = "",
            },
        },

        -- all the opts to send to nvim-lspconfig
        -- these override the defaults set by rust-tools.nvim
        -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
        server = {
            -- on_attach is a callback called when the language server attachs to the buffer
            -- on_attach = on_attach,
            settings = {
                -- to enable rust-analyzer settings visit:
                -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
                ["rust-analyzer"] = {
                    -- enable clippy on save
                    checkOnSave = {
                        command = "clippy"
                    },
                }
            }
        },
    }

    require('rust-tools').setup(opts)
EOF

    " Code navigation shortcuts
    " as found in :help lsp
    nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
    nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
    nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
    nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
    nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
    nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
    nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
    nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>

    " Quick-fix
    nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>

    " Setup Completion
    " See https://github.com/hrsh7th/nvim-cmp#basic-configuration
    lua <<EOF
    local cmp = require'cmp'
    cmp.setup({
      snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
      },
      mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        -- Add tab support
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        })
      },

      -- Installed sources
      sources = {
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = 'path' },
        { name = 'buffer' },
      },
    })
EOF

    " have a fixed column for the diagnostics to appear in
    " this removes the jitter when warnings/errors flow in
    set signcolumn=yes

    " Set updatetime for CursorHold
    " 300ms of no cursor movement to trigger CursorHold
    set updatetime=300
    " Show diagnostic popup on cursor hover
    autocmd CursorHold * lua vim.diagnostic.show()

    " Goto previous/next diagnostic warning/error
    nnoremap <silent> g[ <cmd>lua vim.diagnostic.goto_prev()<CR>
    nnoremap <silent> g] <cmd>lua vim.diagnostic.goto_next()<CR>
endif
