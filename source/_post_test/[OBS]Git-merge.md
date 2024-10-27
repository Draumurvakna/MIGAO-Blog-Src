---
aliases:
- Git Merge
categories:
- Note
date:
- '2023-05-09 21:58:07'
tags:
- git
title: merge
toc: true

---
# Git Merge

<!--toc:start-->
- [Git Merge](#git-merge)
  - [Solve conflict](#solve-conflict)
    - [Tools](#tools)
    - [Commands](#commands)
<!--toc:end-->

## Solve conflict

### Tools

In nvim, I use plugin [fugitive](https://github.com/tpope/vim-fugitive)

### Commands

open two vertical buffer (one form target, another from feature)
```vim
:Gvdiffsplit!
```
stay on middle and use
```vim
:diffget [buffername](local)
```
OR
go to target/feature buffer and use
```vim
:diffput [buffername](target/feature)
```
save the local file and use
```vim
:Git add .
:Git commit -m "solve merge conflicts"
```


