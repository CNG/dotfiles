# space expands glob expressions, subcommands and aliases
typeset -a noexpand
noexpand=(ls less cat git)
globalias() {
  if [[ $LBUFFER =~ " \$" ]]; then
    unset 'functions[_expand-aliases]'
    functions[_expand-aliases]=$BUFFER
    (($+functions[_expand-aliases])) &&
      BUFFER=${functions[_expand-aliases]#$'\t'} &&
      CURSOR=$#BUFFER
  elif [[ ! $LBUFFER =~ "\<(${(j:|:)noexpand})\$" ]]; then
    zle _expand_alias
    zle expand-word
    # otherwise I get a ^@, not sure why
    # zle backward-delete-char
  fi
  zle self-insert
}
zle -N globalias
# normal space during searches
bindkey -M isearch " " magic-space
# space expands all aliases, including global
bindkey -M emacs " " globalias
bindkey -M viins " " globalias
# control-space to make a normal space
bindkey -M emacs "^ " magic-space
bindkey -M viins "^ " magic-space

# do the expansions even on return, before running command
globaliasaccept() {
  if [[ ! $LBUFFER =~ " \$" ]]; then
    zle globalias
    zle backward-delete-char
  fi
  zle accept-line
}
zle -N globaliasaccept
bindkey -M emacs "^M" globaliasaccept
bindkey -M viins "^M" globaliasaccept
