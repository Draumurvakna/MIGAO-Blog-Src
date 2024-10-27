---
categories:
- Note
cover: /gallery/Unity.png
date:
- 2024-08-01 15:24:54
tags:
- Unity
- 6-D
- CV
- python
- Capstone
thumbnail: /thumb/Unity.png
title: 6d pose -- unity coordinate
toc: true

---
# 6d pose -> unity coordinate

unity 使用左手坐标系，普遍的 6d 算法使用右手坐标系，所以得出[R;t]后需要做一步针对 y 轴的反射变换

```python
def right_to_left_hand_pose_R(R):
    # 定义反射矩阵
    M = torch.tensor([
        [ 1,  0,  0],
        [ 0, -1,  0],
        [ 0,  0,  1]
    ], dtype=R.dtype)
    
    # 转换旋转矩阵
    R_prime = M @ R @ M
    
    return R_prime

def right_to_left_hand_pose_t(t):
    # 定义反射矩阵
    M = torch.tensor([
        [ 1,  0,  0],
        [ 0, -1,  0],
        [ 0,  0,  1]
    ], dtype=t.dtype)

    # 转换位移向量
    t_prime = M @ t

    return t_prime
```

可以看到效果很好：

![](TRoFbsobAoJOx2xgPcUcDkbxn1e.png)
