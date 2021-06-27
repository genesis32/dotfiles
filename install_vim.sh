#!/bin/bash

sudo apt-get update && sudo apt-get install curl vim git -y

ln -s $HOME/dotfiles/.vimrc $HOME/.vimrc

mkdir -p $HOME/.vim/autoload && curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

mkdir -p $HOME/.vim/bundle $HOME/.vim/autoload $HOME/.vim/colors

pushd $HOME/.vim/
git clone https://github.com/ctrlpvim/ctrlp.vim.git bundle/ctrlp.vim
git clone https://github.com/scrooloose/nerdtree.git bundle/nerdtree
git clone https://github.com/fatih/vim-go.git bundle/vim-go
popd


