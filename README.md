# dotfiles

Personal cross-platform dotfiles for **macOS** and **Linux** (KDE Plasma & GNOME), managed with [GNU Stow](https://www.gnu.org/software/stow/) and unified around a **Gruvbox Dark** theme.

## Structure

```text
.
├── git/.config/git/          # Git config (delta side-by-side diffs) & global ignore
├── homebrew/Brewfile         # CLI tools, Zsh plugins, Nerd Font & iTerm2 (macOS)
├── install.sh                # Automated backup, Brew bundle, and Stow setup
├── nvim/.config/nvim/        # Modular Neovim config (lazy.nvim, gruvbox, LSP)
├── starship/.config/         # Starship prompt (gruvbox_dark, cockpit modules)
└── zsh/.zshrc                # Zsh config, history, NVM, plugins, CLI integrations
```

## Installation

Clone the repository and run the install script:

```bash
git clone <your-repo-url> ~/Projects/dotfiles
cd ~/Projects/dotfiles
./install.sh
```

What `install.sh` does:
1. Installs packages from `homebrew/Brewfile` if `brew` is available.
2. Backs up existing non-symlink configs (`~/.zshrc`, `~/.config/starship.toml`, `~/.config/git/*`, `~/.config/nvim/*`) to `*.bak`.
3. Symlinks `zsh`, `starship`, `nvim`, and `git` into `$HOME` using `stow`.
4. Creates `~/.zshrc.local` and `~/.gitconfig.local` if missing.

### Linux Prerequisites

On Linux, install the equivalent packages with your distro's package manager (`zsh`, `stow`, `starship`, `neovim`, `git`, `git-delta`, `fzf`, `fd`, `ripgrep`, `eza`, `bat`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, and a Nerd Font), then run `./install.sh`.

## Highlights

- **Zsh** (`zsh/.zshrc`):
  - Shared history (`HISTSIZE=10000`), Docker CLI completions, Cargo/Rust & NVM initialization.
  - Cross-platform plugin loading for `zsh-autosuggestions` and `zsh-syntax-highlighting` (macOS Homebrew & Linux `/usr/share/zsh*`).
  - Automatic integrations for `fzf`, `eza` (`ls`, `ll`), and `bat` / `batcat` (`cat`) when installed.
- **Starship** (`starship/.config/starship.toml`):
  - `gruvbox_dark` palette (with `gruvbox_light` and `default` also defined).
  - Optional cockpit modules toggled via environment variables in `~/.zshrc.local`:
    - `STARSHIP_COCKPIT_MEMORY_USAGE_ENABLED=true`
    - `STARSHIP_COCKPIT_BATTERY_ENABLED=true` (and `STARSHIP_COCKPIT_BATTERY_THRESHOLD`)
    - `STARSHIP_COCKPIT_KEYBOARD_LAYOUT_ENABLED=true` (supports macOS, KDE Plasma via `gdbus`, GNOME via `gsettings`, Sway, Hyprland, `fcitx5`, `ibus`, and X11 tools)
    - Layout alias overrides, e.g. `STARSHIP_COCKPIT_KEYBOARD_LAYOUT_US=ENG`
- **Git** (`git/.config/git/config`):
  - `nvim` as default editor, `main` as default branch, and `delta` (`gruvbox-dark`, side-by-side) as pager.
- **Neovim** (`nvim/.config/nvim/`):
  - Modular `lazy.nvim` setup with `gruvbox.nvim`, `treesitter`, `fzf-lua`, `mason` + LSP, `blink.cmp`, `conform.nvim`, `gitsigns`, `neo-tree`, and `toggleterm`. See [nvim/README.md](nvim/.config/nvim/README.md) for keymaps and details.

## Local Overrides

Machine-specific settings and credentials belong in untracked local files:
- `~/.zshrc.local` — sourced at the end of `.zshrc`
- `~/.gitconfig.local` — included at the top of `.config/git/config` (e.g., `[user]` name & email)
