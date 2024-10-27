---
categories:
- Note
cover: /gallery/python.png
date:
- 2024-08-01 15:27:02
tags:
- CV
- python
- Capstone
thumbnail: /thumb/python.png
title: "\u81EA\u5B9A\u4E49 Gen6d \u7269\u4F53"
toc: true

---
# 自定义 Gen6d 物体

仓库：[https://github.com/liuyuan-pal/Gen6D](https://github.com/liuyuan-pal/Gen6D)

手册：[https://github.com/liuyuan-pal/Gen6D/blob/main/custom_object.md](https://github.com/liuyuan-pal/Gen6D/blob/main/custom_object.md)

步骤指令：

```csharp
python prepare.py --action video2image --input data/custom/part1/ref.mp4 --output data/custom/part1/images --frame_inter 10 --image_size 960  

python prepare.py --action sfm --database_name custom/part1 --colmap D:\COLMAP\COLMAP-3.7-windows-cuda\COLMAP.bat        

# do some cloudcompare thing

python predict.py --cfg configs/gen6d_pretrain.yaml --database custom/part1 --video data/custom/part1/test.mp4 --resolution 460 --output data/custom/part1/test --ffmpeg ffmpeg

ffmpeg -framerate 30 -i %d-bbox.jpg -c:v libx264 -r 30 -pix_fmt yuv420p output.mp4
```

关于判定不准确怎么解决：[https://github.com/liuyuan-pal/Gen6D/issues/29](https://github.com/liuyuan-pal/Gen6D/issues/29)
