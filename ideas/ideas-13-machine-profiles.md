# Idea 13: Separate machine profiles from shared configuration

This note expands idea 13 from [ideas.md](./ideas.md). The aim is to make
hardware and optional features explicit without duplicating common setup.

## What the repository does today

`ansible/group_vars/all.yml` contains user identity, package lists, desktop
choice, and flags. The playbook conditions laptop and OMEN roles on product
name strings and server setup on a flag. A `dummyflag` remains in the list.
This works for the known machine set but makes inventory intent difficult to
read and can make product-name assumptions brittle.

## Recommendation

Keep stable shared defaults in `group_vars/all.yml`; create an inventory with
named hosts/groups and move differences into host/group variables. Use facts
only where automatic hardware detection is valuable and has a safe fallback.
Use explicit booleans and lists for optional capabilities rather than
placeholder flags.

## Proposed changes

1. Add a local inventory with meaningful groups such as laptop, desktop, and
   server, plus host-specific variables for hardware-dependent choices.
2. Move machine-specific package and power settings to those groups.
3. Replace `dummyflag` and unused flags with documented booleans or remove
   them.
4. Make role conditions handle missing facts safely and use explicit
   precedence rules.
5. Document how a new host is added without exposing private host data.
6. Test the playbook with each inventory group and a host with incomplete
   facts.

## Current references

- [Ansible inventory guide](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html)
  documents host/group organization.
- [Ansible variable precedence](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html)
  describes how inventory and play variables combine.
- [Ansible best practices](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_best_practices.html)
  discusses inventory structure and role reuse.
