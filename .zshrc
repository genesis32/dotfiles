export PATH=$HOME/bin:$HOME/.local/bin:$PATH

if [[ -d "/opt/homebrew/bin" ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="simple"

plugins=(
  git 
  sudo 
  colored-man-pages
  zsh-autosuggestions 
  zsh-syntax-highlighting
  zsh-history-substring-search
)

source $ZSH/oh-my-zsh.sh

if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

local nix_indicator=""
[[ -n "$IN_NIX_SHELL" || -n "$NIX_BUILD_TOP" ]] && nix_indicator="❄️ "
PROMPT="${nix_indicator}${PROMPT}"

mdotenv() {
  set -a; source "${1:-.env}"; set +a
}

export EDITOR='vim'

[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down
