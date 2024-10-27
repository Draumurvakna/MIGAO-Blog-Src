---
categories:
- Note
cover: /gallery/Unity.png
date:
- 2024-08-01 15:32:57
tags:
- Unity
- python
thumbnail: /thumb/Unity.png
title: "\u7A0B\u5E8F\u63A5\u53E3\u5B9A\u4E49"
toc: true

---
# 程序接口定义

## Python->Unity

代码仓库：

[https://github.com/Chen-Yulin/Unity-Python-UDP-Communication](https://github.com/Chen-Yulin/Unity-Python-UDP-Communication)

传输的数据为字符串：

```csharp
def SendData(self, strToSend):
    # Use this function to send string to C#
    self.udpSock.sendto(bytes(strToSend,'utf-8'), (self.udpIP, self.udpSendPort))
```

### 物体识别信息

需要包含的信息：物体种类，物体的三轴方位，三轴旋转，三轴尺寸。

格式：

```csharp
{Object Detection}
category
position.x
position.y
position.z
eulerRotation.x
eulerRotation.y
eulerRotation.z
scale.x
scale.y
scale.z
```

示例：

```csharp
{Object Detection}
Handle
0.1
0.052
0.026
0
90
0
0.5
0.3
1
```

### 机械臂实时角度

需要包含的信息：6 个 joint 角度(单位为度)

格式：

```csharp
{Current Joint}
j0
j1
j2
j3
j4
j5
j6
```

## Unity->Python

### 机械臂需要旋转的角度

需要包含的信息：6 个 joint 角度(单位为度)

格式：

```csharp
{Target Joint}
j0
j1
j2
j3
j4
j5
j6
```
