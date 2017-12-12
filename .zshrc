# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
[[ -d $ZSH/themes/bullet-train ]] || git clone https://github.com/caiogondim/bullet-train.zsh $ZSH/themes/bullet-train
[[ -e $ZSH/themes/bullet-train.zsh-theme ]] || ln -s $ZSH/themes/bullet-train/bullet-train.zsh-theme $ZSH/themes/
ZSH_THEME="bullet-train"

BULLETTRAIN_PROMPT_CHAR="$"
BULLETTRAIN_STATUS_EXIT_SHOW=true
BULLETTRAIN_CONTEXT_SHOW=true
BULLETTRAIN_CONTEXT_DEFAULT_USER=marcin

BULLETTRAIN_PROMPT_ORDER=(
    time
    status
    custom
    context
    dir
    perl
    ruby
    virtualenv
    aws
    go
    git
)

BULLETTRAIN_STATUS_BG=22 # dark green
BULLETTRAIN_CONTEXT_BG=234 # dark grey

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to disable command auto-correction.
# DISABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git gradle vagrant)

source $ZSH/oh-my-zsh.sh

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

export PATH=$PATH:$HOME/.cabal/bin:$HOME/bin:$HOME/.local/bin:$HOME/.gem/ruby/2.3.0/bin
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

DEBEMAIL="hukutizuviki+deb@gmail.com"
DEBFULLNAME="Marcin Radomski"

DEFAULT_USER=marcin

# Always use 256-color mode
export TERM=xterm-256color
alias tmux="/usr/bin/tmux -2"

# Store core dumps by default
ulimit -c unlimited

# Git aliases
unalias glg
alias glg="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit"
alias gsuir="git submodule update --init --recursive"

# Install FZF if required
[[ -d ~/.fzf ]] || {
    git clone https://github.com/junegunn/fzf ~/.fzf
    ~/.fzf/install
}
source ~/.fzf.zsh

# Force tmux
[[ -z "$SSH_CONNECTION" && "$SHLVL" == "1" ]] && tmux

# Dotfiles repo management helper
dotfiles() {
    /usr/bin/git --git-dir "$HOME/.cfg" --work-tree="$HOME" "$@"
}

# https://unix.stackexchange.com/a/79352
mac2ipv6 () {
  local mac=$1 byte0
  printf %02x -v byte0 $((0x${mac:0:2} ^ 2)) >/dev/null
  echo "fe80::$byte0${mac:3:5}ff:fe${mac:9:5}${mac:15:2}"
}
