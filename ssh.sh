#!/usr/bin/env bash
# Set up SSH key and config for GitHub (keyjm personal account).
set -e

KEY="$HOME/.ssh/id_ed25519"

echo "==> Setting up SSH..."

if [ -f "$KEY" ]; then
  echo "  SSH key already exists at $KEY — skipping generation"
else
  read -rp "  Email for SSH key (default: kunalmalviya@hotmail.com): " email
  email="${email:-kunalmalviya@hotmail.com}"
  ssh-keygen -t ed25519 -C "$email" -f "$KEY" -N ""
  echo "  Key generated: $KEY"
fi

echo ""
echo "==> Writing ~/.ssh/config..."
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
touch "$HOME/.ssh/config"
chmod 600 "$HOME/.ssh/config"

add_ssh_block() {
  local host="$1" block="$2"
  if ! grep -q "Host $host" "$HOME/.ssh/config"; then
    echo "" >> "$HOME/.ssh/config"
    echo "$block" >> "$HOME/.ssh/config"
    echo "  added: Host $host"
  else
    echo "  already present: Host $host"
  fi
}

add_ssh_block "github.com" "Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
  AddKeysToAgent yes"

add_ssh_block "homeassistant" "Host homeassistant
  HostName 192.168.1.63
  User hassio
  IdentityFile ~/.ssh/ha_key
  StrictHostKeyChecking no"

echo ""
echo "==> Adding github.com to known_hosts..."
mkdir -p "$HOME/.ssh"
ssh-keyscan github.com >> "$HOME/.ssh/known_hosts" 2>/dev/null
echo "  done"

echo ""
echo "==> Adding key to ssh-agent..."
eval "$(ssh-agent -s)" > /dev/null
ssh-add --apple-use-keychain "$KEY" 2>/dev/null || ssh-add "$KEY"

echo ""
echo "============================================"
echo "Next: add your public key to GitHub"
echo ""
echo "  Copy it:  pbcopy < $KEY.pub"
echo "  Then go to: https://github.com/settings/ssh/new"
echo ""
cat "$KEY.pub"
echo "============================================"
