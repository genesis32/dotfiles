#!/bin/bash

sudo apt-get update && sudo apt-get install curl vim git -y

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

ln -s $HOME/dotfiles/.vimrc $HOME/.vimrc
