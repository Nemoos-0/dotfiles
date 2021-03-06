# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/nemoos/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

source <(antibody init)
antibody bundle < ~/.zsh_plugins.txt

eval "$(starship init zsh)"

export VISUAL="nvim"
export EDITOR="nvim"

alias tn="tmux new"
alias ta="tmux a"
alias tl="tmux ls"
alias tk="tmux kill-session"

alias ls="ls --color"
alias ll="ls -la --color"
alias l.="ls -d .* --color"

alias v="nvim"
alias lg="lazygit"

alias s=". ranger"
alias jl="jupyter-lab"
