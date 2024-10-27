---
aliases:
- What is a Git submodule?
date:
- 2023-05-09 21:58:07
tags:
- git
- submodule
title: submodule
toc: true

---

## What is a Git submodule?
A Git submodule allows a user to include a Git repository as a subdirectory of another Git repository. This can be useful when a project needs to include and use another project. For example, it may be a third-party library or a library developed independently for use in multiple parent projects. With submodules, these libraries can be managed as independent projects while being used in the user's project. This allows for better organization and management of the code.

## How to add a submodule to a project
To add an existing Git repository as a submodule to a project, the `git submodule add` command can be used. The command format is `git submodule add <url> <path>`, where `<url>` is the URL of the submodule repository and `<path>` is the storage path of the submodule in the project. For example, if a user wants to add the remote repository `https://github.com/username/repo.git` as a submodule to their project and store it in the `my-submodule` directory, they can use the following command:
```git
git submodule add https://github.com/username/repo.git my-submodule
```

This will successfully add a submodule named `my-submodule` to the user's project.


