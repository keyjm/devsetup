#!/usr/bin/env bash
# Bootstrap a new Mac from scratch.
# Run: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/keyjm/devsetup/main/bootstrap.sh)"
set -e

echo "==> Installing Rosetta 2 (Apple Silicon)..."
if [[ $(uname -m) == "arm64" ]]; then
  if /usr/bin/pgrep -q oahd 2>/dev/null; then
    echo "  already installed"
  else
    softwareupdate --install-rosetta --agree-to-license
    echo "  installed"
  fi
else
  echo "  not needed (Intel Mac)"
fi

echo ""
echo "==> Checking Xcode Command Line Tools..."
if xcode-select -p &>/dev/null; then
  echo "  already installed"
else
  echo "  Launching installer — a dialog will appear."
  xcode-select --install 2>/dev/null || true
  echo ""
  read -rp "  Press Enter once the installation dialog has finished..."
  if ! xcode-select -p &>/dev/null; then
    echo "ERROR: Xcode CLI tools still not found. Please install them and re-run this script."
    exit 1
  fi
fi

echo ""
echo "==> Installing Homebrew..."
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "  already installed"
fi

echo ""
echo "==> Cloning dotfiles..."
if [ ! -d "$HOME/dotfiles" ]; then
  git clone https://github.com/keyjm/devsetup.git "$HOME/dotfiles"
else
  echo "  already cloned, pulling..."
  git -C "$HOME/dotfiles" pull
fi

echo ""
echo "==> Installing from Brewfile..."
brew bundle --file="$HOME/dotfiles/Brewfile"

echo ""
echo "==> Installing oh-my-zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "  already installed"
fi

echo ""
echo "==> Symlinking dotfiles..."
bash "$HOME/dotfiles/install.sh"

echo ""
echo "==> Installing Python versions via pyenv..."
eval "$(pyenv init --path)"
pyenv install -s 3.11.8
pyenv global 3.11.8

echo ""
echo "==> Installing Node versions via nvm..."
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix nvm)/nvm.sh" ] && source "$(brew --prefix nvm)/nvm.sh"
nvm install 22.14.0
nvm install 26.1.0
nvm alias default 26.1.0
nvm use default

echo ""
echo "==> Installing Claude Code settings..."
mkdir -p "$HOME/.claude"
if [ ! -f "$HOME/.claude/settings.json" ]; then
  cp "$HOME/dotfiles/home/.claude/settings.json" "$HOME/.claude/settings.json"
  echo "  installed: ~/.claude/settings.json"
else
  echo "  already exists: ~/.claude/settings.json — skipping"
fi

echo ""
echo "==> Authenticating GitHub CLI..."
if gh auth status &>/dev/null; then
  echo "  already authenticated"
else
  gh auth login
fi

echo ""
echo "==> Setting up iTerm2 preferences..."
ITERM_PREFS="$HOME/dotfiles/home/iterm2"
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$ITERM_PREFS"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
echo "  iTerm2 will load prefs from: $ITERM_PREFS"

echo ""
echo "==> Applying macOS defaults..."
bash "$HOME/dotfiles/macos.sh"

echo ""
echo "==> Setting up SSH..."
bash "$HOME/dotfiles/ssh.sh"

echo ""
echo "============================================"
echo "Bootstrap complete!"
echo ""
echo "Manual steps remaining:"
echo "  1. Create ~/.env.secrets:"
echo "       export ANTHROPIC_API_KEY=..."
echo "       export GEMINI_API_KEY=..."
echo "       export HASS_SERVER=http://192.168.1.63:8123"
echo "       export HASS_TOKEN=..."
echo "  2. Copy ~/.ssh/ha_key (HA private key) from old machine"
echo "  3. Add SSH public key to GitHub: https://github.com/settings/ssh/new"
echo "       pbcopy < ~/.ssh/id_ed25519.pub"
echo "  4. Sign in to: Firefox, OrbStack"
echo "  5. Restart iTerm2 to load saved preferences"
echo "============================================"
