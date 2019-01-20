# Vim things I always forget

## Insert mode

`^O` enter one command

## Troubleshooting

See all mappings due to plugins and config: `:map`

This gives three columns:

1. mode mapping applies to
2. keyboard shortcut
3. command

See one mapping: `:map <C-P>`

`^Q` quotes next event, so can enter `:map` then hit `^Q` and then key combo.
Actually, seems `^Q` is synonym for `^V`, and since `^Q` and `^S` are used by
the terminal for flow control, you'd need to run `stty -ixon` first to use `^Q`
with Vim.

[Unused keys](http://vim.wikia.com/wiki/Unused_keys)

