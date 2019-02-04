export EDITOR=vim
export TERMINAL=alacritty
export VISUAL=vim
# one screen exit
export LESS="-RFX"

export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

export HISTFILE=~/.zsh_history
export HISTSIZE=10000000
export SAVEHIST=10000000

setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt HIST_VERIFY # show command with history expansion to user before running it
setopt EXTENDED_HISTORY # add timestamps to history
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD
#setopt IGNORE_EOF # CTRL+D won't exit shell
#setopt IGNORE_EOF=2 # CTRL+D twice to exit shell

# These three options should be considered mutually exclusive:
#setopt INC_APPEND_HISTORY  # adds history incrementally in order of execution
setopt INC_APPEND_HISTORY_TIME # history written after command finished so time is recorded correctly in EXTENDED_HISTORY format
#setopt SHARE_HISTORY # share history between sessions

# I think APPEND_HISTORY is also redundant if INC_APPEND_HISTORY is set.
# setopt APPEND_HISTORY # adds history rather than replaces it

setopt NO_HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt NO_HIST_IGNORE_SPACE # ignore commands that start with space
setopt NO_HIST_IGNORE_DUPS # don't record in history if duplicate of previous event
setopt NO_HIST_REDUCE_BLANKS
setopt NO_SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST # delete duplicates first when HISTFILE size exceeds HISTSIZE

# don't expand aliases _before_ completion has finished
#   like: git comm-[tab]
setopt complete_aliases

bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[5D' beginning-of-line
bindkey '^[[5C' end-of-line
bindkey '^[[3~' delete-char
bindkey '^?' backward-delete-char

# Vi mode: mode switch delay: .1sec instead of .4
# export KEYTIMEOUT=1
