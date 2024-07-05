export NPM_PACKAGES="$HOME/.npm-packages"
export PATH=$HOME/bin/ccache:$PATH
export PATH=$PATH:$HOME/.bin
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/arcanist/arcanist/bin
export PATH=$PATH:$HOME/.gem/ruby/3.0.0/bin:$HOME/.gem/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$HOME/.npm-packages/bin
export MANPATH=$MANPATH:$NPM_PACKAGES/share/man
export NODE_PATH=$NODE_PATH:$NPM_PACKAGES/lib/node_modules

# export MANPATH="/usr/local/man:$MANPATH"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

color() {
  local black=30
  local red=31
  local green=32
  local yellow=33
  local blue=34
  local magenta=35
  local cyan=36
  local white=37

  local gray=90
  local ltred=91
  local ltgreen=92
  local ltyellow=93
  local ltblue=94
  local ltmagenta=95
  local ltcyan=96
  local ltwhite=97

  local bg_black=40
  local bg_red=41
  local bg_green=42
  local bg_yellow=43
  local bg_blue=44
  local bg_magenta=45
  local bg_cyan=46
  local bg_white=47

  local bg_gray=100
  local bg_ltred=101
  local bg_ltgreen=102
  local bg_ltyellow=103
  local bg_ltblue=104
  local bg_ltmagenta=105
  local bg_ltcyan=106
  local bg_ltwhite=107

  local reset=0
  local bold=1

  local STYLE=""
  while [[ "$1" != -- ]]; do
    if [[ "${(P)1}" ]]; then
      STYLE+="\x1b[${(P)1}m"
      shift
    else
      break
    fi
  done

  echo -n "${STYLE}""$@""\x1b[${reset}m"
}

verbose() {
  echo "$(color blue -- Running: "$@")"
  "$@"
}

is-installed() {
  local EXECUTABLE="$1"
  which "$EXECUTABLE" >/dev/null 2>&1
}

confirm() {
  local QUERY="$1"
  shift

  echo -n "$(color yellow -- "${QUERY} [Y/n] ")"
  read PROMPT

  case "${PROMPT}" in
    ""|y*|Y*)
      echo "Executing: $@"
      "$@"
      ;;
    *)
      echo "Skipping: $@"
      return 1
      ;;
  esac
}

is-installed git || sudo apt install -y git

bootstrap-oh-my-zsh() {
  verbose git clone https://github.com/ohmyzsh/ohmyzsh.git "$ZSH"
  [[ -d "$ZSH/themes/bullet-train" ]] || verbose git clone https://github.com/caiogondim/bullet-train.zsh.git "$ZSH/themes/bullet-train"
  [[ -e "$ZSH/themes/bullet-train.zsh-theme" ]] || verbose ln -s "$ZSH/themes/bullet-train/bullet-train.zsh-theme" "$ZSH/themes/"
  [[ -d "$ZSH/custom/zsh-async" ]] || verbose git clone https://github.com/mafredri/zsh-async.git "$ZSH/custom/zsh-async"
}

[[ -d "$ZSH" ]] || confirm "Bootstrap oh-my-zsh?" bootstrap-oh-my-zsh

bootstrap-atuin() {
    /bin/bash -c "$(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh)"
    sed -i -e '/sync_address/a sync_address = "https://home.mradomski.pl/atuin/"' "$HOME/.config/atuin/config.toml"
    atuin login -u dex
}

is-installed atuin || confirm "Bootstrap atuin?" bootstrap-atuin
eval "$(atuin init zsh)"

is-installed broot || cargo install broot
source /home/dex/.config/broot/launcher/bash/br

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="bullet-train"

BULLETTRAIN_PROMPT_CHAR="$"

BULLETTRAIN_STATUS_EXIT_SHOW=true
BULLETTRAIN_STATUS_BG=22 # dark green

BULLETTRAIN_CONTEXT_SHOW=true
BULLETTRAIN_CONTEXT_DEFAULT_USER=marcin
BULLETTRAIN_CONTEXT_BG=234 # dark grey

source "$HOME/.oh-my-zsh/custom/zsh-async/async.zsh"

_async_git_prompt_ready() {
    BULLETTRAIN_ASYNC_GIT_RESULT="${@[3]}"
    if [[ -z "$BULLETTRAIN_ASYNC_GIT_RESULT" ]]; then
        BULLETTRAIN_ASYNC_GIT_RESULT_EMPTY=1
    fi
    zle reset-prompt
    unset BULLETTRAIN_ASYNC_GIT_RESULT_EMPTY
    unset BULLETTRAIN_ASYNC_GIT_RESULT
}

_async_git_prompt_build() {
    cd "$1"
    source "$ZSH/oh-my-zsh.sh"
    source "$ZSH/custom/bullet-train.zsh-theme"
    prompt_git
}

async_init
async_start_worker async_git_prompt_worker
async_register_callback async_git_prompt_worker _async_git_prompt_ready

prompt_async_git() {
    if [[ "$BULLETTRAIN_ASYNC_GIT_RESULT_EMPTY" ]]; then
        return
    elif [[ "$BULLETTRAIN_ASYNC_GIT_RESULT" ]]; then
        prompt_segment $BULLETTRAIN_GIT_BG $BULLETTRAIN_GIT_FG "$BULLETTRAIN_ASYNC_GIT_RESULT"
    else
        prompt_segment $BULLETTRAIN_GIT_BG $BULLETTRAIN_GIT_FG "⏳"
        async_job async_git_prompt_worker _async_git_prompt_build "$PWD"
    fi
}

prompt_esp_rust() {
  if ! [[ "$LIBCLANG_PATH" =~ ".*/xtensa-esp32.*" ]]; then
    return
  fi

  prompt_segment yellow black "esp-rust"
}

BULLETTRAIN_PROMPT_ORDER=(
    time
    status
    custom
    context
    dir
    esp_rust
    perl
    ruby
    virtualenv
    go
    async_git
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
plugins=(git zsh-syntax-highlighting)

source "$ZSH/oh-my-zsh.sh"

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

[[ -f "/etc/zsh_command_not_found" ]] && source /etc/zsh_command_not_found

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
alias gcamane="git commit --amend -a --no-edit"

bootstrap-fzf() {
    git clone https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install"
}
# Install FZF if required
[[ -d "$HOME/.fzf" ]] || confirm "Bootstrap fzf?" bootstrap-fzf
source "$HOME/.fzf.zsh"

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

export CMAKE_BULLSHIT=(CMakeCache.txt CMakeFiles CPackConfig.cmake CPackSourceConfig CMakeScripts Testing CTestTestfile.cmake Makefile cmake_install.cmake install_manifest.txt compile_commands.json)
export SBT_OPTS="-Xmx4G -XX:+UseG1GC -XX:+CMSClassUnloadingEnabled -Xss2M"

if [ -f '/usr/bin/valgrind' ]; then
    export VALGRIND="/usr/bin/valgrind --leak-check=full --track-origins=yes -q --error-exitcode=63 --suppressions=$HOME/projects/libcwmp/libcwmp_test.supp"
elif [ -f '/usr/local/bin/valgrind' ]; then
    export VALGRIND="/usr/local/bin/valgrind --leak-check=full --track-origins=yes -q --error-exitcode=63 --suppressions=$HOME/projects/libcwmp/libcwmp_test.supp"
fi

# OPAM configuration
. /home/dex/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

esp32-enable() {
    . /home/dex/export-esp.sh
}
