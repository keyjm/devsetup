#!/usr/bin/env bash
# Symlink dotfiles from ~/dotfiles/home/ into ~/
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)/home"

files=(
  .zshrc
  .zprofile
  .gitconfig
  .gitconfig-personal
  .gitignore
  .p10k.zsh
)

for file in "${files[@]}"; do
  src="$DOTFILES_DIR/$file"
  dst="$HOME/$file"

  if [ -L "$dst" ]; then
    echo "  already linked: $dst"
  elif [ -f "$dst" ]; then
    echo "  backing up existing: $dst → $dst.bak"
    mv "$dst" "$dst.bak"
    ln -s "$src" "$dst"
    echo "  linked: $dst"
  else
    ln -s "$src" "$dst"
    echo "  linked: $dst"
  fi
done

echo ""
echo "==> Linking ~/.config entries..."
mkdir -p "$HOME/.config/goose"
GOOSE_SRC="$DOTFILES_DIR/.config/goose/config.yaml"
GOOSE_DST="$HOME/.config/goose/config.yaml"
if [ -L "$GOOSE_DST" ]; then
  echo "  already linked: $GOOSE_DST"
elif [ -f "$GOOSE_DST" ]; then
  echo "  backing up existing: $GOOSE_DST → $GOOSE_DST.bak"
  mv "$GOOSE_DST" "$GOOSE_DST.bak"
  ln -s "$GOOSE_SRC" "$GOOSE_DST"
  echo "  linked: $GOOSE_DST"
else
  ln -s "$GOOSE_SRC" "$GOOSE_DST"
  echo "  linked: $GOOSE_DST"
fi

echo ""
echo "Done. Open a new terminal or: source ~/.zshrc"
