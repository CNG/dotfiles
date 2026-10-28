# Idea 14: Add automated checks for configuration changes

This note expands idea 14 from [ideas.md](./ideas.md). Checks should catch
static errors before provisioning, while clearly distinguishing what requires
a real machine or live Sway session.

## What the repository does today

The project has Bash install/provision scripts, Ansible roles, and Sway
configuration, but no visible automated validation workflow in the root
structure. Errors can therefore be discovered only during an install or
session startup. Some checks require tools not currently installed on every
developer machine.

## Recommendation

Start with a small local validation script and optionally run the same checks
in CI. Use ShellCheck and Bash syntax checks, Ansible syntax/lint checks, and
Sway's configuration validation. Do not make networked full provisioning a
CI job; test role behavior with controlled fixtures or a disposable VM.

## Proposed changes

1. Add a script that checks tracked Bash scripts with `bash -n` and
   ShellCheck.
2. Run `ansible-playbook --syntax-check` against the playbook using a minimal
   inventory; add ansible-lint only after documenting exceptions.
3. Validate Sway syntax with the supported check-only flag and a test config
   that handles missing runtime environment where necessary.
4. Add JSON/YAML/TOML validation for active configuration formats.
5. Provide clear output and non-zero status on errors; document optional
   tool installation and checks that need an installed system.
6. Exercise the checker on an intentional syntax error to ensure failures are
   surfaced rather than swallowed.

## Current references

- [ShellCheck](https://www.shellcheck.net/) is a static analyzer for shell
  scripts.
- [Ansible playbook syntax check](https://docs.ansible.com/ansible/latest/cli/ansible-playbook.html)
  documents `--syntax-check`.
- [ansible-lint](https://ansible.readthedocs.io/projects/lint/) documents
  Ansible best-practice checks.
- [Sway(1)](https://man.archlinux.org/man/sway.1.en) documents validation
  options; verify the installed version's CLI syntax.
