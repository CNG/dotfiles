# could also use systemd service, see
# https://wiki.archlinux.org/index.php/SSH_keys#Keychain
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  ssh-agent > ~/.ssh-agent-thing
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
  eval "$(<~/.ssh-agent-thing)" 1> /dev/null
fi

# SSHFS services need the current agent socket in the systemd user manager.
# Import it when the socket changes, but wait to start the mounts until ssh-add
# has loaded a key. The existence check keeps this laptop-only.
if [[ -f "$HOME/.config/systemd/user/mnt-minerva.service" &&
      -n "$SSH_AUTH_SOCK" ]] &&
  ! systemctl --user show-environment | grep -Fqx "SSH_AUTH_SOCK=$SSH_AUTH_SOCK"; then
  if ! systemctl --user import-environment SSH_AUTH_SOCK SSH_AGENT_PID; then
    print -u2 "Could not import SSH agent environment into the systemd user manager"
  fi
fi

ssh-add() {
  command ssh-add "$@"
  local ssh_add_status=$?
  (( ssh_add_status == 0 )) || return $ssh_add_status

  if [[ ! -f "$HOME/.config/systemd/user/mnt-minerva.service" ||
        -z "$SSH_AUTH_SOCK" ]] ||
    ! command ssh-add -l >/dev/null 2>&1; then
    return 0
  fi

  if ! systemctl --user import-environment SSH_AUTH_SOCK SSH_AGENT_PID; then
    print -u2 "Could not import SSH agent environment into the systemd user manager"
    return 1
  fi

  if ! systemctl --user start \
    mnt-cameras.service \
    mnt-data.service \
    mnt-minerva.service; then
    print -u2 "Could not start SSHFS mount services"
    return 1
  fi
}
