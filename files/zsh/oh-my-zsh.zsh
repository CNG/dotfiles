# Path to your oh-my-zsh configuration.
ZSH=/usr/share/oh-my-zsh/
ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

ZSH_THEME="powerlevel10k/powerlevel10k"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

zstyle ':omz:update' mode disabled  # disable automatic updates

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(${plugins:-} history-search-multi-word)

source $ZSH/oh-my-zsh.sh
