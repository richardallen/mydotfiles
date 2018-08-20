# Get operating system
readonly PLATFORM="$(uname)"

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# PS
alias psa='ps aux'
alias psg='ps aux | grep '

# Show human friendly numbers and colors
alias df='df -kh'
alias du='du -kh -d 2'

# show me files matching "ls grep"
alias lsg='ll | grep'

# Colorize output and some exclusions
alias grep='grep --color=auto --exclude-dir={.git,artwork,node_modules,vendor}'

alias gmfo='git merge --ff-only'

alias screen='TERM=screen screen'

alias gz='tar -zcvf'

alias k9='kill -9'

# HTTPie aliases
alias GET='http'
alias POST='http POST'
alias HEAD='http HEAD'

# Disable correction.
alias ack='nocorrect ack'
alias cd='nocorrect cd'
alias cp='nocorrect cp'
alias gcc='nocorrect gcc'
alias gist='nocorrect gist'
alias grep='nocorrect grep'
alias ln='nocorrect ln'
alias man='nocorrect man'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias mysql='nocorrect mysql'
alias rm='nocorrect rm'

# Disable globbing.
alias bower='noglob bower'
alias fc='noglob fc'
alias find='noglob find'
alias ftp='noglob ftp'
alias history='noglob history'
alias locate='noglob locate'
alias rsync='noglob rsync'
alias scp='noglob scp'
alias sftp='noglob sftp'

if [[ "${PLATFORM}" == 'Linux' ]]; then
    alias ll='ls -Alh --color=auto'
    alias la='ls -Ah --color=auto'
    alias ls='ls --color=auto'

    alias topc='top -o %CPU'
    alias topm='top -o %MEM'
elif [[ "${PLATFORM}" == 'Darwin' ]]; then
    alias dircolors='gdircolors'
    alias ll='gls -Alh --color=auto'
    alias la='gls -Ah --color=auto'
    alias ls='gls --color=auto'

    alias vim='mvim -v'

    # Finder
    alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
    alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

    # Homebrew
    alias brewu='brew update  && brew upgrade && brew cleanup && brew prune && brew doctor'

    # This uses NValt (NotationalVelocity alt fork) - http://brettterpstra.com/project/nvalt/
    # to find the note called 'todo'
    alias todo='open nvalt://find/todo'

    alias topc='top -o cpu'
    alias topm='top -o vsize'
fi
