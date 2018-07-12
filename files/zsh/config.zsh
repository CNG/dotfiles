export EDITOR=vim
export TERMINAL=alacritty
export VISUAL=vim
# one screen exit
export LESS="-RFX"

export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000

setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt HIST_VERIFY
setopt EXTENDED_HISTORY # add timestamps to history
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD
#setopt IGNORE_EOF # CTRL+D won't exit shell
#setopt IGNORE_EOF=2 # CTRL+D twice to exit shell

# These three options should be considered mutually exclusive:
#setopt INC_APPEND_HISTORY  # adds history incrementally
setopt INC_APPEND_HISTORY_TIME # history written after command finished so time is recorded correctly in EXTENDED_HISTORY format
#setopt SHARE_HISTORY # share history between sessions

# I think APPEND_HISTORY is also redundant if INC_APPEND_HISTORY is set.
# setopt APPEND_HISTORY # adds history rather than replaces it

setopt NO_HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt NO_HIST_IGNORE_SPACE
setopt NO_HIST_IGNORE_DUPS # don't record in history if duplicate of previous event
setopt NO_HIST_REDUCE_BLANKS
setopt NO_SHARE_HISTORY

# don't expand aliases _before_ completion has finished
#   like: git comm-[tab]
setopt complete_aliases

bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[5D' beginning-of-line
bindkey '^[[5C' end-of-line
bindkey '^[[3~' delete-char
bindkey '^?' backward-delete-char


# space expands glob expressions, subcommands and aliases
typeset -a noexpand
noexpand=(ls less cat)
globalias() {
  if [[ $LBUFFER =~ "\<(${(j:|:)noexpand})\$" ]]; then
    zle _expand_alias
    zle expand-word
    zle self-insert
    zle backward-delete-char # otherwise I get a ^@, not sure why
  fi
}
zle -N globalias
# normal space during searches
bindkey -M isearch " " magic-space
# space expands all aliases, including global
bindkey -M viins " " globalias
# control-space to make a normal space
bindkey -M viins "^ " magic-space
