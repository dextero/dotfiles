# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
[[ -d $ZSH/themes/bullet-train ]] || git clone https://github.com/caiogondim/bullet-train.zsh $ZSH/themes/bullet-train
[[ -e $ZSH/themes/bullet-train.zsh-theme ]] || ln -s $ZSH/themes/bullet-train/bullet-train.zsh-theme $ZSH/themes/
ZSH_THEME="bullet-train"

BULLETTRAIN_PROMPT_CHAR="◤"
BULLETTRAIN_STATUS_EXIT_SHOW=true
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
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

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

export TERM=xterm-256color

ulimit -v 8192000
ulimit -c unlimited

unalias glg
alias glg="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit"
alias gsuir="git submodule update --init --recursive"
alias tmux="/usr/bin/tmux -2"

if [[ -d '/usr/lib/qt5/bin' ]]; then
    for FILE in /usr/lib/qt5/bin/* ; do
        NAME="$(basename $FILE)"
        alias qt5-$NAME=$FILE
    done
fi

function bcut {
    local OFFSET="$1"
    local BYTES="$2"
    local FILE="$3"

    if [[ -z "$OFFSET" || -z "$BYTES" ]]; then
        echo "usage: bcut OFFSET BYTES [FILE]"
        return 1
    fi

    [[ -z "$FILE" ]] && FILE='/dev/stdin'

    dd if="$FILE" ibs=1 skip="$OFFSET" count="$BYTES" 2>/dev/null
}

colorize_log() {
    "$@" 2>&1 | gawk '{
        switch ($0) {
            case / TRACE /:   { color = "\033[37;2m"; break }
            case / INFO /:    { color = "\033[32m"; break }
            case / WARNING /: { color = "\033[33m"; break }
            case / ERROR /:   { color = "\033[31m"; break }
            default:          { color = ""; break }
        }
        print color $0 "\033[0m"
    }'
}

source ~/.fzf.zsh

if [[ -z "$SSH_CONNECTION" && "$SHLVL" == "1" ]]; then
    tmux
fi


remote_wireshark() {
    local host="$1"
    shift
    local iface="$1"
    shift
    local tcpdump_args="$@"
    ssh "$host" "tcpdump -s0 -U -n -w - -i "$iface" '$tcpdump_args'" | wireshark -k -i -
}

make-latex-diff() {
    git status &>/dev/null || { echo "not a git repository: $PWD"; return 1; }
    [[ "$1" && "$2" ]] || { echo "usage: $0 COMMIT MAIN_INPUT"; return 1; }

    local TMPDIR="$(mktemp -d)"
    cat /dev/null >"$TMPDIR/null"
    for FILE in $(find -name '*.tex'); do
        local PREAMBLE=""
        [[ "$FILE" != "$2" && "$FILE" != "./$2" ]] && PREAMBLE="-p$TMPDIR/null"
        mkdir -p "$TMPDIR/$(dirname "$FILE")"
        latexdiff $PREAMBLE <(git show "$1":"$FILE") "$FILE" > "$TMPDIR/$FILE"
    done

    TEXINPUTS="$TMPDIR:$PWD:$TEXINPUTS" pdflatex "$TMPDIR/$2" -halt-on-error &>/dev/null
    biber --output-directory "$TMPDIR" --input-directory "$PWD" "${2%.tex}" &>/dev/null
    TEXINPUTS="$TMPDIR:$PWD:$TEXINPUTS" pdflatex "$TMPDIR/$2" -halt-on-error &>/dev/null

    rm -rf "$TMPDIR"
}

_openocd() {
    local PREFIX=/usr/local/share/openocd/scripts/
    local MATCHES=$(find "$PREFIX" -type f \
                    | sed -e "s|^${PREFIX}||" \
                    | paste -sd\ )

    _arguments "(--file -f)"{--file,-f}"[script]:script:(${MATCHES})" \
               "(--search -s)"{--search,-s}"[dir_path]:dirname:_files -/" \
               "(--log_output -l)"{--log_output,-l}"[file]:filename: files"

    #local -a args
    #args=({--file,-f}':script')
    #_describe 'openocd' args
}

compdef _openocd openocd

dotfiles() {
    /usr/bin/git --git-dir "$HOME/.cfg" --work-tree="$HOME" "$@"
}
