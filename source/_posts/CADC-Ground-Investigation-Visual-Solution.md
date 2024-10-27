---
title: CADC Ground Investigation Visual Solution
date: 2022-04-23 16:26:48
tags:
- CADC
- OpenCV
- Pytorch
- Python
- CNN
categories:
- Note
cover: /gallery/UAV-fw.png
thumbnail: /thumb/lena.png
---

# Catalog

<!-- vim-markdown-toc Marked -->

* [Introduce](#introduce)
    * [Motivation](#motivation)
    * [Objective](#objective)
* [Implementation](#implementation)
    * [Environment Preparation](#environment-preparation)
    * [Foundation](#foundation)
    * [Code Review](#code-review)
        * [Function detect\_target](#function-detect\_target)
            * [Overview](#overview)
            * [Get the estimated area of the target by color filtering](#get-the-estimated-area-of-the-target-by-color-filtering)

<!-- vim-markdown-toc -->


# Introduce
## Motivation
We want to apply computer vision to the plane to fullfill ground investigation task automatically.
## Objective
The input image looks like this:
![InputImg](img56.png "img56")

And we hope the output prediction to be <font color=#00bbbb>56</font>.

# Implementation
## Environment Preparation
- python3
- numpy
- torch
- torchvision
- opencv-python
- other basic or dependency package

(requirment.txt will be added afterwards)

## Foundation
Basic OpenCV methods is required.

Recommended learning site:
- For OpenCV
- - [Bilibili video tutorial](https://www.bilibili.com/video/BV1PV411774y?spm_id_from=333.999.0.0) (Only 1-27 is required for this project)
- - [Offical document](http://www.woshicver.com/)
- For CNN(implemented by pytorch)
- - [What is CNN](https://zhuanlan.zhihu.com/p/47184529)
- - [Official tutorial](https://pytorch.org/tutorials/beginner/basics/quickstart_tutorial.html)
- - [Hand -written number recognition](https://www.cnblogs.com/wj-1314/p/9842719.html)

## Code Review
[Source code](https://github.com/Chen-Yulin/CADC-Visual-Solution)
in `detect.py`, there are two large function
```python3
def detect_target(image):
    ...
def get_numberShot(img, rect_list, ROI):
    ...
```
### Function detect\_target
#### Overview
`detect_target` receive image data(three channels, BGR), detect the colored targets and returns the index of them.

index:
- rect_list
- - the list whose elements are Box2D type `rect`, indicating the information of the minimum bounding rectangle
- ROI
- - the list whose elements are index([x,y,w,h]) of orthogonal bounding rectangle
![MinRect and BoundingBox](minRect.png "MinRect & BoundingBox")
In this picture, the blue frames are the minimum bounding Rectangle and the green ones are ordinary bounding box.

Note: What is Box2D type `rect`?
| index | description |
|----|----|
| rect[0] | the location of the box's center (x,y) |
| rect[1][0] | width of the box(the length of the side which will be first reached by the horizontal line when rotating counter-clockwise)|
| rect[1][1] | height |
| rect[2] | rotation angle |

#### Get the estimated area of the target by color filtering
First we need to convert the color layout from BGR to HSV, which is easier to judge color.
```python3
image_hsv=cv2.cvtColor(image_cut,cv2.COLOR_BGR2HSV)
```
Then define a mask that filter the color(hue) range from 160-179 or 0-10 (red),
![HSV](hsv.png "HSV")
```python3
red1=np.array([0,100,100])
red2=np.array([10,255,255])
red3=np.array([160,100,100])
red4=np.array([179,255,255])
mask1=cv2.inRange(image_hsv,red1,red2)
mask2=cv2.inRange(image_hsv,red3,red4)
mask=cv2.bitwise_or(mask1,mask2)
```

And apply the mask to the picture
```python3
after_mask=cv2.add(image_cut, np.zeros(np.shape(image_cut), dtype=np.uint8), mask=mask)
```
![after_mask](after_mask.png "after_mask")

Turn the <font color=#00bbbb>after mask</font> image into binary image and adapt close and open processing to fill holes and cancel noise.
```python3
kernel=np.ones([3,3],np.uint8)
close=cv2.morphologyEx(binary,cv2.MORPH_CLOSE,kernel,iterations=3)
Open=cv2.morphologyEx(close,cv2.MORPH_OPEN,kernel,iterations=1)
```
![close and open](close_and_open.png "Close and Open")

Then, find the contours of the processed image.

For each contour, adapt filters such as area, the ratio of the height and width of bounding rectangle.

If these restrictions are fullfilled, append the index of bounding rectangle and min area rectangle to two lists respectively, and return the lists.
```python3
contours, hier=cv2.findContours(Open,cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_NONE)
res_img=image.copy()
ROI=[]
rect_list=[]
for i in range(len(contours)):
    if cv2.contourArea(contours[i])<100:
        continue
    epsl=0.01*cv2.arcLength(contours[i],True)
    approx=cv2.approxPolyDP(contours[i],epsl,True)
    x,y,w,h=cv2.boundingRect(approx)
    if (float(w/h)<2) and (float(w/h)>0.5):
        res_img=cv2.rectangle(res_img,(x,y),(x+w,y+h),(0,255,0),1)
        ROI.append([x,y,w,h])
        rect = cv2.minAreaRect(approx)
        box = cv2.boxPoints(rect)
        box = np.int0(box)
        rect_list.append(rect)
        res_img=cv2.drawContours(res_img, [box], 0, (255, 0, 0), 2)
cv2.imshow('res_img',res_img)
return rect_list,ROI
```
