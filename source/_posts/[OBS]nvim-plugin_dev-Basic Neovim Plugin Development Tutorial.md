---
categories:
- Note
cover: /gallery/nvim.png
date:
- 2024-10-12 15:21:49
tags:
- nvim
- plugin
- lua
- linux
thumbnail: /thumb/nvim.png
title: Basic Neovim Plugin Development Tutorial
toc: true

---
## Basic Plugin File

Just take my `ColorfulDiff.nvim` as an example.
```shell
$ tree ColorfulDiff.nvim

├── LICENSE
├── lua
│   └── tint.lua
├── plugin
│   └── hello.lua
└── README.md
```
The lua scripts in `plugin/` will be executed automatically and the scripts in `lua/` will be called when `required`

To let nvim load the plugin, use lazy.nvim. 
Add this line in your lazy.nvim configuration:
```lua
{ dir = "/home/cyl/nvim_plugins/ColorfulDiff.nvim/" },
```
Then this plugin will be loaded on start.

## How To Use API
Use `:Telescope help_tags` or short hand `<Ctrl-h>` to open the help search panel.
If I want to know the API regarding the highlight:

![](Pasted_image_20241012181127.png)
the function with `nvim_` as prefix are the nvim api. Press `Enter` to see the detailed description:
```nvim
 *nvim_buf_add_highlight()*
nvim_buf_add_highlight({buffer}, {ns_id}, {hl_group}, {line},{col_start},{col_end})
    Adds a highlight to buffer.

    Useful for plugins that dynamically generate highlights to a buffer (like
    a semantic highlighter or linter). The function adds a single highlight to a buffer. Unlike |matchaddpos()| highlights follow changes to line
    numbering (as lines are inserted/removed above the highlighted line), like signs and marks do.
    ...
```

To use this api:
```lua
vim.api.nvim_buf_add_highlight(...)
```

## Test
Create a new folder called `test`
And create the test lua file
```lua
describe("colorfulDiff", function()
	it("can be required", function()
		require("colorful_diff")
	end)
	it("...", function()
		...
	end)
	...
end)
```
然后在该文件中按`<leader>pt`运行测试
![](Pasted_image_20241012180314.png)
## Reference
```nvim
:h lua-plugin
:h write-plugin
```
https://www.youtube.com/watch?v=n4Lp4cV8YR0&t=3960s