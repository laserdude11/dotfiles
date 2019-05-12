. ~/.sh.d/environment.sh
. ~/.sh.d/retrain.sh

alias c=cd
alias ds=dirs
alias dvtm="dvtm -m ^a -M"
alias p=pushd
alias o=popd
alias h='history'
alias j='jobs -l'
alias reload=". ~/.profile"
alias rl=reload

alias l=ls
alias la="ls -a"
alias ll="ls -l"

alias edit="$EDITOR"
alias e="edit"
alias ei3="edit ~/etc/i3/.i3/config"
alias exm="edit ~/etc/xmonad/.xmonad/xmonad.hs"
alias df="edit ~/etc"
alias ea="edit ~/.sh.d/aliases.sh"

alias eclimd="/usr/lib/eclipse/eclimd &"
alias nctl="netctl"
alias p9="drawterm -c gibson.gnot.club -a gibson.gnot.club -u lazr"
alias ping="ping -c 3"
alias randw=rwall
alias refresh="sudo pacman -Syy"
alias rwall="feh --random --bg-fill ~/usr/img/wall"
alias sctl="systemctl"
alias sctll="systemctl list-units"

alias t="todo.sh -t"
alias ta="t add"
alias td="t do"
alias tl="t ls"
alias twork="tl @work -@waiting"
alias et="e $ORG_PATH/todo.txt"

alias mux="$MULTIPLEXER"
alias tm="tmux"
alias tmux="tmux -2"
alias tns="tmux new-session -s -A "
alias update="sudo pacman -Syu && notify-send 'Pacman' 'System update was successful.'"
alias wall="~/.fehbg"
alias xm="xrdb -merge ~/.xrdb.d/main"
