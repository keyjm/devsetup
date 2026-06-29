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

cat > "$HOME/.ssh/config" <<'EOF'
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
  AddKeysToAgent yes
EOF

chmod 600 "$HOME/.ssh/config"

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
