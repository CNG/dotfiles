# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Look in ~/.oh-my-zsh/themes/. Optionally, if
# you set this to "random", it'll load a random theme each time oh-my-zsh loads.
#if [[ -z ${ZSH_THEME+x} ]]; then
#ZSH_THEME="robbyrussell"
#fi
ZSH_THEME="powerlevel9k/powerlevel9k"
#ZSH_THEME="powerlevel9k"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

DISABLE_UPDATE_PROMPT=true

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(${plugins:-} encode64 wd command-not-found perms history-search-multi-word)
plugins=(${plugins:-} perl pylint python screen sublime urltools)

plugins=(${plugins:-} docker gradle pass pep8 pip sudo systemd vagrant virtualenvwrapper web-search)

source $ZSH/oh-my-zsh.sh
