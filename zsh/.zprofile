# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zprofile.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zprofile.pre.zsh"
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(pyenv init --path)"
alias uuid="uuidgen | tr -d '\n' | tr '[:upper:]' '[:lower:]' | pbcopy"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zprofile.post.zsh" ]] && builtin source "$HOME/.fig/shell/zprofile.post.zsh"
