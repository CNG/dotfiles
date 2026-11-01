# could also use systemd service, see
# https://wiki.archlinux.org/index.php/SSH_keys#Keychain
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  ssh-agent > ~/.ssh-agent-thing
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
  eval "$(<~/.ssh-agent-thing)" 1> /dev/null
fi

# SSHFS services need the current agent socket in the systemd user manager.
# Import it and restart the mounts when the socket changes; the existence check
# keeps this laptop-only. The services are configured in
# ansible/roles/laptop/tasks/sshfs.yml.
if [[ -f "$HOME/.config/systemd/user/mnt-minerva.service" &&
      -n "$SSH_AUTH_SOCK" ]] &&
  ! systemctl --user show-environment | grep -Fqx "SSH_AUTH_SOCK=$SSH_AUTH_SOCK"; then
  if systemctl --user import-environment SSH_AUTH_SOCK SSH_AGENT_PID; then
    systemctl --user restart \
      mnt-cameras.service \
      mnt-data.service \
      mnt-minerva.service
  else
    print -u2 "Could not import SSH agent environment into the systemd user manager"
  fi
fi
