#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -al'
alias wall='feh --bg-fill --randomize ~/dotfiles/wallpapers/*'
alias eb='exec bash'
PS1='[\u@\h \W]\$ '

# oh my posh theme
eval "$(oh-my-posh init bash --config ~/.poshthemes/zash.omp.json)"
