#!/usr/bin/env bash

# Copyright (C) 2020-2021 Bob Hepple <bob.hepple@gmail.com>
# https://git.xkonni.de/konni/config_sway/src/branch/main/bin/sway_move

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or (at
# your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

# http://bhepple.freeshell.org

initialise() {
    PROG=$(basename $0)
    VERSION="1.0"
    ARGUMENTS="top-right|bottom-right|bottom-left"
    USAGE="move a floating window to the edges because sway lacks a way to do it!"

    case $1 in
        -h|--help)
            echo "$USAGE"
            exit 0
            ;;
        top-left|top-center|top-right|center-left|center-center|center-right|bottom-left|bottom-center|bottom-right)
            command="$1"
            ;;
        *)
            echo "$PROG: bad argument" >&2
            exit 1
            ;;
    esac

    return 0
}

initialise "$@"
width=$( swaymsg -t get_outputs |
    jq -r '.. | select(.focused?) | .rect | .width' )
height=$( swaymsg -t get_outputs |
    jq -r '.. | select(.focused?) | .rect | .height' )
scale=$(swaymsg -t get_outputs | jq -r '.. | select(.focused?) | .scale' )
monitor_width=$(echo "${width}/$scale / 1" | bc)
monitor_height=$(echo "${height}/$scale / 1" | bc)
win_dim=( $( swaymsg -t get_tree |
    jq '.. | select(.type?) | select(.type=="floating_con") | select(.focused?)|.rect.width, .rect.height, .deco_rect.height' ) )

win_width=${win_dim[0]}
win_height=${win_dim[1]}
deco_height=${win_dim[2]}

spacing_x=5
spacing_y=35
new_x=$spacing_x
new_y=0
case $command in
  ## top
  top-center)
    new_x=$(( (monitor_width - win_width)/2 ))
    ;;
  top-right)
    new_x=$(( monitor_width - win_width - 2*spacing_x ))
    ;;
  ## center
  center-left)
    new_y=$(( (monitor_height - win_height - deco_height - spacing_y)/2 ))
    ;;
  center-center)
    new_x=$(( (monitor_width - win_width)/2 ))
    new_y=$(( (monitor_height - win_height - deco_height - spacing_y)/2 ))
    ;;
  center-right)
    new_x=$(( monitor_width - win_width -2*spacing_x ))
    new_y=$(( (monitor_height - win_height - deco_height - spacing_y)/2 ))
    ;;
  ## bottom
  bottom-left)
    new_y=$(( monitor_height - win_height - deco_height - spacing_y ))
    ;;
  bottom-center)
    new_x=$(( (monitor_width - win_width)/2 ))
    new_y=$(( monitor_height - win_height - deco_height - spacing_y ))
    ;;
  bottom-right)
    new_x=$(( monitor_width - win_width -2*spacing_x ))
    new_y=$(( monitor_height - win_height - deco_height - spacing_y ))
    ;;
esac

swaymsg "move position $new_x $new_y"
