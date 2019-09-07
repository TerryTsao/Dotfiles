#!/bin/bash

BASEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# bash
if [ -e ~/.bashrc ]; then
    rm ~/.bashrc
fi
ln -s "$BASEDIR/bashrc" ~/.bashrc

# bash_aliases
if [ -e ~/.bash_aliases ]; then
    rm ~/.bash_aliases
fi
ln -s "$BASEDIR/bash_aliases" ~/.bash_aliases

# vim
if [ -e ~/.vim ]; then
    rm ~/.vim
fi
ln -s "$BASEDIR/vim/" ~/.vim

# vimrc
if [ -e ~/.vimrc ]; then
    rm ~/.vimrc
fi
ln -s "$BASEDIR/vimrc" ~/.vimrc

# gitconfig
if [ -e ~/.gitconfig ]; then
    rm ~/.gitconfig
fi
ln -s "$BASEDIR/gitconfig" ~/.gitconfig

# tmux.conf
if [ -e ~/.tmux.conf ]; then
    rm ~/.tmux.conf
fi
ln -s "$BASEDIR/tmux.conf" ~/.tmux.conf

# git-bash-prompt
if [ -e ~/.bash-git-prompt ]; then
    rm ~/.bash-git-prompt
fi
ln -s "$BASEDIR/bash-git-prompt" ~/.bash-git-prompt

# emacs
if [ -e ~/.emacs.d ]; then
    rm ~/.emacs.d
fi
ln -s "$BASEDIR/emacs.d" ~/.emacs.d
