---
aliases:
- Add remote repository
date:
- 2023-05-09 21:58:07
tags:
- git
- repository
title: Repository
toc: true

---

<!--toc:start-->
- [Add remote repository](#add-remote-repository)
- [Branch](#branch)
<!--toc:end-->

## Add remote repository
```git
git remote add origin git@github.com:...
```
`origin` is the name of the repository 
Check remote repository settings:
```git
git remote -v
```
Before push to remote repository, make sure the branch name is the same.

## Branch
find all the branch
```git
git branch -a
```
find all the branch on remote repository
```git
git remote -r 
```
Rename
```git
git branch -m oldBranchName newBranchName
```
Move to branch:
```git
git checkout [branchname/SHA-1]
```

