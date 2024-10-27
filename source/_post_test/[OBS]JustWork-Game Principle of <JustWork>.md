---
categories:
- Note
cover: /gallery/Unity.png
date:
- 2024-05-12 15:38:24
tags:
- Game
- csharp
- Unity
thumbnail: /thumb/Unity.png
title: Game Principle of <JustWork>
toc: true

---
## 参考
Besiege

## 核心功能
### 机械建造
需要更高的建造自由度：例如刚体零件的顶点自定义，3轴移动，3轴旋转，3轴缩放。
可视化内容更丰富：例如碰撞箱，连接点。

### 物理优化
目前还是使用phsX引擎，考虑一下GPU加速这块功能。
零件之间的连接考虑使用joint以外的方式，特别是某些刚性连接。

### 逻辑电路体系
参考我写的[BesiegeModern Mod](https://github.com/Chen-Yulin/Besiege-Modern-Mod)

### 零件材质自定义
{金属，木，玻璃}
需要自己写shader material实现该功能。

## 次要功能
### 更好的机械破坏系统
譬如撞击变形，高速击穿之类的
很难
在已有父刚体在运行中，更改碰撞箱布置是非常耗费性能的。

### 场景建造
自定义场景元素

### 教程系统
参考mc机械动力模组的“思索”
animation制作

### 故事模式
起部分教程作用，添加沉浸感，吸引一些非硬核玩家

### 三渲二
难，可能对电脑性能有较高要求。

## 目前需要的技术栈
unity shader
unity animation
美术相关工具
物理引擎[Game Physics Engine Development](https://books.google.co.jp/books?hl=zh-CN&lr=&id=dSbMBQAAQBAJ&oi=fnd&pg=PP1&dq=physics+engine&ots=qe-FZOqhJq&sig=3qYjNeWT_DtbusyXffsCK8HvcSs&redir_esc=y#v=onepage&q&f=false)
unity URP