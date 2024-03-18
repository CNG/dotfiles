alias br=". ~/.zshenv; . ~/.zshrc"
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"

# http://unix.stackexchange.com/a/18092/39419
bashman () { man bash | less -p "^       $1 "; }
zshman () { man zshbuiltins | less -p "^       $1 "; }
