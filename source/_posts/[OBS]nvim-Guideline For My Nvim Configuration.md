---
categories:
- Reference
cover: /gallery/nvim.png
date:
- 2024-10-09 11:56:57
tags:
- nvim
- plugin
thumbnail: /thumb/nvim.png
title: Guideline For My Nvim Configuration
toc: true

---
## For what
nvim用了两年了，插件和自己的配置真搞了不少，但是很容易出现：

> 我记得这个功能好像通过什么插件实现了来着，插件叫什么名字来着？（对着一堆名字牛头不对马嘴的插件望洋兴叹）对应的指令是啥来着？快捷键是啥来着？

> 装了若干个实现类似功能的插件。。。

> 这个插件更新了？不会用辽！

> 我当时为啥装这个插件来着？

> 我刚一不小心触发了个啥玩意儿的快捷键？

> ……

综上，决定按照功能分块梳理一下自己的插件和快捷键配置。顺带整理一下插件系统，把不要的统统删咯。

## Guide
### 页面
#### Bufferline
- 左右循环移动buffer`Ctrl+h/l`
- 选择buffer关闭`Leader+bc`

#### Ctrl+w（重新映射了一些C-W指令）
- 关闭当前分屏`sc`
- 关闭所有其他分屏`so`
- 垂直分屏`sv`
- 分屏`sh`
-  移动指针处于的窗口`Alt+h/j/k/l`
- 窗口比例调整`Ctrl+上/下/左/右`
- 一键等比例`s=`

#### Terminal
打开浮动终端`Leader+t`
垂直分屏打开终端`Leader+vt`
退出: 终端输入模式下`Esc`

### 搜索
搜索文件`Ctrl+p`
搜索文件内容`Ctrl+f`
搜索帮助文档`Ctrl+h`

### 编辑


### 指针移动/跳转/导航
跳回上一个位置`Ctrl+o`
重做跳回`Ctrl+i`

### 文件管理
打开文件树`F2`
重命名文件/文件夹`r`
新建文件/文件夹`a`
删除文件/文件夹`d`
折叠所有文件夹`W`
搜索`S`


### LSP


### 显示效果增强


### 插件开发
运行_spec测试`<leader>pt`








