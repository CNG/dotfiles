# Idea 15: Make dotfiles bootstrapping use one source setting

This note expands idea 15 from [ideas.md](./ideas.md). It covers the first
provision run as well as safe repeat behavior for an existing checkout.

## What the repository does today

`group_vars/all.yml` sets `dotfiles.git_url`, while the dotfiles role's clone
task is conditional on `dotfiles.url`. The README currently tells the user to
copy the repository before running `provision`. The clone task also uses
`update: no`, so it intentionally does not pull changes on later playbook
runs.

The variable mismatch and manual prerequisite make the intended bootstrap
behavior unclear. Automatic updates would be a separate policy decision from
cloning a missing checkout.

## Recommendation

Use one variable name consistently and clone only when the configured
destination does not already contain the repository. Preserve an existing
checkout by default; do not unexpectedly overwrite local work or update it
during system provisioning. Keep private files and credentials outside the
public repository.

## Proposed changes

1. Align the condition and repository URL with `dotfiles.git_url`.
2. Make destination ownership, parent directory creation, and checkout state
   explicit.
3. Decide whether an existing checkout is never updated or updated only with
   an explicit option; do not silently reset local changes.
4. Update the install README so users know whether copying the repo remains
   necessary.
5. Test absent checkout, existing clean checkout, locally modified checkout,
   missing URL, and rerun idempotency.

## Current references

- [Ansible `git` module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/git_module.html)
  documents clone and update behavior.
- [Ansible `file` module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/file_module.html)
  documents directory ownership and modes.
- [rcm](https://github.com/thoughtbot/rcm) documents the dotfile management
  workflow used by this repository.
