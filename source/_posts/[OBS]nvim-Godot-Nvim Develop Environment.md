---
categories:
- Note
cover: /gallery/godot.png
date:
- 2024-10-20 20:57:13
tags:
- godot
- nvim
- plugin
- debugger
thumbnail: /thumb/godot.png
title: Godot-Nvim Develop Environment
toc: true

---
## Useful Link
https://www.youtube.com/watch?v=cLWgjienc_s
https://github.com/habamax/vim-godot

## Implementation
### Nvim
安装`vim-godot`, 并且不用手动在配置中开启
```lua
{ "habamax/vim-godot", event = "VimEnter" },

```
在`init.lua`中，自动识别godot项目并且开启服务器端口
```lua
-- for godot
local gdproject = io.open(vim.fn.getcwd() .. "/project.godot", "r")
if gdproject then
	io.close(gdproject)
	vim.fn.serverstart("./godothost")
	vim.notify("Open godot project")
end
```

在`dap/nvim-dap/dap-godot.lua`中配置了dap debugger
```lua
local dap = require("dap")
dap.adapters.godot = {
	type = "server",
	host = "127.0.0.1",
	port = 6006,
}
dap.configurations.gdscript = {
	{
		type = "godot",
		request = "launch",
		name = "Launch scene",
		project = "${workspaceFolder}",
		launch_scene = true,
	},
}
```
其余dap的默认配置沿用之前的。
lsp:
```lua
lspconfig.gdscript.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
```

### Godot Editor
参考视频中在编辑器配置中设置外部编辑器即可。
