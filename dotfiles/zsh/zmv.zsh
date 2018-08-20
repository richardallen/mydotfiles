# Load zmv for file move/rename using shell pattern matching
# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#index-zmv
autoload -U zmv
alias zmv="noglob zmv -W"
