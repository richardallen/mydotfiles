# TODO: This is specific to macOS

# The OSX way for ls colors.
export CLICOLOR=1

#export LSCOLORS='gxfxcxdxbxegedabagacad'
#export LSCOLORS='exfxfeaeBxxehehbadacea'

# TODO: From Prezto utility. Test to see which is better.
export LSCOLORS='exfxcxdxbxGxDxabagacad'
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'

export ZSH_DIRCOLORS="$HOME/.iterm/themes/dircolors.256dark"

eval "$(gdircolors -b ${ZSH_DIRCOLORS})"

export GREP_COLOR='1;33' # From YADR
#export GREP_COLOR='37;45'           # BSD. From Prezto
export GREP_COLORS="mt=$GREP_COLOR" # GNU.
