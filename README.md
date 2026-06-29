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
6. Apply macOS system defaults (`macos.sh`)
7. Generate an SSH key and configure `~/.ssh/config` (`ssh.sh`)

## After bootstrap

Create `~/.env.secrets` (never commit this):

```bash
export GEMINI_API_KEY=...
export HASS_SERVER=http://192.168.1.63:8123
export HASS_TOKEN=...
```

Sign in to: Firefox, VS Code, OrbStack.

## Structure

```
bootstrap.sh          # run once on a new machine
install.sh            # symlinks home/* into ~/
macos.sh              # macOS system defaults
ssh.sh                # SSH key + config setup
Brewfile              # all packages
home/
  .zshrc
  .zprofile
  .gitconfig
  .gitconfig-personal  # personal identity for ~/Projects/code/keyjm/
  .gitignore
  .p10k.zsh
```

## Git identity

Global git config defaults to the work identity. Any repo under `~/Projects/code/keyjm/` automatically uses:
- **Name:** Kunal Malviya
- **Email:** kunalmalviya@hotmail.com

This is handled via `includeIf` in `.gitconfig`.
