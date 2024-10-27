---
aliases:
- SSH Overview
date:
- 2023-05-09 21:58:07
tags:
- linux
- ssh
title: ssh
toc: true

---


<!--toc:start-->
- [SSH Overview](#ssh-overview)
  - [SSH Keys](#ssh-keys)
  - [SSH Agent](#ssh-agent)
  - [Generating a New SSH Key Pair](#generating-a-new-ssh-key-pair)
  - [Adding a Key to the SSH Agent on Ubuntu](#adding-a-key-to-the-ssh-agent-on-ubuntu)
  - [Viewing Keys in the SSH Agent on Ubuntu](#viewing-keys-in-the-ssh-agent-on-ubuntu)
<!--toc:end-->

# SSH Overview

SSH (Secure Shell) is a network security protocol that provides secure access and file transfer through encryption and authentication mechanisms. It encrypts and verifies network data to provide secure login and other secure network services.

## SSH Keys

SSH uses a combination of public and private keys to secure communication. The public key is used to encrypt data, while the private key is used to decrypt data. This ensures that even if data is intercepted during transmission, attackers cannot decrypt it, ensuring data security.

## SSH Agent

An SSH agent is a program that stores private keys and can help you avoid having to enter your passphrase every time you use SSH. When you add a private key to an SSH agent, you only need to enter the passphrase the first time you use the key. After that, the SSH agent will automatically provide the private key for you.

## Generating a New SSH Key Pair

You can use the `ssh-keygen` tool to generate a new SSH key pair. Here's an example of how to use `ssh-keygen` to generate an RSA key pair:
```bash
ssh-keygen -t rsa -b 4096 -C “your_email@example.com”
```
In this command:

- `-t rsa` specifies the type of key to create. In this case, we're creating an RSA key.
- `-b 4096` specifies the number of bits in the key. In this case, we're creating a 4096-bit key.
- `-C "your_email@example.com"` adds a comment to the key. This can be any text you like, but it's common to use your email address.

After running this command, `ssh-keygen` will prompt you for a location to save the key pair and for a passphrase to secure the private key. You can accept the default location by pressing Enter, or you can specify a different location if you prefer. If you don't want to use a passphrase, you can leave it blank by pressing Enter.

## Adding a Key to the SSH Agent on Ubuntu

On Ubuntu, you can add a key to the `ssh-agent` by following these steps:

1. Open the terminal.
2. Make sure `ssh-agent` is running. You can start it by running the `eval "$(ssh-agent -s)"` command.
3. Run the `ssh-add ~/.ssh/id_rsa` command to add your first key (the one you commonly use) to the `ssh-agent`. If your key file is not in the default location (i.e., `~/.ssh/id_rsa`), replace the path in the command with the actual path of your key file.
4. If your key has a passphrase, you will be prompted to enter it. Enter the passphrase and press Enter.

After completing these steps, you have successfully added your first key to the `ssh-agent`. Now when you use SSH to connect to a remote server, the `ssh-agent` will automatically provide your private key.

## Viewing Keys in the SSH Agent on Ubuntu

On Ubuntu, you can view the keys added to the `ssh-agent` by running the `ssh-add -l` command. This command lists the fingerprints of all keys in the `ssh-agent`.
