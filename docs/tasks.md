I'm still deciding if I want to use this time and task tracking system. Notes
for now. This setup is a bit weird.

`~/.zsh/config/taskwarrior.zsh` sets two environment variables:

* `TASKRC`: Points to `~/.config/taskrc`, which is linked to these dotfiles.
* `TIMEWARRIORDB`: Points to my Google Drive `Tracking/time` folder.

`taskrc` points `data.location` to my Google Drive `Tracking/tasks` folder.



# TaskWarrior

Documenting a few basic commands here, eventually hoping to have as my personal
cheatsheet. See official [usage examples][ex].

`task add DESC [options]`, `task ID modify [options]`

* `due:eom`, `due:28th`
* `recur:monthly`, `recur:monthly until:now+1yr`
* tags: `+TAGNAME`
* `project:PROJECTNAME`


`log` is the ѕame as the `add` command except the task is added in the completed
state.

[ex]: https://taskwarrior.org/docs/examples.html


# TimeWarrior

[Documentation](https://timewarrior.net/docs/)


