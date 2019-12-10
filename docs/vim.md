# Vim things I always forget

Fold: `zc` and `zo`, open all `zR`

Navigate folds: `zj` and `zk`, `[z` and `]z`

Comment out:

* lines: V, `gc`
* current line `gcc`
* adjacent lines `gcgc`
* paragraph `gcap`

Define per-file-type settings in `~/.vim/ftplugin/{filetype}.vim`.

Increment or decrement numbers: `<C-A>` or `<C-X>`

Set date under cursor to current time: `d<C-A>` or `d<C-X>` for UTC

Tag sidebar: \<F8\>

* `p`: jump to definition but stay in sidebar

Surround:

* delete delimiters: `ds"`
* change delimiters: `cs'<p>`, `cst'`, `cs'"`, etc.
* wrap line: `yssb` or `yss)`
* wrap lines: V, `S<p class="important">`

Fugitive, Git wrapper

* `:G` or `:Gstatus`
* `:Gdiffsplit` compare staged with working tree.
* `:Gcommit`
* https://vimawesome.com/plugin/fugitive-vim

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

