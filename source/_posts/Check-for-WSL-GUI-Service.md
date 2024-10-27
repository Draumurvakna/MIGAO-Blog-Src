---
title: Check for WSL GUI Service
date: 2022-05-13 18:07:43
tags:
- WSL
categories:
- Note
---
This guide is for the wslg feature of windows 11.\
Check for display:
```bash
$ echo $DISPLAY
:0
```
if not, change it with:
```bash
$ export DISPLAY=:0
```

check for X11 display socket
```bash
$ ls -la /tmp/.X11-unix
lrwxrwxrwx 1 spronovo spronovo 19 Apr 21 15:28 /tmp/.X11-unix -> /mnt/wslg/.X11-unix
```
This is setup during WSL's INIT.
If doesn't exist, re-create it to try things out:
```bash
$ sudo rm -r /tmp/.X11-unix
$ ln -s /mnt/wslg/.X11-unix /tmp/.X11-unix
```
Check whether X11 server is running:
```bash
$ ls /tmp/.X11-unix
X0
```


