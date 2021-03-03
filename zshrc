autoload -U compinit && compinit

# If you come from bash you might have to change your $PATH.
export PATH=$PATH:$HOME/bin:/usr/local/bin

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

DEFAULT_USER=`whoami`

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

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
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  docker
  docker-compose
  pip
  vi-mode
  vundle
  tmux
  tmuxinator
  ssh-agent
  colored-man-pages
  history-substring-search
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
source ~/.bash_aliases

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# bind UP and DOWN arrow keys
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" up-line-or-beginning-search
bindkey "$terminfo[kcud1]" down-line-or-beginning-search

# bind UP and DOWN arrow keys (compatibility fallback
# for Ubuntu 12.04, Fedora 21, and MacOSX 10.9 users)
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# bind P and N for EMACS mode
bindkey -M emacs '^P' up-line-or-beginning-search
bindkey -M emacs '^N' down-line-or-beginning-search

# bind k and j for VI mode
bindkey -M vicmd 'k' up-line-or-beginning-search
bindkey -M vicmd 'j' down-line-or-beginning-search

bindkey '^[[Z' reverse-menu-complete

# tags
function tags() {
    rm -rf TAGS tags cscope.*
    # ctags -eR --langmap=c++:+.cu.cuh "$PWD"
    ctags -R --langmap=c++:+.cu.cuh "$PWD"
    find "$PWD" -name "*.c" -o -name "*.cpp" -o -name "*.h" -o -name "*.hpp" -o -name "*.cu" -o -name "*.cuh" -o -name "*.py" > cscope.files
    cscope -qRbi cscope.files
}

# export LD_LIBRARY_PATH=/usr/local/cuda/lib64/:/home/xiaoxiangcao/Downloads/TensorRT-4.0.1.6/lib
export PATH=/usr/local/cuda/bin:$PATH

export PYTHONPATH=~/Documents/caffe/python

# vim as editor

export VISUAL=vim
export EDITOR="$VISUAL"


# source /opt/ros/kinetic/setup.zsh

export GTAGSCONF=/usr/local/share/gtags/gtags.conf
export GTAGSLABEL=pygments

PS1="
$PS1
$ "


# eval $(thefuck --alias)

function e() {
    if [ "-c" = "$1" ]; then
        flag="$1"
        shift
    else
        flag=
    fi
    if [ -z "$1" ]; then
        file="."
    else
        file=
    fi
    eval `echo emacsclient --no-wait "$flag $@ $file"`;
}

function ee() {
    e "$@" && exit;
}

function ec() {
    e -c "$@";
}

function ece() {
    e -c "$@" && exit;
}

umask 022

TTRR=' --rsync-path=/opt/Free_eMMC1/usr/bin/rsync'
. ~/.pyenv/versions/env3/bin/activate
