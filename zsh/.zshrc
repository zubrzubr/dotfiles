# Zsh and Docker CLI autocompletion
fpath=(~/.docker/completions $fpath)
autoload -Uz compinit && compinit

# Command history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

# System and user PATH (no duplicates)
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.local/bin:$HOME/.antigravity/antigravity/bin:$PATH"

# Rust / Cargo
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Starship (always at the end)
eval "$(starship init zsh)"

# Load machine-specific local configuration (not tracked in git)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
