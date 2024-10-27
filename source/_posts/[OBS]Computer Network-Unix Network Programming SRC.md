---
categories:
- Note
date:
- 2024-05-16 14:10:59
tags:
- Network
- linux
title: Unix Network Programming SRC
toc: true

---
The source code repository:https://github.com/unpbook/unpv13e

## Preparation

```bash
git clone https://github.com/unpbook/unpv13e
```

Configure the makefile for your system:
```bash
CC=gcc CFLAGS=-w CPPFLAGS=-w ./configure    
```
> In archlinux, if you use `./configure` directly, you will get `Wimplicit` compile error in the following steps.

Build the dependence library.
```bash
cd lib
make
cd ../libfree
make
cd ../libroute
make
```

You can test by using the sample program
```bash
cd ../intro
make daytimetcpcli
./daytimetcpcli 127.0.0.1
```

If you get error
```bash
connect error: Connection refused
```

You need to install `xinetd`, configure it and start the service
```bash
yay -S xinetd
nvim /etc/xinetd.d/daytime # set `disable` from `yes` to `no`
systemctl start xinetd
```

And run `daytimetcpcli` again, you will get something like
```bash
16 MAY 2024 14:09:07 CST
```

Then, you are all set.