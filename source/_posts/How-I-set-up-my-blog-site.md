---
title: How I set up my blog site
date: 2022-04-11 22:07:33
tags:
- Github
- Hexo
- Javascript
- HTML
- Web
categories:
- Note
cover: /gallery/hexo.png
thumbnail: /thumb/hexo.png
---
This post record the steps I set up this blog site.

# Catalog

<!-- vim-markdown-toc Marked -->

* [Env preparation](#env-preparation)
* [Github](#github)
    * [Connection](#connection)
    * [Setup Github Pages repository](#setup-github-pages-repository)
* [Install Hexo](#install-hexo)
* [Deploy to Github server](#deploy-to-github-server)

<!-- vim-markdown-toc -->

## Env preparation
Installation
- Install [Node.js](https://nodejs.org/zh-cn/)
- Install Git

Use following command to confirm:
```bash
$ node -v
$ npm -v
$ git --version
```

## Github
### Connection
Create and copy SSH key:
```bash
$ ssh-keygen -t rsa -C "GitHub email"
$ cd ~/.ssh
$ vim id_rsa.pub
```
Copy the contents

Go to Github -> Settings and Add SSH key

Confirm the connection:
```bash
$ ssh -T git@github.com
```

### Setup Github Pages repository
Create Username.github.io(your URL)

## Install Hexo

```bash
$ npm install -g hexo-cli
```

Setup a local workspace:
```bash
$ git init
$ hexo init
$ npm install
```

launch local server:
```bash
$ hexo cl
$ hexo g
$ hexo s
```
or use following command to specify port:
```bash
$ hexo server -p 5000
```
visit http://localhost:4000

## Deploy to Github server

Install hexo-developer-git:
```bash
$ npm install hexo-deployer-git --save
```

edit \_config file's _Deployment_ part:
```editor
deploy:
  type: git
  repository: git@github.com:Chen-Yulin/Chen-Yulin.github.io.git
  branch: master
```

then run in bash:
```bash
$ hexo d
```
