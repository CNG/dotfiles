#!/bin/bash
## {{ ansible_managed }}

## -- This script will imitate Gnome's Media Controls (Play/Pause, Next, Previous, Stop) -- ##
## -- It will assume you are using a media application that is compatible with MPRIS or  -- ##
## -- "Media Player Remote Interfacing Specification"                                    -- ##

# From https://www.kubuntuforums.net/showthread.php/58197-How-To-Get-Global-Media-Shortcuts-in-KDE

# Gather running media applications
apps=(`qdbus | grep org.mpris.MediaPlayer2 | sed 's/.*\.//'`)

# Send "{{ item }}" command to each application
for app in "${apps[@]}"; do
  qdbus "org.mpris.MediaPlayer2.$app" /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.{{ item }}
done
