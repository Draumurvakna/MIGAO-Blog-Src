---
categories:
- Note
date:
- 2024-05-24 10:36:50
tags:
- window-manager
- linux
- shell
- hyprland
- wayland
title: Copy-Paste in Hyprland across Wayland & XWayland
toc: true

---
After a certain upgrade of hyprland, I can no longer copy&paste across Wayland & XWayland apps, which is very annoying.
The relatied issue: https://github.com/hyprwm/Hyprland/issues/6132
Maybe fixed in: https://github.com/hyprwm/Hyprland/pull/6086

According to 6132 issue, some provide a walk around. I tailored it to adapt it to my system.

Create a shell in `~` directory, named `clipsync.sh`
```shell
#!/usr/bin/env sh
# Two-way clipboard syncronization between Wayland and X11.
# Requires: wl-clipboard, xclip, clipnotify.
#
# Usage:
#   clipsync.sh watch - run in background.
#   clipsync.sh kill - kill all background processes.
#   echo -n any | clipsync.sh insert - insert clipboard content fron stdin.
#
# Workaround for issue:
# "Clipboard synchronization between wayland and xwayland clients broken"
# https://github.com/hyprwm/Hyprland/issues/6132

# Updates clipboard content of both Wayland and X11 if current clipboard content differs.
# Usage: echo -e "1\n2" | clipsync insert
insert() {
  # Read all the piped input into variable.
  value=$(cat)
  wValue="$(wl-paste)"
  xValue="$(xclip -o -selection clipboard)"

  notify() {
    notify-send -u low -c clipboard "$1" "$value"
  }

  if [ "$value" != "$wValue" ]; then
    notify "Wayland"
    echo -n "$value" | wl-copy
  fi

  if [ "$value" != "$xValue" ]; then
    notify "X11"
    echo -n "$value" | xclip -selection clipboard
  fi
}

watch() {
  # Wayland -> X11
  wl-paste --type text --watch "/home/cyl/clipsync.sh" insert &

  # X11 -> Wayland
  while clipnotify; do
    xclip -o -selection clipboard | ~/clipsync.sh insert
  done &
}

kill() {
  pkill wl-paste
  pkill clipnotify
  pkill xclip
  pkill clipsync
}

"$@"
```

alias in `~/.zshrc`:
```
alias clipsync="~/clipsync.sh"
```


enable it by running
```bash
clipsync watch
```

kill all by running
```bash
clipsync kill
```

Self-start, configured in `~/.config/hyprland/hyprland.conf`
```
exec-once = clipsync watch
```

***REMEMBER TO REMOVE ALL THESE STUFF WHEN HYPRLAND HAS FIXED THE ISSUE***

***Solved in ISSUE 6086***
