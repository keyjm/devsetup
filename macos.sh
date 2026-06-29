#!/usr/bin/env bash
# macOS system defaults. Run once after bootstrap.
# Changes take effect after logout/restart for some settings.
set -e

echo "==> Applying macOS defaults..."

# ── Dock ──────────────────────────────────────────────────────────────────────
defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock show-recents -bool false

# ── Finder ────────────────────────────────────────────────────────────────────
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"   # list view
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"   # search current folder
defaults write com.apple.finder AppleShowAllFiles -bool true           # show hidden files
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# ── Screenshots ───────────────────────────────────────────────────────────────
mkdir -p "$HOME/Desktop/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Desktop/Screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# ── Keyboard ──────────────────────────────────────────────────────────────────
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false     # enable key repeat

# ── Trackpad ──────────────────────────────────────────────────────────────────
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1       # tap to click

# ── Misc ──────────────────────────────────────────────────────────────────────
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# ── Apply ─────────────────────────────────────────────────────────────────────
killall Dock
killall Finder

echo "Done. Some changes require a logout to fully take effect."
