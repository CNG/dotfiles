# Normally when using Oh-My-Zsh you could use these variables:
# Automatically start tmux
# ZSH_TMUX_AUTOSTART=true
# Set term to screen or screen-256color based on current terminal support
# ZSH_TMUX_FIXTERM=false  # disabling because not sure I need

# Since I start Tmux w/ SystemD, ZSH_TMUX_AUTOSTART resulted in Tmux getting
# started inside the existing Tmux somehow. Without ZSH_TMUX_AUTOSTART, I
# need the following to connect to the existing Tmux, as if I were not
# using Oh-My-Zsh's Tmux plugin (begs the question: Am I? Should I not be?).

# Using $PS1 to check for interactive shell
# https://www.gnu.org/software/bash/manual/html_node/Is-this-Shell-Interactive_003f.html
# Expected state of $TERM environment variable "for all programs running inside tmux"
# http://man7.org/linux/man-pages/man1/tmux.1.html#WINDOWS_AND_PANES
# https://unix.stackexchange.com/a/113768/39419
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]]; then
  if [ -z "$TMUX" ]; then
    if pgrep -f "tmux attach"; then
      exec tmux new
    elif pgrep tmux; then
      exec tmux attach
    else
      exec tmux
    fi
  else
    # not convinced this works the same way with the exec above,
    # and not sure i ever needed this anyway
    # while [ -z "$TMUX" ]; do
    #  tmux attach || break
    # done
  fi
fi

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
