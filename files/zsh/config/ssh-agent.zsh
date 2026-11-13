# could also use systemd service, see
# https://wiki.archlinux.org/index.php/SSH_keys#Keychain
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  ssh-agent > ~/.ssh-agent-thing
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
  eval "$(<~/.ssh-agent-thing)" 1> /dev/null
fi

_start_sshfs_mounts() {
  if [[ ! -f "$HOME/.config/systemd/user/mnt-minerva.service" ||
        -z "${SSH_AUTH_SOCK:-}" ]] ||
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

ssh-add() {
  command ssh-add "$@"
  local ssh_add_status=$?
  (( ssh_add_status == 0 )) || return $ssh_add_status

  _start_sshfs_mounts
}

_start_sshfs_mounts
