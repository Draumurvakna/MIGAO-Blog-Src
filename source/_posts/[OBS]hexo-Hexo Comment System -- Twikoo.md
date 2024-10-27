---
categories:
- Note
cover: /gallery/hexo.png
date:
- 2024-09-02 21:42:14
tags:
- hexo
- javascript
thumbnail: /thumb/hexo.png
title: Hexo Comment System -- Twikoo
toc: true

---
因为之前使用gitalk评论系统在国内用不了了，所以尝试更换为一些国内可用的方案。其中一个是国内开发者开发@imaegoo搭建的Twikoo系统
![](Pasted_image_20240902214531.png)
> 拜一下，我的博客网也是改自他的魔改版hexo-icarus主题

对，然后针对icarus系的主题，官网有提供详细例程
主要分为云函数部署部分和前端配置部分
## 云函数
归根结底就是为静态的博客网提供一个可以响应用户数据提交和显示的服务。
主要分为两块
- Mongodb: 用于云存储用户评论数据
- Huggingface: 用于部署一个云服务器，响应用户需求，与db交互。

那么首先就需要去mongodb申请一个数据库，依照这个例程： https://twikoo.js.org/mongodb-atlas.html
![](Pasted_image_20240902215515.png)
> 密码保密)

随后huggingface的服务就通过这串链接字符串来与这个数据库交互

随后去huggingface开启云服务器: https://twikoo.js.org/backend.html#hugging-face-%E9%83%A8%E7%BD%B2
我的云仓库为： https://huggingface.co/spaces/CallMeChen/BlogComment
启动服务成功后可以看到如下log:
![](Pasted_image_20240902215813.png)
![](Pasted_image_20240902215855.png)![](Pasted_image_20240902215902.png)

## 前端配置
参照 https://www.anzifan.com/post/icarus_to_candy_2

## 关于评论头像
访客还可以通过输入数字 QQ 邮箱地址，使用 QQ 头像发表评论。

## 后续
添加图床方便上传图片(已解决)
![](Pasted_image_20240902223106.png)

## 维护
10/20发现评论系统不能用了，发现是mongodb暂停了数据库服务，想起来它应该是每个月都需要自己connect一下（也算是释放不活跃用户的资源吧）。
![](Pasted_image_20241020061633.png)
每周维护的时候需要进到 https://cloud.mongodb.com/v2/6610ebcc85d7126b38c3837b#/overview connect一下

随后发现huggingface的仓库一直卡在build，遂更换为Netlify云函数平台。
https://app.netlify.com/sites/admirable-sunburst-4762e3/configuration/general
![](Pasted_image_20241022115521.png)
这个仓库的函数会把评论存贮在test/comment下，和之前的twikoo/comment不同，导致历史评论无法显示，所以在twikoo/comment下使用aggregation
**$merge**
```sql
{
     into: { db: "test", coll: "comment" },
}
```