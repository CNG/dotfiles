# Idea 11: Fix ownership as part of first-time provisioning

This note expands idea 11 from [ideas.md](./ideas.md). It proposes fixing
ownership at the task that creates a file, rather than recursively changing
the entire home directory.

## What the repository does today

The README notes root-owned home and SSH files after setup. In the dotfiles
role, several tasks correctly use `become_user`, while others rely on
ownership defaults. A recursive ownership repair task is present but
commented out with a note that the approach is clunky. SSH key permissions
are set explicitly, but the ownership flow still deserves review.

The likely cause is mixed privilege contexts during installation; the
commented recursive fix can mask the source and risks changing user-managed
files or traversing symlinks.

## Recommendation

Audit home-directory writes and assign the intended owner/group and mode at
each Ansible task. Use `become_user` for user-managed Git/config operations,
and `owner`/`group` for privileged tasks that must create paths in the home
directory. Reserve a correction task for narrowly scoped, explicitly managed
paths.

## Proposed changes

1. Inventory every task that writes into `/home/{{ user.name }}` or `.ssh`.
2. Set owner, group, and restrictive modes on directories, key files, and
   generated configuration where applicable.
3. Avoid a recursive `chown` over the full home tree; do not follow symlinks
   into external or private data.
4. Add a validation task that reports ownership/mode errors for the paths
   this playbook manages.
5. Test a fresh install and a rerun with existing user files; verify SSH keys
   remain private and no unmanaged files are rewritten.

## Current references

- [Ansible `file` module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/file_module.html)
  documents owner, group, mode, and symlink handling.
- [Ansible privilege escalation](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html)
  documents `become_user` behavior.
- [OpenSSH `ssh` manual](https://man.openbsd.org/ssh) documents strict key
  file permission requirements.
