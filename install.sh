#!/usr/bin/env bash
set -u

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$(uname -s)" in
  Darwin) OS=darwin ;;
  Linux)  OS=linux ;;
  *)      echo "unsupported platform: $(uname -s)" >&2; exit 1 ;;
esac

# link <src-in-dotfiles> <dest>
#
# If the dest (or a parent of it) is already a symlink back into $DOTFILES,
# `ln -sfn` resolves through it and writes into the repo -- clobbering the
# source with a link to itself when the names match, or dropping a stray file
# in the working tree when they don't. Either way, bail out.
link() {
  local src="$DOTFILES/$1" dest="$2" destdir
  destdir="$(dirname "$dest")"
  mkdir -p "$destdir"

  local realdir="$(cd "$destdir" && pwd -P)"
  if [ "$realdir" = "$DOTFILES" ] || [ "${realdir#"$DOTFILES"/}" != "$realdir" ]; then
    echo "skipping $dest: resolves inside $DOTFILES (is a parent dir symlinked into the repo?)" >&2
    return
  fi

  ln -sfn "$src" "$dest"
}

link .tmux.conf "$HOME/.tmux.conf"
link .vimrc "$HOME/.vimrc"
link .ideavimrc "$HOME/.ideavimrc"
link .config/nvim/init.lua "$HOME/.config/nvim/init.lua"

# ghostty reads ~/.config/ghostty/config on both linux and macos. The shared
# config pulls in ./os.conf, which points at the per-platform overrides.
link .config/ghostty/config "$HOME/.config/ghostty/config"
link ".config/ghostty/os.$OS" "$HOME/.config/ghostty/os.conf"

# on macos ghostty ALSO reads Application Support, which wins over ~/.config;
# move any hand-written one aside so the dotfiles config is what takes effect.
GHOSTTY_MAC_CONFIG="$HOME/Library/Application Support/com.mitchellh.ghostty/config"
if [ "$OS" = darwin ] && [ -f "$GHOSTTY_MAC_CONFIG" ] && [ ! -L "$GHOSTTY_MAC_CONFIG" ]; then
  backup="$GHOSTTY_MAC_CONFIG.bak"
  [ -e "$backup" ] && backup="$backup.$(date +%Y%m%d%H%M%S)"
  mv "$GHOSTTY_MAC_CONFIG" "$backup"
  echo "moved $GHOSTTY_MAC_CONFIG -> $backup"
fi

# zsh
if ! command -v zsh >/dev/null 2>&1; then
  if [ "$OS" = linux ]; then
    if command -v apt-get >/dev/null 2>&1; then
      sudo apt-get update && sudo apt-get install -y zsh
    elif command -v dnf >/dev/null 2>&1; then
      sudo dnf install -y zsh
    elif command -v pacman >/dev/null 2>&1; then
      sudo pacman -S --noconfirm zsh
    else
      echo "install zsh manually, then re-run this script" >&2
      exit 1
    fi
  else
    echo "zsh not found on macos?" >&2
    exit 1
  fi
fi

ZSH_PATH="$(command -v zsh)"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

rm -f "$HOME/.zshrc"
link .zshrc "$HOME/.zshrc"

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
for plugin in zsh-syntax-highlighting zsh-autosuggestions zsh-history-substring-search; do
  dest="$ZSH_CUSTOM/plugins/$plugin"
  if [ -d "$dest" ]; then
    git -C "$dest" pull --ff-only
  else
    git clone "https://github.com/zsh-users/$plugin" "$dest"
  fi
done

# make zsh the login shell
if [ "$SHELL" != "$ZSH_PATH" ]; then
  if ! grep -qxF "$ZSH_PATH" /etc/shells; then
    echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
  fi
  chsh -s "$ZSH_PATH" || echo "chsh failed; run: chsh -s $ZSH_PATH" >&2
fi
