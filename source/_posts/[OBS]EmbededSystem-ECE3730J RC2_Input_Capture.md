---
categories:
- Note
date:
- 2024-06-15 17:51:30
tags:
- Embeded-System
title: ECE3730J RC2_Input_Capture
toc: true

---
## Input Compare Module

IC is a peripheral that can monitor the input signal change (pos/neg edge) independent of the processor (Core).

![](Pasted_image_20240617150723.png)
You can consider IC as a **timer value recorder**. It will record the timer value each time the capture condition is met.

For detailed configuration, please refer to `Reference Manual.pdf` on canvas, page 349-359, 382-385.

Some useful documentation on the configuration register:
![](Pasted_image_20240617155913.png)
![](Pasted_image_20240617155926.png)
![](Pasted_image_20240617155935.png)

