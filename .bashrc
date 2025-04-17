shopt -s histappend
shopt -s cmdhist

export HISTFILESIZE=1000000
export HISTSIZE=1000000
export HISTCONTROL=ignoreboth
export HISTIGNORE='ls:ls *:bg:fg:history'
export HISTTIMEFORMAT='%F %T '
export PROMPT_COMMAND='history -a'

export CLICOLOR="1"
export LSCOLORS="GxFxCxDxBxegedabagaced"
export PS1="\[\033[38;5;11m\]\u\[$(tput sgr0)\]@\h:\[$(tput sgr0)\]\[\033[38;5;6m\][\[$(tput sgr0)\]\[\033[38;5;50m\]\W\[$(tput sgr0)\]\[\033[38;5;6m\]]\[$(tput sgr0)\]: \[$(tput sgr0)\]"

if [[ $(uname) == 'Darwin' ]]; then
  export PATH=/opt/homebrew/bin::$HOME/bin:$PATH
fi

export PATH=$PATH:$HOME/go/bin

# [ -f $HOME/.fzf.bash ] && source $HOME/.fzf.bash

alias g='git'
alias gd='git diff'
alias gs='git status'
alias gl='git log'
alias gpo='git push origin'
alias gaa='git add .'
alias gc='git commit'

alias mc="mc --nosubshell"

export EDITOR="vi"
export CLOUDSDK_PYTHON_SITEPACKAGES=1

[ -f $HOME/.local.bash ] && source $HOME/.local.bash
