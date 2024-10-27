---
categories:
- Note
date:
- 2024-10-17 09:05:54
tags:
- hyprland
- linux
- waybar
- shell
- Script
- plugin
title: Hyprland Scroll Mode + Waybar
toc: true

---
## Objective 
I use a hyprland plugin called `hyprscroller` to emulate the scroll functionality of `PaperWM`.
However, I can't get whether I am in `row mode` or `column mode`, so I want to show the mode status on my `waybar`.

Related issue: https://github.com/dawsers/hyprscroller/issues/57

## Implementation
I wrote two shell script under `~/.config/waybar/`
- `scroller_mode_listener.sh`, responsible for listening the IPC message of `hyprscroller` and store that information in a tmp file. This script can be executed in hyprland config file using `exec-once`
```bash
#!/bin/bash

MODE_FILE="/tmp/hyprland_scroller_mode"

function handle {
  if [[ ${1:0:8} == "scroller" ]]; then
    if [[ ${1:10:9} == "mode, row" ]]; then
        echo "Row" > "$MODE_FILE"
    elif [[ ${1:10:12} == "mode, column" ]]; then
        echo "Column" > "$MODE_FILE"
    #else
        #echo "" > "$MODE_FILE"
    fi
    hyprctl dispatch submap reset && pkill -SIGRTMIN+8 waybar # update the widget on waybar
  fi
}

# Initialize the mode file
echo "" > "$MODE_FILE"

socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done
```
- `scroller_mode_reader.sh`, responsible for reading the tmp file and return the `json` value to waybar to change the shown icon.
```bash
#!/bin/bash

MODE_FILE="/tmp/hyprland_scroller_mode"

current_mode=$(cat "$MODE_FILE")

if [[ "$current_mode" == "Row" ]]; then
    icon="Row"
    percent=0
    class="mode-row"
elif [[ "$current_mode" == "Column" ]]; then
    icon="Column"
    percent=100
    class="mode-column"
else
    icon="Row"
    percent=0
    class=""
fi

echo "{\"text\":\"$icon\", \"tooltip\":\"Scroller Mode: $current_mode\", \"class\":\"$class\",\"percentage\": $percent}"
```

Then add the custom module to waybar in config file (we use signal to update the module):
```json
    "custom/scroller-mode": {
        "exec": "~/.config/waybar/scroller_mode_reader.sh",
        "return-type": "json",
        "interval": "once",
        "signal": 8,
        "on-click": "hyprctl dispatch submap reset && pkill -SIGRTMIN+8 waybar",
        "format": "{icon}",
        "format-icons": ["", ""],
    }
```

Also remember to add the module to the bar:
```json
    "modules-right": ["custom/scroller-mode", "cpu", "memory", "temperature","battery","clock","custom/power"],
```

Then everything is done

![](Pasted_image_20241017092056.png)

![](Pasted_image_20241017092323.png)