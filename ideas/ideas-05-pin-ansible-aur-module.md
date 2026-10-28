# Idea 5: Make the Ansible AUR dependency reproducible

This note expands idea 5 from [ideas.md](./ideas.md). It focuses on making
first-time provisioning stable without treating an unreviewed download as a
trusted dependency.

## What the repository does today

`provision` downloads `plugins/modules/aur.py` from the AUR module project's
`master` branch into the user's Ansible plugin directory if the file is
missing. That branch can change independently of this repository, and the
download has no pinned revision or integrity check. `ansible.cfg` is also
part of the project and should be checked for how local plugin discovery is
configured.

## Recommendation

Pin a reviewed upstream release or commit and fetch it through an Ansible
collection or another declared dependency mechanism. Prefer a versioned,
auditable dependency that Ansible can install reproducibly; if vendoring is
chosen, preserve upstream licensing and update instructions. Fail visibly
when the dependency cannot be installed rather than silently continuing.

## Proposed changes

1. Select the supported Ansible version and AUR integration strategy.
2. Replace the raw `master` URL with a tagged collection/version or exact
   reviewed commit; record the source and update process.
3. Configure plugin/collection search paths explicitly and remove the
   one-off file download from `provision`.
4. Add a dependency bootstrap check with an actionable error if the required
   plugin is absent.
5. Test a clean bootstrap with no user plugin directory and a repeat run
   where the pinned dependency is already installed.

## Current references

- [Ansible collections installation](https://docs.ansible.com/ansible/latest/collections_guide/collections_installing.html)
  describes installing collections and pinning versions.
- [Ansible configuration: plugin paths](https://docs.ansible.com/ansible/latest/reference_appendices/config.html)
  documents plugin search-path configuration.
- [kewlfft/ansible-aur](https://github.com/kewlfft/ansible-aur) is the
  upstream project; check its current supported installation method before
  migrating.
