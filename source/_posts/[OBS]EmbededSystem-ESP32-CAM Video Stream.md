---
categories:
- Note
date:
- 2024-09-25 16:54:42
tags:
- ESP32
- pio
- Embeded-System
title: ESP32-CAM Video Stream
toc: true

---
参考仓库: https://github.com/rzeldent/esp32cam-rtsp
## Objective
Stream video through wifi using ESP-32-CAM.
The video sources can be accessed by an ip address.

## Implemenation

Install PlatformIO plugin in vscode.
Clone the repository
```bash
git clone --recursive https://github.com/rzeldent/esp32cam-rtsp.git
```

Use vscode pio to open the project. Wait pio till its configuration is done.

Change the `default_envs` settings, here I use `esp32cam_ai_thinker`

![](Pasted_image_20240925170942.png)

> If no `default_envs` is specified, pio will build the project for all platforms

Here we can build and upload the program to the board.

![](Pasted_image_20240925171147.png)

Connect to `ESP****` WiFi, and visit `http://192.168.4.1` to configure the wifi settings of the board. I choose to my phone's hot spot.
![](Pasted_image_20240926095320.png)

Then open the monitor to check the ip address (you need to connect your computer to the same LAN (local area network) to visit the ip)

![](Pasted_image_20240925171246.png)

Visit the `192.168.23.142` and you will see the page (similar with the page of `http://192.168.4.1`):
![](Pasted_image_20240925171915.png)

Click `rtsp://192.168.23.197:554/mjpeg/1` and you will see the streaming video:
![](Pasted_image_20240925172909.png)

>生无可恋做横向.jpg
