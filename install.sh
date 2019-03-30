#!/bin/bash

ln -s $HOME/dotfiles/.vimrc $HOME/.vimrc
ln -s $HOME/dotfiles/.tmux.conf $HOME/.tmux.conf
ln -s $HOME/dotfiles/.zshrc $HOME/.zshrc
ln -s $HOME/dotfiles/.imwheelrc $HOME/.imwheelrc

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

mkdir -p $HOME/.vim/autoload && curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

mkdir -p $HOME/.vim/bundle $HOME/.vim/autoload $HOME/.vim/colors

pushd $HOME/.vim/
git clone https://github.com/ctrlpvim/ctrlp.vim.git bundle/ctrlp.vim
git clone https://github.com/scrooloose/nerdtree.git bundle/nerdtree
git clone https://github.com/fatih/vim-go.git bundle/vim-go
popd 


