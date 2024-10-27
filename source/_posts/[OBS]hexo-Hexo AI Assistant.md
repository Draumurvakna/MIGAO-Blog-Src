---
categories:
- Note
cover: /gallery/hexo.png
date:
- 2024-10-08 13:44:56
tags:
- hexo
- html
- javascript
- aliyun
- AI
- llm
thumbnail: /thumb/hexo.png
title: Hexo AI Assistant
toc: true

---
参见 https://dingfen.github.io/2024/07/21/2024-7-21-ai_assist/

阿里云的大模型之前在搞wechat bot的时候接触过，这次再加上一个云函数的服务，就搞定了。
LLM:https://bailian.console.aliyun.com/?spm=a2c4g.11186623.0.0.2db33048PGTSE6#/app-center
云函数:https://fcnext.console.aliyun.com/applications?spm=5176.fcnext.0.0.65f378c8HmZpOP

在本地主要需要做的是在hexo中注入代码
添加文件`scripts/injector.js`
```html
hexo.extend.injector.register('body_end',`
<link rel="stylesheet" crossorigin href="https://g.alicdn.com/aliyun-documentation/web-chatbot-ui/0.0.11/index.css" />
<script type="module" crossorigin src="https://g.alicdn.com/aliyun-documentation/web-chatbot-ui/0.0.11/index.js"></script>
<script>
  window.CHATBOT_CONFIG = {
    endpoint: "/chat", // 可以替换为 https://{your-fc-http-trigger-domain}/chat
    displayByDefault: false, // 默认不展示 AI 助手聊天框
    aiChatOptions: { // aiChatOptions 中 options 会传递 aiChat 组件，自定义取值参考：https://docs.nlkit.com/nlux/reference/ui/ai-chat
      conversationOptions: { // 自定义取值参考：https://docs.nlkit.com/nlux/reference/ui/ai-chat#conversation-options
        conversationStarters: [
          {prompt: '哪款手机续航最长？'},
          {prompt: '你们有哪些手机型号？'},
          {prompt: '有折叠屏手机吗?'},
        ]
      },
      displayOptions: { // 自定义取值参考：https://docs.nlkit.com/nlux/reference/ui/ai-chat#display-options
        height: 600,
      },
      personaOptions: { // 自定义取值参考：https://docs.nlkit.com/nlux/reference/ui/ai-chat#chat-personas
        assistant: {
          name: '你好，我是你的 AI 助手',
          // AI 助手的图标
          avatar: 'https://img.alicdn.com/imgextra/i2/O1CN01Pda9nq1YDV0mnZ31H_!!6000000003025-54-tps-120-120.apng',
          tagline: '您可以尝试点击下方的快捷入口开启体验！',
        }
      }
    }
  };
</script>
<style>
  :root {
    /* webchat 工具栏的颜色 */
    --webchat-toolbar-background-color: #1464E4;
    /* webchat 工具栏文字和按钮的颜色 */
    --webchat-toolbar-text-color: #FFF;
  }
  /* webchat 对话框如果被遮挡，可以尝试通过 z-index、bottom、right 等设置来调整位置 */
  .webchat-container {
    z-index: 100;
    bottom: 10px;
    right: 10px;
  }
  /* webchat 的唤起按钮如果被遮挡，可以尝试通过 z-index、bottom、right 等设置来调整位置 */
  .webchat-bubble-tip {
    z-index: 99;
    bottom: 20px;
    right: 20px;
  }
</style>`
);
```

主要要更改的是`window.CHATBOT_CONFIG.endpoint`, 改为触发器的公网访问地址
![](Pasted_image_20241008193641.png)
然后更改avatar，添加浮动的对话泡图标balabala
```html
hexo.extend.injector.register('body_end',`
<link rel="stylesheet" crossorigin href="https://g.alicdn.com/aliyun-documentation/web-chatbot-ui/0.0.11/index.css" />
<script type="module" crossorigin src="https://g.alicdn.com/aliyun-documentation/web-chatbot-ui/0.0.11/index.js"></script>
<script>
  window.CHATBOT_CONFIG = {
    endpoint: "https://webchat-bot-iqu-knzhgrvznd.cn-hangzhou.fcapp.run/chat", // 可以替换为 https://{your-fc-http-trigger-domain}/chat
    displayByDefault: false, // 默认不展示 AI 助手聊天框
    aiChatOptions: { // aiChatOptions 中 options 会传递 aiChat 组件，自定义取值参考：https://docs.nlkit.com/nlux/reference/ui/ai-chat
      conversationOptions: { // 自定义取值参考：https://docs.nlkit.com/nlux/reference/ui/ai-chat#conversation-options
        conversationStarters: [
          {prompt: '你是谁？'},
          {prompt: '博主又是谁？'},
          {prompt: '博主喜欢的人是？'},
          {prompt: '想要博主联系方式！'},
        ]
      },
      displayOptions: { // 自定义取值参考：https://docs.nlkit.com/nlux/reference/ui/ai-chat#display-options
        height: 600,
      },
      personaOptions: { // 自定义取值参考：https://docs.nlkit.com/nlux/reference/ui/ai-chat#chat-personas
        assistant: {          name: '博主的AI助手，十四行诗参上！',
          // AI 助手的图标
          avatar: 'https://chen-yulin.github.io/thumb/14.png',
          tagline: '要不要试试问下面的问题呢？',
        }
      }
    }
  };
</script>
<style>
  :root {
    /* webchat 工具栏的颜色 */
    --webchat-toolbar-background-color: #1464E4;
    /* webchat 工具栏文字和按钮的颜色 */
    --webchat-toolbar-text-color: #FFF;
  }
  /* webchat 对话框如果被遮挡，可以尝试通过 z-index、bottom、left 等设置来调整位置 */
  .webchat-container {
    z-index: 100;
    bottom: 10px;
    right: 10px;
  }
  /* webchat 的唤起按钮如果被遮挡，可以尝试通过 z-index、bottom、left 等设置来调整位置 */
  .webchat-bubble-tip {
    z-index: 99;
    bottom: 20px;
    right: 20px;
  }
  .webchat-bubble-tip {
    overflow: visible !important;
  }
  @keyframes float {
    0% {
      transform: translateY(0px) translateX(-50%);
    }
    50% {
      transform: translateY(-10px) translateX(-50%);
    }
    100% {
      transform: translateY(0px) translateX(-50%);
    }
  }

  .webchat-bubble-tip::before {
    content: '';
    position: absolute;
    top: -25px;
    left: 70%;
    width: 40px;
    height: 40px;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='white'%3E%3Cpath d='M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm0 14H6l-2 2V4h16v12z'/%3E%3C/svg%3E");
    background-repeat: no-repeat;
    background-position: center;
    background-size: contain;
    filter: drop-shadow(0 4px 6px rgba(0, 0, 0, 0.5));
    animation: float 3s ease-in-out infinite;
  }
</style>
);

```

最终效果：
![](Pasted_image_20241008193811.png)
![](Pasted_image_20241008193823.png)
![](Pasted_image_20241008194013.png)