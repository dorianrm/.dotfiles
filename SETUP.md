# New Machine Setup

## 1. Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## 2. SSH keys

- Generate or copy keys to `~/.ssh/`
- Required keys: `id_ed25519_github`, `gitlab_ed25519`, `gitlab_oc_id_ed25519`, `fsfe`

## 3. Clone dotfiles

```bash
git clone git@github.com:dorianrm/.dotfiles.git ~/.dotfiles
```

## 4. Symlinks

```bash
mkdir -p ~/.config ~/.ssh ~/.aws ~/.claude

# shell / editor / tools
ln -sf ~/.dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/zsh/.zprofile ~/.zprofile
ln -sf ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf
ln -sf ~/.dotfiles/markdownlint/.markdownlint.json ~/.markdownlint.json
ln -sf ~/.dotfiles/ssh/config ~/.ssh/config
ln -sf ~/.dotfiles/skhd ~/.config/skhd
ln -sf ~/.dotfiles/yabai ~/.config/yabai

# aws
ln -sf ~/.dotfiles/aws/config ~/.aws/config

# nvim
ln -sf ~/.dotfiles/nvim ~/.config/nvim

# claude code
ln -sf ~/.dotfiles/claude/CLAUDE.md ~/.claude/CLAUDE.md
ln -sf ~/.dotfiles/claude/.mcp.json ~/.claude/.mcp.json
ln -sf ~/.dotfiles/claude/settings.json ~/.claude/settings.json
ln -sf ~/.dotfiles/claude/statusline-command.sh ~/.claude/statusline-command.sh
ln -sf ~/.dotfiles/claude/rules ~/.claude/rules
ln -sf ~/.dotfiles/claude/specs ~/.claude/specs
```

> **Note:** `settings.json` uses `${DD_API_KEY}` and `${DD_APP_KEY}` env var placeholders. Export these in a local `.env` or secrets manager before using Claude Code with Datadog tools.

## 5. oh-my-zsh + plugins

```bash
RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

## 6. Tmux Plugin Manager

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then open tmux and press `prefix + I` to install plugins.

## 7. SDKMAN

```bash
curl -s "https://get.sdkman.io" | bash
```

## 8. Git config (not tracked)

```bash
git config --global user.email "dorianr@zillowgroup.com"
git config --global user.name "Dorian Raboy-McGowan"
git config --global init.defaultBranch main
git config --global credential.helper osxkeychain
git config --global core.editor nvim
```

## 9. Ghostty

- Install Ghostty from https://ghostty.org

```bash
mkdir -p ~/Library/Application\ Support/com.mitchellh.ghostty
ln -sf ~/.dotfiles/ghostty/config ~/Library/Application\ Support/com.mitchellh.ghostty/config
```

## 10. macOS defaults

```bash
~/.dotfiles/bin/.local/scripts/key-repeat.sh
```

## 11. Restart terminal

```bash
source ~/.zshrc
```
