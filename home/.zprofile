eval "$(/opt/homebrew/bin/brew shellenv)"

# pipx
export PATH="$PATH:$HOME/.local/bin"

# JetBrains Toolbox
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

# OrbStack
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
