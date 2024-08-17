export CLICOLOR="1"
export LSCOLORS="GxFxCxDxBxegedabagaced"
export PS1="\[\033[38;5;11m\]\u\[$(tput sgr0)\]@\h:\[$(tput sgr0)\]\[\033[38;5;6m\][\[$(tput sgr0)\]\[\033[38;5;50m\]\W\[$(tput sgr0)\]\[\033[38;5;6m\]]\[$(tput sgr0)\]: \[$(tput sgr0)\]"

if [[ $(uname) == 'Darwin' ]]; then
  export PATH=/opt/homebrew/bin::$HOME/bin:$PATH
fi

[ -f $HOME/.fzf.bash ] && source $HOME/.fzf.bash


alias g='git'
alias gd='git diff'
alias gs='git status'
alias gl='git log'
alias gpo='git push origin'
alias gaa='git add .'
alias gc='git commit'

alias mc="mc --nosubshell"

export EDITOR="vim"
export CLOUDSDK_PYTHON_SITEPACKAGES=1

[ -f $HOME/.local.bash ] && source $HOME/.local.bash

function title () { echo -e "\033]0;$1\007"; }
