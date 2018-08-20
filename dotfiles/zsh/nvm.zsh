export NVM_DIR="$HOME/.nvm"

# Run `nvm` init script on demand to avoid constant slow downs
function nvm {
    source "$(brew --prefix nvm)/nvm.sh"
    nvm "$@"
}

# TODO: If Homebrew installed nvm becomes an issue check out https://github.com/lukechilds/zsh-nvm
