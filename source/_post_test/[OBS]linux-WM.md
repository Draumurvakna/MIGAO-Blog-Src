---
aliases:
- Awesome
date:
- 2023-05-09 21:58:07
tags:
- linux
- window-manager
- beautify
title: WM
toc: true

---

# Related software

- Awesome wm
- compfy (picom with animation, no longer maintained)
- polybar with polybar-theme (need many requirements i.e. rofi)
- wezterm

# Awesome
[github](https://github.com/awesomeWM/awesome)
[config](https://github.com/worron/awesome-config)
config directory:`~/.config/awesome/`
[doc](https://awesomewm.org/apidoc/documentation/07-my-first-awesome.md.html)

[youtube](https://www.youtube.com/watch?v=JONiwmvi3q0)

## Execute commands on spawn
in the config file `rc.lua`
```lua
awful.spawn("picom --experimental-backend")
awful.spawn("polybar")
awful.spawn.with_shell("xxx.sh")
```


