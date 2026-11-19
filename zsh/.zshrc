# Zsh and Docker CLI autocompletion (cached daily for faster startup)
fpath=(~/.docker/completions $fpath)
autoload -Uz compinit
if [ ! -f ~/.zcompdump ] || [ -n "$(find ~/.zcompdump -mtime +1 2>/dev/null)" ]; then
  compinit
else
  compinit -C
fi

# Command history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

# System and user PATH (no duplicates)
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.local/bin:$HOME/.antigravity/antigravity/bin:$PATH"

# Rust / Cargo
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# NVM (lazy-loaded for faster shell startup)
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  _load_nvm() {
    unset -f nvm node npm npx _load_nvm
    \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  }
  nvm()  { _load_nvm && nvm "$@"; }
  node() { _load_nvm && node "$@"; }
  npm()  { _load_nvm && npm "$@"; }
  npx()  { _load_nvm && npx "$@"; }
fi

# Plugins (macOS Homebrew & Linux system paths)
for _zsh_plugin in \
  /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; do
  [ -f "$_zsh_plugin" ] && source "$_zsh_plugin"
done
unset _zsh_plugin

# CLI tool integrations
command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)
if command -v eza >/dev/null 2>&1; then
  alias ls="eza --icons"
  alias ll="eza -la --icons --git"
fi
if command -v bat >/dev/null 2>&1; then
  alias cat="bat --paging=never"
elif command -v batcat >/dev/null 2>&1; then
  alias bat="batcat"
  alias cat="batcat --paging=never"
fi

# Starship (always at the end)
eval "$(starship init zsh)"

# Transient prompt (collapse executed prompts to ❯, restore full prompt on precmd)
__starship_prompt="$PROMPT"
__starship_rprompt="$RPROMPT"
__starship_restore_prompt() {
  PROMPT="$__starship_prompt"
  RPROMPT="$__starship_rprompt"
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd __starship_restore_prompt
zle-line-finish() {
  PROMPT="%F{green}❯%f "
  RPROMPT=""
  zle reset-prompt
}
zle -N zle-line-finish

# Load machine-specific local configuration (not tracked in git)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
