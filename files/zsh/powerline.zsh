# need to determine difference, but for now will clone git repo to oh-my-zsh
# plugins dir instead
#source /usr/share/zsh-theme-powerlevel9k/powerlevel9k.zsh-theme

#ZSH_THEME="powerlevel9k/powerlevel9k"

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon context dir dir_writable rbenv vcs)
# OS segment
POWERLEVEL9K_OS_ICON_BACKGROUND='black'
POWERLEVEL9K_LINUX_ICON='%F{cyan}\uf300 %F{white}arch%F{cyan}linux%f'

POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs command_execution_time history time)
DEFAULT_USER=$USER
POWERLEVEL9K_STATUS_OK=false
POWERLEVEL9K_STATUS_HIDE_SIGNAME=true
POWERLEVEL9K_PROMPT_ON_NEWLINE=false # default false
POWERLEVEL9K_DIR_SHOW_WRITABLE=false # default false
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_to_unique"
POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=3

#POWERLEVEL9K_VCS_GIT_HOOKS=(vcs-detect-changes git-untracked git-aheadbehind git-stash git-remotebranch git-tagname)
#POWERLEVEL9K_VCS_HIDE_TAGS=true
#POWERLEVEL9K_VCS_SHOW_SUBMODULE_DIRTY=false
#POWERLEVEL9K_SHOW_CHANGESET=false
#POWERLEVEL9K_HIDE_BRANCH_ICON=true


