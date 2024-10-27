---
categories:
- Note
cover: /gallery/hexo.png
date:
- 2024-07-14 18:24:37
tags:
- hexo
- plugin
- javascript
- html
- regex
thumbnail: /thumb/hexo.png
title: Hexo plugin -- hexo-photo-wall
toc: true

---
## Why
因为觉得hexo post的图片排版太烂了，手打html插入图片又很烦，于是乎决定写一个hexo的插件，能够通过一些关键字，识别图片组，然后再把这些图片以照片墙的方式组合在一起。
顺带可以了解一下hexo的渲染管道和javascript。

## How
### Hexo 渲染顺序

1. **初始化阶段**：
    
    - Hexo 读取配置文件和初始化插件。
    - 加载主题和其配置文件。
2. **内容处理阶段**：
    
    - **before_generate**：生成前触发，可用于在生成前进行一些准备工作。
    - **before_post_render**：在文章渲染之前触发，可用于在文章内容渲染之前对其进行修改。
    - **after_post_render**：在文章渲染之后触发，可用于在文章内容渲染之后对其进行修改。
    - **before_exit**：Hexo 退出前触发，可用于在退出前进行一些清理工作。
3. **生成阶段**：
    
    - 生成静态文件，包括 HTML、CSS、JavaScript 等。
    - 将内容写入 public 目录。
4. **部署阶段**：
    
    - 部署生成的静态文件到目标服务器或平台

我们需要做的就是在内容处理阶段，重新生成图片墙部分的html代码。

### Hexo Filter
#### 过滤器的工作原理
过滤器是通过 `hexo.extend.filter.register()` 方法来注册的。每个过滤器都绑定在特定的生命周期事件上，当这些事件触发时，Hexo 会依次执行所有注册在该事件上的过滤器。
- **before_generate**：生成站点之前触发。
- **before_post_render**：在文章内容渲染之前触发。
- **after_post_render**：在文章内容渲染之后触发。
- **before_exit**：Hexo 进程退出之前触发。
- **after_render**：HTML 内容渲染之后触发。
- **after_render**：CSS 内容渲染之后触发。
- **after_render**：JavaScript 内容渲染之后触发。
```javascript
hexo.extend.filter.register('after_post_render', function(data) {
  // 查找所有 img 标签并将 src 属性替换为 HTTPS 协议
  data.content = data.content.replace(/<img src="http:\/\/(.*?)"/g, '<img src="https://$1"');
  return data;
});
```

#### 过滤器的返回值
- 对于大多数过滤器函数，需要返回处理后的数据。例如，`after_post_render` 过滤器需要返回修改后的文章内容。
- 某些过滤器（如 `before_exit`）不需要返回值。

### 实现
首先创建一个存放插件的文件夹，我放在`hexo_root/plugins/hexo-photo-wall`
文件夹中创建一个js入口文件`index.js`
文件中注册filter并且实现替换功能
```javascript
hexo.extend.filter.register('before_generate', () => {
  console.log('This is my custom Hexo plugin!');
});
hexo.extend.filter.register('before_post_render', function(data) {
  const startTag = '--picture_wall--';
  const endTag = '--picture_wall_end--';

  const regex = new RegExp(`${startTag}[\\s\\S]*?${endTag}`, 'g');

  data.content = data.content.replace(regex, match => {
    const pictures = match
      .replace(startTag, '')
      .replace(endTag, '')
      .trim();

    const pictureArray = pictures.split('\n').map(item => item.trim()).filter(item => item);

    pictureArray.forEach(picture => {
        const srcMatch = picture.match(/!\[.*?\]\((.*?)\s+\"(.*?)\"\)/);
        if (srcMatch && srcMatch[1]) {
        console.log(`Found image: ${srcMatch[1]}, title: ${srcMatch[2]}`);  // 输出匹配到的图片路径和标题
        }
    });

    let pictureWallHtml = '<div class="picture-wall">';

    pictureArray.forEach(picture => {
      const srcMatch = picture.match(/!\[.*?\]\((.*?)\)/);
      if (srcMatch && srcMatch[1]) {
        pictureWallHtml += `<div class="picture-wall-item"><img src="${srcMatch[1]}" alt=""></div>`;
      }
    });

    pictureWallHtml += '</div>';

    console.log(pictureWallHtml);

    return pictureWallHtml;
  });

  return data;
});
```

此处的照片墙的排版和原本应该并没有区别，只是处于同一个`class="picture-wall"`的div下。后续需要通过修改css或者直接更改html来实现照片墙的效果。

