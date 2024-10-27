---
aliases:
- Install package
date:
- 2023-05-09 21:58:07
tags:
- linux
title: basic
toc: true

---

<!--toc:start-->
- [Install package](#install-package)
  - [For .deb](#for-deb)
  - [For .AppImage](#for-appimage)
- [Fix package](#fix-package)
- [Manage process](#manage-process)
- [Useful command](#useful-command)
  - [grep](#grep)
    - [option](#option)
    - [Example](#example)
<!--toc:end-->

# Install package
## For .deb
```bash
sudo dpkg -i *.deb
```
## For .AppImage
```bash
chmod +777 *.AppImage
./*.AppImage
```

# Fix package
```bash
sudo apt -f install
sudo apt update
sudo apt install [dependencies]
...
sudo apt install [package]
```

# Manage process
See all the process:
```bash
ps aux
```
Find the target pid
 ```bash
pgrep [partial name] 
 ```
 return the pid of the process
 kill the process
 ```bash
kill [pid]
 ```

# Useful command
## grep
Search for confirmed strings in file
```bash
grep [option] [pattern] [file]
```
### option
- -i: ignore capitalizing
- -v: inverse search
- -n: show the line num
- -f: reveral search of files in folder
- -i: only print the name od file
- -c: only print the line num

### Example
display the battery percentage
```bash
upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage
```

