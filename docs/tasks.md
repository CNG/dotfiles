I'm still deciding if I want to use this time and task tracking system. Notes
for now. This setup is a bit weird.

`~/.zsh/config/taskwarrior.zsh` sets two environment variables:

* `TASKRC`: Points to `~/.config/taskrc`, which is linked to these dotfiles.
* `TIMEWARRIORDB`: Points to my Google Drive `Tracking/time` folder.

`taskrc` points `data.location` to my Google Drive `Tracking/tasks` folder. Note this CAN use `~` shell metacharacter but apparently cannot use `$HOME` or my own environment variables I thought I was using previously here.

    $ cp -a $(pacman -Ql timew | grep on-modify | cut -d' ' -f2) ~/GDrive/Main/Tracking/tasks/hooks
    $ chmod +x ~/GDrive/Main/Tracking/tasks/hooks/on-modify.timewarrior
    $ cp -a $(pacman -Ql timew | grep totals.py | cut -d' ' -f2) ~/GDrive/Main/Tracking/time/extensions
    $ chmod +x ~/GDrive/Main/Tracking/time/extensions/totals.py

I also previously threw a function at `files/zsh/config/functions/task`, but I have now removed it since I started also using TimeWarrior:

    echo -e "$(date --utc '+%Y-%m-%d %H:%M:%S')\t$@" | tee -a $HOME/GDrive/Main/Tracking/timetracking.txt

# TaskWarrior

Documenting a few basic commands here, eventually hoping to have as my personal
cheatsheet. See official [usage examples][ex].

`task add DESC [options]`, `task ID modify [options]`

* `due:eom`, `due:28th`
* `recur:monthly`, `recur:monthly until:now+1yr`
* tags: `+TAGNAME`
* `project:PROJECTNAME`

* `task +WEEK` virtual tag filtering on this week, [others too](https://taskwarrior.org/docs/tags.html).

`log` is the ѕame as the `add` command except the task is added in the completed
state.

Delete all tasks with name: `task "Organize files" delete`


[ex]: https://taskwarrior.org/docs/examples.html


# TimeWarrior

[Documentation](https://timewarrior.net/docs/)

* `timew`: check status
* `timew start` and `timew stop` and `timew continue`
* `timew start "multiword tag" "singletag"`
* `timew track 9:00 - 11:00 "Outline the tutorial topics"`
* `timew track 9am to 11am "Outline the tutorial topics"`
* `timew track 9am for 2h "Outline the tutorial topics"`


* `timew summary :ids` includes ID column for easy correction (1 is newest, so
  may need to refresh if you reorder with changes).
* `timew move @ID_NUM 8:30am`
* `timew move @ID_NUM 10am :fill` moves and fills the interval.
* `timew split @2` splits evenly into two.
* `timew join @2 @3`
* `timew tag @2 @3 tag`
* `timew untag @2 @3 tag`

* Also `shorten`, `lengthen`, `cancel`, `delete`

* Extensions in `/extensions` become commands like: `timew monday for 7d totals`

* `timew tags`: show used tags
* `timew help continue` etc.
* `timew help date` show date formats



# TODO

[taskw\_gcal\_sync](https://github.com/bergercookie/taskw_gcal_sync) syncs tasks
but not Timewarrior, so probably not as useful as I'd hope.

