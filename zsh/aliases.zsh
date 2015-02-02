# My massive alias file. Viewer beware.
# Todo.txt aliases.
alias t="todo.sh"
alias ta="t add"
alias tl="t ls"

# Environment aliases.
alias ea="vim ~/dotfiles/zsh/aliases.zsh"
function aa {
    echo "alias $1='$2'" >> ~/dotfiles/zsh/aliases.zsh
    source ~/.zshrc
}
alias ei3="vim ~/dotfiles/i3/config"
alias reload="source ~/.zshrc"

# Ease of use aliases.
alias ping="ping -c 3"
alias ls="ls --color -xX"
alias eclimd="/usr/share/eclipse/eclimd &"
alias v="f -e vim"

## Make this a function. Wheeeee!
alias pomo="sleep 25m && printf '\apomodoro done!\n'"

# Git flow aliases
alias gnb="git checkout -b "

# usage: ghclone laserswald todoc
ghclone(){
    git clone http://github.com/$1/$2.git
}

# Script-added aliases. These should be sorted around.
alias gco='git checkout '
