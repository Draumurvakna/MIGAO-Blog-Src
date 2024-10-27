---
categories:
- Note
date:
- 2024-09-23 11:44:27
tags:
- Embeded-System
- ESP32
- linux
title: ESP32 Development on Linux
toc: true

---
## Standard Toolchain Setup
Guide: https://docs.espressif.com/projects/esp-idf/en/stable/esp32/get-started/linux-macos-setup.html#

### ESP_IDF
I directly download the archive with all the submodules included: https://github.com/espressif/esp-idf/releases/tag/v5.3.1
> This archive can also be downloaded from Espressif's download server: [https://dl.espressif.com/github_assets/espressif/esp-idf/releases/download/v5.3.1/esp-idf-v5.3.1.zip](https://dl.espressif.com/github_assets/espressif/esp-idf/releases/download/v5.3.1/esp-idf-v5.3.1.zip)

cd into the unzip folder (The installation will fail in conda venv)
```bash
conda deactivate
./install.sh
. ./export.sh
```

In `~/.zshrc`
```bash
alias get_idf='. $HOME/esp/esp-idf-v5.3.1/export.sh'
```
Then each time I need to setup esp32 development environment, I only need to type `get_idf`.

Some useful commands
```bash
idf.py set-target esp32
idf.py menuconfig
idf.py build
idf.py -p /dev/ttyUSB0 -b 115200 flash
idf.py -p /dev/ttyUSB0 -b monitor
idf.py -p /dev/ttyUSB0 flash monitor # combine together
```

### PlatformIO
事实证明pio是最方便的。。
事前安装过pio的vscode插件，直接打开pio的esp32项目就直接可以编译上传以及查看串口监视器。

