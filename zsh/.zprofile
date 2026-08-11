eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(pyenv init --path)"
alias uuid="uuidgen | tr -d '\n' | tr '[:upper:]' '[:lower:]' | pbcopy"
export PATH=/Users/dorianr/.zpm/bin:$PATH

# Setting PATH for Python 3.13
# The original version is saved in .zprofile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.13/bin:${PATH}"
export PATH

# Local secrets, untracked. Claude Code expands the ${DD_*} placeholders in
# claude/settings.json from the shell env, so these must be exported here.
[ -f ~/.zsh_secrets ] && source ~/.zsh_secrets
