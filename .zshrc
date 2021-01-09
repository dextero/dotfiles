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
BULLETTRAIN_STATUS_BG=22 # dark green

BULLETTRAIN_CONTEXT_SHOW=true
BULLETTRAIN_CONTEXT_DEFAULT_USER=marcin
BULLETTRAIN_CONTEXT_BG=234 # dark grey

BULLETTRAIN_PROMPT_ORDER=(
    time
    status
    custom
    context
    dir
    perl
    ruby
    virtualenv
    go
    git
)

HISTSIZE=-1
HISTFILESIZE=-1

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

source /etc/zsh_command_not_found

export NPM_PACKAGES="$HOME/.npm-packages"

export PATH=$HOME/bin/ccache:$PATH
export PATH=$PATH:$HOME/.bin
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/arcanist/arcanist/bin
export PATH=$PATH:$HOME/.gem/ruby/2.5.0/bin:$HOME/.gem/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$HOME/.npm-packages/bin

export MANPATH=$MANPATH:$NPM_PACKAGES/share/man

export NODE_PATH=$NODE_PATH:$NPM_PACKAGES/lib/node_modules

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
export TERM=tmux-256color
alias tmux="/usr/bin/tmux -2"

# Store core dumps by default
ulimit -c unlimited

# Git aliases
unalias glg
alias glg="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit"
alias gstl="git stash list --color --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue) <%an>%Creset' --abbrev-commit"
alias gsuir="git submodule update --init --recursive"
gssuir() { git submodule sync; gsuir }

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

# Non-destructive rm
alias RM='/bin/rm'
TRASH_DIR="$HOME/trash"

rm() {
    TIMESTAMP=`date +'%s'`
    DEST_DIR="$TRASH_DIR/$TIMESTAMP/"
    [ -e "$DEST_DIR" ] || mkdir -p "$DEST_DIR"

    local -a RM_ARGS
    RM_ARGS=()
    for ARG in $@; do
        if [ "$ARG" != '-rf' ]; then
            if [ "${ARG:0:1}" = '-' ]; then
                echo "unknown option: $ARG, use /bin/rm"
            fi

            RM_ARGS+=("$ARG")
        fi
    done

    mv ${RM_ARGS[@]} "$DEST_DIR"
}

# Git helpers
rebase-cascade() {
    while [[ $# -gt 1 ]]; do
        local BASE=$1
        local TOP=$2

        git checkout $TOP || return 1
        git rebase $BASE || return 1
        shift
    done
}

git-extract-changes-to-file() {
    [[ "$@" ]] \
        || { echo "Usage: $0 FILES..."; return 1 }
    git diff-index --quiet @ -- \
        || { echo "Commit your changes first"; return 1 }

    git checkout @~1 "$@" \
        && git commit -m "Extract $* helper" \
        && git revert --no-edit @ \
        && git reset @~1 \
        && git stash \
        && git reset @~1 \
        && git commit --amend -a --no-edit \
        && git stash pop \
        && git commit -am "Extract changes to $* from previous commit"
}

tts() {
    local DOMAIN="${DOMAIN:-zygfryd.comp.avsystem.in}"
    http --verbose get "http://$DOMAIN:8000/play/tts/pl/$(python -c 'import urllib; import sys; print(urllib.quote(sys.stdin.read().strip()))' <<<"$*")"
}

export KURWA='--conduit-uri=https://phabricator.avsystem.com'
export CMAKE_BULLSHIT=(CMakeCache.txt CMakeFiles CPackConfig.cmake CPackSourceConfig CMakeScripts Testing CTestTestfile.cmake Makefile cmake_install.cmake install_manifest.txt compile_commands.json)
export SBT_OPTS="-Xmx4G -XX:+UseG1GC -XX:+CMSClassUnloadingEnabled -Xss2M"

if [ -f '/usr/bin/valgrind' ]; then
    export VALGRIND="/usr/bin/valgrind --leak-check=full --track-origins=yes -q --error-exitcode=63 --suppressions=$HOME/projects/libcwmp/libcwmp_test.supp"
elif [ -f '/usr/local/bin/valgrind' ]; then
    export VALGRIND="/usr/local/bin/valgrind --leak-check=full --track-origins=yes -q --error-exitcode=63 --suppressions=$HOME/projects/libcwmp/libcwmp_test.supp"
fi
