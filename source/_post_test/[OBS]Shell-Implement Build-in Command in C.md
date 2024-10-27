---
date:
- 2023-05-09 21:58:07
tags:
- linux
- c
- shell
title: Implement Build-in Command in C
toc: true

---
## Which are the build-in commands?

A shell built-in command is contained in the shell itself (implemented by shell author) and runs on the same shell without creating a new process, e.g. `cd`, `pwd`, `exit`, `alias`.

> **By contrast**: For a regular(linux) command, it is run from a binary file (found in $PATH or specified file) by forking the existing process in a subshell, e.g. `ls`, `cat`, `rm`.

## How to implement

### 1. Judge whether is build-in command

Assume we have already got the parsed arguments

 `char * parsedArgs[MAXPARSE]`.

> For example, a input `char * input = "cd .."` can be parsed as `char * parsedArgs[MAXPARSE] = {"cd", ".."}`

Then, we just need to judge whether `parsedArgs[0]` is contained in our build-in command set `{"exit", "cd", "pwd" ...}` (by using `strcmp`)

### 2. Implementation

In this project (as of milestone 2) , we need to implement `exit`, `pwd`, `cd`.

#### `exit`

In Bash, `exit` is a built-in command used to terminate the current shell session (same in our mumsh).

Each running shell is a process, so we can use the `exit()` in `stdlib.h` to terminate the shell process, achieving the goal of exiting the shell.

```c
void exec_exit(){
    printf("exit\n");
    exit(0); // 0 for exit normally, otherwise abnormally
}
```

---

#### `pwd`

Running a crude (or minimal?) shell and have no idea where you are? Just type `pwd` and it will print the name of the current/working directory.

In C, we can implement the similar functionality using the `getcwd()` in `unistd.h`.

> if success, `getcwd()` will return the pointer to the result, else ( e.g. no enough space) return `NULL`

```c
void exec_pwd(){
    char buf[1024]; // memory space need for storage
    printf("%s\n", getcwd(buf,sizeof(buf)));
}
```

However, the working directory is not guaranteed to be shorter than 1024, so we may need to dynamically allocate the buffer to suit the length.

```c
int size = 100;
char *buffer = malloc(size);

while (getcwd(buffer, size) == NULL) {
    if (errno == ERANGE) {  // buffer too small
        size *= 2;
        buffer = realloc(buffer, size);
    } else {  // other error
        ...
        free(buffer);
        return 1;
    }
}

printf("%s\n", buffer);

free(buffer);
```

---

#### `cd`

`cd` is used for changing working directory.

In C, we can implement the similar functionality using the `chdir()` in `unistd.h`.

> if success, `chdir()` will return 0, else ( e.g. no such directory) return -1

```c
void exec_cd(char * path){
    chdir(path);
}
```

Very straight forward, but if we want to implement more advanced features of the `cd` command such as changing to the home directory or the previous directory, we would need to handle these cases manually.

> For example, you could check if the argument is `~` or `-`, and then call `chdir()` with the appropriate path