# For Oh-My-Zsh
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_FIXTERM=false

# If not using Oh-My-Zsh
# if which tmux >/dev/null 2>&1; then
#   # if no session is started, start a new session
#   test -z ${TMUX} && tmux

#   # when quitting tmux, try to attach
#   while test -z ${TMUX}; do
#     tmux attach || break
#   done
# fi


# https://wiki.archlinux.org/index.php/Tmux#Correct_the_TERM_variable_according_to_terminal_type
## workaround for handling TERM variable in multiple tmux sessions properly from http://sourceforge.net/p/tmux/mailman/message/32751663/ by Nicholas Marriott
# if [[ -n ${TMUX} && -n ${commands[tmux]} ]]; then
#   case $(tmux showenv TERM 2>/dev/null) in
#     *256color) ;&
#     TERM=fbterm)
#       TERM=screen-256color ;;
#     *)
#       TERM=screen
#   esac
# fi
