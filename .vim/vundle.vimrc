"""
" VUNDLE
"""
filetype off
set rtp+=$HOME/.vim/bundle/Vundle.vim/
call vundle#begin()

"Plugin 'Lokaltog/vim-easymotion'
"Plugin 'Lokaltog/vim-powerline'
Plugin 'vim-airline/vim-airline'
Plugin 'Valloric/YouCompleteMe'
"Plugin 'amdt/vim-niji'
"Plugin 'bigfish/vim-js-context-coloring'
Plugin 'bling/vim-bufferline'
Plugin 'christoomey/vim-tmux-navigator'
"Plugin 'davidhalter/jedi-vim'
"Plugin 'ehamberg/vim-cute-python'
Plugin 'flazz/vim-colorschemes'
Plugin 'VundleVim/Vundle.vim'
"Plugin 'jaxbot/semantic-highlight.vim'
"Plugin 'jdonaldson/vaxe'
"Plugin 'jpalardy/vim-slime'
"Plugin 'kien/ctrlp.vim'
"Plugin 'lrem/pyclewn'
Plugin 'mileszs/ack.vim'
"Plugin 'pangloss/vim-javascript'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'scrooloose/nerdcommenter'
"Plugin 'scrooloose/nerdtree'
"Plugin 'scrooloose/syntastic'

" does not work with neovim
if has('nvim')
    " replacement of gundo for neovim
    Plugin 'simnalamburt/vim-mundo'
else
    Plugin 'sjl/gundo.vim'
endif

"Plugin 'skammer/vim-css-color'
Plugin 'tikhomirov/vim-glsl'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-characterize'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
"Plugin 'vim-scripts/AutomaticLaTexPlugin'
Plugin 'vim-scripts/a.vim'
"Plugin 'vim-scripts/cscope.vim'
Plugin 'Rykka/riv.vim'
Plugin 'rhysd/vim-clang-format'

Plugin 'rust-lang/rust.vim'
"Plugin 'vim-scripts/octave.vim'
"Plugin 'cbracken/vala.vim'
"Plugin 'sk1418/QFGrep'
Plugin 'phildawes/racer'
Plugin 'PProvost/vim-ps1'
Plugin 'KabbAmine/zeavim.vim'
Plugin 'lyuts/vim-rtags'

call vundle#end()
