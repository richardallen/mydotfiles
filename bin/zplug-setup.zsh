#!/usr/bin/env zsh

# Location of zplug installed with Homebrew
export ZPLUG_HOME=/usr/local/opt/zplug

source ${ZPLUG_HOME}/init.zsh

# https://github.com/sorin-ionescu/prezto/tree/master/modules/environment
zplug "modules/environment", from:prezto

# https://github.com/sorin-ionescu/prezto/tree/master/modules/history
zplug "modules/history", from:prezto

# https://github.com/sorin-ionescu/prezto/tree/master/modules/terminal
zplug "modules/terminal", from:prezto

# https://github.com/sorin-ionescu/prezto/tree/master/modules/editor
zplug "modules/editor", from:prezto

# https://github.com/sorin-ionescu/prezto/tree/master/modules/completion
zplug "modules/completion", from:prezto

# https://github.com/sorin-ionescu/prezto/tree/master/modules/ssh
#zplug "modules/ssh", from:prezto

# Additional completion definitions for Zsh.
#zplug "zsh-users/zsh-completions"

# oh-my-zsh completion library
#zplug "lib/completion", from:oh-my-zsh

# Git aliases. https://github.com/robbyrussell/oh-my-zsh/wiki/Plugin:git
zplug "plugins/git", from:oh-my-zsh

# iTerm tabs automatically change colors depending on the folder you are in.
zplug "tysonwolker/iterm-tab-colors"

# Search shell history with peco when pressing CTRL+R
#zplug "jimeh/zsh-peco-history"

# A zshell plugin for the "up" command, which can cd up an arbitrary number of directories
zplug "peterhurford/up.zsh"

# Async for zsh, used by pure theme
zplug "mafredri/zsh-async", from:github, defer:0

# Pretty, minimal and fast ZSH prompt
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme

# Fish-like fast/unobtrusive autosuggestions for zsh.
zplug "zsh-users/zsh-autosuggestions"

# Syntax highlighting for commands, load last
zplug "zsh-users/zsh-syntax-highlighting", from:github, defer:0

# ZSH port of Fish history search (up arrow)
zplug "zsh-users/zsh-history-substring-search", defer:1

# Local plugins
zplug "~/.zsh", from:local, defer:3

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    zplug install
fi
