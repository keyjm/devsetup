# devsetup

Mac dev environment — dotfiles, Brewfile, and bootstrap scripts.

## Bootstrap a new Mac

Run this in Terminal on a fresh machine:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/keyjm/devsetup/main/bootstrap.sh)"
```

This will:
1. Install Xcode CLI tools + Homebrew
2. Clone this repo to `~/dotfiles`
3. Install everything in `Brewfile` (brew, cask, npm)
4. Install oh-my-zsh
5. Symlink dotfiles from `home/` into `~/`
6. Install Python 3.11.8 via pyenv and Node v22.14.0 + v26.1.0 via nvm
7. Install Claude Code settings (`~/.claude/settings.json`)
8. Apply macOS system defaults (`macos.sh`)
9. Generate SSH key and configure `~/.ssh/config` for GitHub + Home Assistant

## After bootstrap (manual steps)

**1. Add secrets file** (never commit this):

```bash
cat > ~/.env.secrets <<'EOF'
export GEMINI_API_KEY=...
export HASS_SERVER=http://192.168.1.63:8123
export HASS_TOKEN=...
EOF
```

**2. Copy Home Assistant SSH key from old machine:**

```bash
scp ~/.ssh/ha_key user@oldmachine:~/.ssh/ha_key
scp ~/.ssh/ha_key.pub user@oldmachine:~/.ssh/ha_key.pub
chmod 600 ~/.ssh/ha_key
```

**3. Add new SSH public key to GitHub:**

```bash
pbcopy < ~/.ssh/id_ed25519.pub
# Then visit: https://github.com/settings/ssh/new
```

**4. Sign in to:** Firefox, OrbStack

## Structure

```
bootstrap.sh              # run once on a new machine
install.sh                # symlinks home/* into ~/
macos.sh                  # macOS system defaults
ssh.sh                    # SSH key + config setup
Brewfile                  # all packages
home/
  .zshrc
  .zprofile
  .gitconfig
  .gitconfig-personal     # personal identity for ~/Projects/code/keyjm/
  .gitignore
  .p10k.zsh
  .claude/
    settings.json         # Claude Code plugins (no secrets)
```

## Git identity

Global git config defaults to the work identity. Any repo under `~/Projects/code/keyjm/` automatically uses:
- **Name:** Kunal Malviya
- **Email:** kunalmalviya@hotmail.com

This is handled via `includeIf` in `.gitconfig`.
