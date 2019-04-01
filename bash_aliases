if [ "$SHELL" = "/usr/local/bin/zsh" ]; then
    setopt aliases
else
    shopt -s expand_aliases
fi

# Most useful
alias vi=vim
alias ..='cd ..'

# ssh to school
alias edlab='ssh -l xiaoxiangcao elnux7.cs.umass.edu'

# restart wifi
alias wifi='sudo service network-manager restart'

# kill all background jobs
alias kj='kill `jobs -p`'

# launch eclipse ee
alias ee='export SWT_GTK3=0; ~/eclipse/eclipse &> /dev/null &'

# gradle wrapper
alias gw='./gradlew'

# python activate
alias activate='. env/bin/activate'

# data science activate
alias ds='. ~/va/homework/env/bin/activate'

# jupyter notebook
alias jj='jupyter-notebook'

alias xo='xdg-open'
alias yy='cp ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py .'

### deepmotion.ai

alias nv='ssh nvidia@10.10.99.143'
alias cc='ssh xiaoxiang@10.10.99.230'

alias f='fuck'

