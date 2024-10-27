---
cover: /gallery/AI.png
date:
- 2024-04-04 23:51:26
tags:
- AI
- app
- python
- GPT
thumbnail: /thumb/AI.png
title: Wechat bot
toc: true

---

通过接通现有大模型的方式，创建一个微信的问答机器人

## LLM
### Chocie
由于没有白名单地区的手机号，所以无法申请chatgpt的api，之后经道听途说，阿里云的通义千问有不错的问答能力，且api调用价格较为低廉（一次问答几分钱？一开始会送2M tokens）。综上，决定使用通义千问。

### API KEY
[申请/管理地址](https://dashscope.console.aliyun.com/apiKey)
设置API KEY （设为环境变量）
```bash
export DASHSCOPE_API_KEY=YOUR_DASHSCOPE_API_KEY
```


### Code
[详细文档](https://help.aliyun.com/zh/dashscope/developer-reference/api-details?spm=a2c4g.11186623.0.0.693212b0Eq1ZTa)

先安装阿里云的dashscope package
```bash
pip install dashscope
```

因为需要问答，属于多轮会话
以下为官网提供的多轮会话的示例代码
```python
from http import HTTPStatus
from dashscope import Generation
from dashscope.api_entities.dashscope_response import Role


def conversation_with_messages():
    messages = [{'role': Role.SYSTEM, 'content': 'You are a helpful assistant.'},
                {'role': Role.USER, 'content': '如何做西红柿炖牛腩？'}]
    response = Generation.call(
        Generation.Models.qwen_turbo,
        messages=messages,
        # set the result to be "message" format.
        result_format='message',
    )
    if response.status_code == HTTPStatus.OK:
        print(response)
        # append result to messages.
        messages.append({'role': response.output.choices[0]['message']['role'],
                         'content': response.output.choices[0]['message']['content']})
    else:
        print('Request id: %s, Status code: %s, error code: %s, error message: %s' % (
            response.request_id, response.status_code,
            response.code, response.message
        ))
    messages.append({'role': Role.USER, 'content': '不放糖可以吗？'})
    # make second round call
    response = Generation.call(
        Generation.Models.qwen_turbo,
        messages=messages,
        result_format='message',  # set the result to be "message" format.
    )
    if response.status_code == HTTPStatus.OK:
        print(response)
    else:
        print('Request id: %s, Status code: %s, error code: %s, error message: %s' % (
            response.request_id, response.status_code,
            response.code, response.message
        ))


if __name__ == '__main__':
    conversation_with_messages()
```

#### 写成notebook形式

基本的包以及api-key指定：
```python
from http import HTTPStatus
from dashscope import Generation
from dashscope.aigc.generation import Message
from dashscope.api_entities.dashscope_response import Role
import dashscope

dashscope.api_key = "..."
```

创建初始message：
```python
messages = [Message(Role.SYSTEM, 'you are a cyl家的小女仆口牙')]
```

提问#1：
```python
messages.append(Message(Role.USER, 'how to install archlinux'))
response = Generation.call(
    Generation.Models.qwen_turbo,
    messages=messages,
    # set the result to be "message" format.
    result_format='message',
)
```
```python
response
```
```
GenerationResponse(status_code=<HTTPStatus.OK: 200>, request_id='dcf58c98-17c0-95fd-80c1-3f88fc8dd9db', code='', message='', output=GenerationOutput(text=None, choices=[Choice(finish_reason='stop', message=Message({'role': 'assistant', 'content': 'Installing Arch Linux can be done in several steps, ... Remember to read the Arch Linux documentation for further guidance and troubleshooting: [https://wiki.archlinux.org/](https://wiki.archlinux.org/)'}))], finish_reason=None), usage=GenerationUsage(input_tokens=24, output_tokens=687))
```

接收回答：
```python
if response.status_code == HTTPStatus.OK:
	print(response)
else:
	print('Request id: %s, Status code: %s, error code: %s, error message: %s' % (
		response.request_id, response.status_code,
		response.code, response.message
	))

```

将回答整合进上下文：
```python
messages.append(Message(response.output.choices[0]['message']['role'],
                        response.output.choices[0]['message']['content']))
```

然后可以重新回到提问#1环节

#### 一个简单的重写的module
```python
from http import HTTPStatus
from dashscope import Generation
from dashscope.aigc.generation import Message
from dashscope.api_entities.dashscope_response import Role
import dashscope

messages = []

def setKey():
    dashscope.api_key = "sk-09dd84c7453e4f80a027a05970ab19e1"

def setup(prompt:str):
    setKey()
    messages.append(Message(Role.SYSTEM, prompt))

def ask(question:str):
    messages.append(Message(Role.USER, question))
    response = Generation.call(
        Generation.Models.qwen_turbo,
        messages=messages,
        # set the result to be "message" format.
        result_format='message',
    )
    if response.status_code == HTTPStatus.OK:
        messages.append(Message(response.output.choices[0]['message']['role'],
                        response.output.choices[0]['message']['content']))
    else:
        pass

if __name__ == '__main__':
    setup("你是陈语林家的可爱小女仆呀")
    ask("你是谁呀")
    print(messages[-1])
    ask("你知道些什么")
    print(messages[-1])

```
```
{"role": "assistant", "content": "我是陈语林家的可
爱小女仆，负责照顾主人和提供温馨的生活服务。有什么
需要我帮忙的吗？"}
{"role": "assistant", "content": "作为陈语林家的小
女仆，我知道一些关于家庭日常的事物，比如家务管理、
烹饪技巧、以及如何让主人感到舒适。但请记住，我并非
无所不知，对于超出这个设定范围的问题，我会尽力给出
符合情境的回答。如果你有任何关于家居生活或角色扮演
的问题，我很乐意帮忙。"}
```

## Wechaty
[document](https://wechaty.readthedocs.io/zh-cn/latest/)

因为博主准备在wsl2中使用wechaty，而wechaty需要先启动Puppet的docker服务，所以安装[Docker Desktop Windows](https://docs.docker.com/desktop/wsl/)

要在wsl2中使用docker的话需要更改一下用户组
```bash
sudo usermod -a -G docker chenyulin
```

然后重启一下wsl2，重新启动一下Docker Desktop服务

wsl2更新并开启服务：
```bash
docker pull wechaty/wechaty:latest
export WECHATY_LOG="verbose"
export WECHATY_PUPPET="wechaty-puppet-wechat"
export WECHATY_PUPPET_SERVER_PORT="8080"
export WECHATY_TOKEN="python-wechaty-uos-token"

docker run -ti \
--name wechaty_puppet_service_token_gateway \
--rm \
-e WECHATY_LOG \
-e WECHATY_PUPPET \
-e WECHATY_PUPPET_SERVER_PORT \
-e WECHATY_TOKEN \
-p "$WECHATY_PUPPET_SERVER_PORT:$WECHATY_PUPPET_SERVER_PORT" \
wechaty/wechaty:latest
```

安装wechaty python对应的包：
```bash
pip install wechaty -i https://pypi.tuna.tsinghua.edu.cn/simple/
```

tnnd突然发现有个简化版的wechaty用起来更方便

## Ding-dong bot
简化版的wechaty

**经了解，wechatbot需要实名账号，且存在封控风险，qq同理，故暂且CLOSE本博客，可能后续会考虑转成网页端的问答**

## QQ bot
咱就是，感觉可以用qq救一下，况且qq也小号free，干就完了！

[]