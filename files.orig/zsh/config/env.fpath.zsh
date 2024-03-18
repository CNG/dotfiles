# Add all functions to fpath so they can add functions and completions
# and autoload contained functions

for functions_dir ($HOME/.zsh/***/functions(N)) # N exits on empty
  if [[ -d $functions_dir ]]; then
    fpath=($functions_dir $fpath)
  fi

autoload -U $HOME/.zsh/***/functions/*(N:t) # :t is like basename
