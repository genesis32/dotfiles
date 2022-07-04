export CLICOLOR="1"
export LSCOLORS="GxFxCxDxBxegedabagaced"
export PS1="\[\033[38;5;11m\]\u\[$(tput sgr0)\]@\h:\[$(tput sgr0)\]\[\033[38;5;6m\][\[$(tput sgr0)\]\[\033[38;5;50m\]\W\[$(tput sgr0)\]\[\033[38;5;6m\]]\[$(tput sgr0)\]: \[$(tput sgr0)\]"

if [[ $(uname) == 'Darwin' ]]; then
  export PATH=/opt/homebrew/bin:$PATH
fi

[ -f $HOME/.fzf.bash ] && source $HOME/.fzf.bash

[ -f $HOME/.local.bash ] && source $HOME/.local.bash

alias g='git'
