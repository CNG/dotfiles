# TODO: Check if this is used or interferes with work

# could also use systemd service, see
# https://wiki.archlinux.org/index.php/SSH_keys#Keychain
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  ssh-agent > ~/.ssh-agent-thing
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
  eval "$(<~/.ssh-agent-thing)" 1> /dev/null
fi
