---
aliases:
- "\u5982\u4F55\u4F7F\u7528Shader\u5B9E\u73B0\u8BED\u4E49\u5206\u5272"
cover: /gallery/Unity.png
date:
- 2023-05-09 21:58:07
tags:
- Unity
- Shader
thumbnail: /thumb/Unity.png
title: SemanticSegmentation
toc: true

---

<!--toc:start-->
- [如何使用Shader实现语义分割](#如何使用shader实现语义分割)
  - [什么是Shader](#什么是shader)
  - [Shader代码的组成部分](#shader代码的组成部分)
  - [如何使用Shader实现语义分割](#如何使用shader实现语义分割)
<!--toc:end-->


# 如何使用Shader实现语义分割

## 什么是Shader

Shader是一种计算机程序，它用于在图形渲染管线中处理顶点和像素。在Unity中，Shader可以用来控制物体的渲染方式，包括颜色、纹理、透明度等。Shader的工作流程是将材料（如纹理、数据、颜色等）通过加工展现在材质上的过程。

Unity中有多种类型的Shader，可以根据不同的情况使用。例如，在三维网格上使用的方式和图片上使用的方式会有区别。

## Shader代码的组成部分

一个Unity Shader通常由以下几个部分组成：

- **Properties**：这部分定义了Shader中可供用户在材质检查器中编辑的属性。例如，可以定义一个颜色属性，让用户可以在材质检查器中更改物体的颜色。

- **SubShader**：每个Shader至少包含一个SubShader。SubShader定义了Shader的实际渲染操作。如果Shader需要支持多种不同的渲染硬件或渲染质量设置，可以在Shader中定义多个SubShader。

- **Pass**：每个SubShader至少包含一个Pass。Pass定义了一次渲染操作，包括顶点和片段着色器的代码。可以在一个SubShader中定义多个Pass来实现多次渲染操作。

- **CGPROGRAM**：这部分包含了顶点和片段着色器的代码。可以使用Cg/HLSL语言来编写着色器代码，并使用内置的变量和函数来访问物体的信息。
```c
Shader "Custom/SimpleColor" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            fixed4 _Color;

            struct appdata {
                float4 vertex : POSITION;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                return _Color;
            }
            ENDCG
        }
    }
}
```

## 如何使用Shader实现语义分割

如果希望根据物体的标签来控制物体的颜色，可以在Shader中使用材质属性来实现。首先，需要在脚本中获取物体的标签信息，并根据标签信息设置物体材质的颜色属性。然后，在Shader中，可以使用这个颜色属性来控制物体的渲染颜色。

下面是一个简单的示例，它展示了如何在脚本中设置材质的颜色属性，并在Shader中使用该属性来控制物体的颜色：

```csharp
// 脚本中设置材质的颜色属性
void Start()
{
    Renderer renderer = GetComponent<Renderer>();
    Material material = renderer.material;

    // 根据物体的标签设置材质的颜色属性
    if (CompareTag("Pedestrian"))
    {
        material.SetColor("_Color", Color.blue);
    }
    else if (CompareTag("Road"))
    {
        material.SetColor("_Color", Color.white);
    }
    else if (CompareTag("Building"))
    {
        material.SetColor("_Color", Color.black);
    }
}
````

```c
// Shader中使用颜色属性来控制物体的颜色
Shader "Custom/SemanticSegmentation" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            fixed4 _Color;

            struct appdata {
                float4 vertex : POSITION;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                return _Color;
            }
            ENDCG
        }
    }
}
```
