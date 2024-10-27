---
aliases:
- check commit history
date:
- 2023-05-09 21:58:07
tags:
- git
- version-management
title: Version
toc: true

---

<!--toc:start-->
- [check commit history](#check-commit-history)
- [change version](#change-version)
- [switch to latest](#switch-to-latest)
- [need a early version of a repository](#need-a-early-version-of-a-repository)
  - [Fork the latest repository on Github](#fork-the-latest-repository-on-github)
  - [clone the forked repository](#clone-the-forked-repository)
  - [change the version locally and push](#change-the-version-locally-and-push)
<!--toc:end-->

## check commit history

```bash
git log
git log --pretty=oneline
```
```vi
commit 0637340f4d8d288a8d24dd5193855c9e5def776d (HEAD -> main, origin/main, origin/HEAD)
Author: Chen-Yulin <chenyulin@sjtu.edu.cn>
Date:   Tue Mar 21 20:55:16 2023 +0800

    modify obsidian dir

commit dde357abf53f26972bd3ad0e1b1e840412b26fc7
Author: Chen-Yulin <chenyulin@sjtu.edu.cn>
Date:   Tue Mar 21 20:54:57 2023 +0800

    modify obsidian dir

commit 089578f74d206c7fbb503a293d34edf878dad3f3
Author: Chen-Yulin <chenyulin@sjtu.edu.cn>
Date:   Tue Mar 21 20:34:09 2023 +0800

    fix plugin compatibility

commit b62c94796b757851a5e8f38925f28b160a8bf4f0
Author: Chen-Yulin <chenyulin@sjtu.edu.cn>
Date:   Tue Mar 21 14:59:02 2023 +0800
```

## change version 
```bash
git reset --hard [version hash]
```
## switch to latest
```bash
git pull
```
or locally
```bash
git checkout master
```

## need a early version of a repository
### Fork the latest repository on Github
### clone the forked repository
```bash
git clone ...
```
### change the version locally and push
```bash
git log
...
git reset --hard [version hash]
git push --force
```
