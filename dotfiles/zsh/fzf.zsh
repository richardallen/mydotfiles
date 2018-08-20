# Command line fuzzy finder
# https://github.com/junegunn/fzf

# TODO: Run fzf install if not done already
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Setting fd as the default source for fzf
export FZF_DEFAULT_COMMAND='fd --type f'

# Apply fd for fzf with CTRL-T as well
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
