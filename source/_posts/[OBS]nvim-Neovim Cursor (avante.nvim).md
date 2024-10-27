---
categories:
- Note
cover: /gallery/nvim.png
date:
- 2024-10-07 14:03:02
tags:
- nvim
- AI
- plugin
thumbnail: /thumb/nvim.png
title: Neovim Cursor (avante.nvim)
toc: true

---
仓库地址: https://github.com/yetone/avante.nvim
## Accounts

虚拟手机号: https://sms-activate.io/en
（学校邮箱，密码需要大写）

注册Claude-chat
授权Claude-api(https://console.anthropic.com/)

## Apply Claude API
![](Pasted_image_20241007142632.png)

## Installation
我使用lazy.nvim插件管理器所以非常方便，只需要在`lazy_setup.lua`里加上
```lua
{
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  opts = {
    -- add any opts here
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
```
lazy安装完毕之后会有报错：
https://github.com/yetone/avante.nvim/issues/612
解决方案为
```bash
cd ~/.local/share/nvim/lazy/avante.nvim
make BUILD_FROM_SOURCE=true  
```
![](Pasted_image_20241007150254.png)

## 配置
添加`~/.config/nvim/lua/avante.lua`
```lua
---NOTE: user will be merged with defaults and
---we add a default var_accessor for this table to config values.

local Utils = require("avante.utils")

---@class avante.CoreConfig: avante.Config
local M = {}

---@class avante.Config
M.defaults = {
	debug = false,
	---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | [string]
	provider = "claude", -- Only recommend using Claude
	auto_suggestions_provider = "claude",
	---@alias Tokenizer "tiktoken" | "hf"
	-- Used for counting tokens and encoding text.
	-- By default, we will use tiktoken.
	-- For most providers that we support we will determine this automatically.
	-- If you wish to use a given implementation, then you can override it here.
	tokenizer = "tiktoken",
	---@alias AvanteSystemPrompt string
	-- Default system prompt. Users can override this with their own prompt
	-- You can use `require('avante.config').override({system_prompt = "MY_SYSTEM_PROMPT"}) conditionally
	-- in your own autocmds to do it per directory, or that fit your needs.
	system_prompt = [[
Act as an expert software developer.
Always use best practices when coding.
Respect and use existing conventions, libraries, etc that are already present in the code base.
]],
	---@type AvanteSupportedProvider
	openai = {
		endpoint = "https://api.openai.com/v1",
		model = "gpt-4o",
		timeout = 30000, -- Timeout in milliseconds
		temperature = 0,
		max_tokens = 4096,
		["local"] = false,
	},
	---@type AvanteSupportedProvider
	copilot = {
		endpoint = "https://api.githubcopilot.com",
		model = "gpt-4o-2024-05-13",
		proxy = nil, -- [protocol://]host[:port] Use this proxy
		allow_insecure = false, -- Allow insecure server connections
		timeout = 30000, -- Timeout in milliseconds
		temperature = 0,
		max_tokens = 4096,
	},
	---@type AvanteAzureProvider
	azure = {
		endpoint = "", -- example: "https://<your-resource-name>.openai.azure.com"
		deployment = "", -- Azure deployment name (e.g., "gpt-4o", "my-gpt-4o-deployment")
		api_version = "2024-06-01",
		timeout = 30000, -- Timeout in milliseconds
		temperature = 0,
		max_tokens = 4096,
		["local"] = false,
	},
	---@type AvanteSupportedProvider
	claude = {
		endpoint = "https://api.anthropic.com",
		model = "claude-3-5-sonnet-20240620",
		timeout = 30000, -- Timeout in milliseconds
		temperature = 0,
		max_tokens = 8000,
		["local"] = false,
	},
	---@type AvanteSupportedProvider
	gemini = {
		endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
		model = "gemini-1.5-flash-latest",
		timeout = 30000, -- Timeout in milliseconds
		temperature = 0,
		max_tokens = 4096,
		["local"] = false,
	},
	---@type AvanteSupportedProvider
	cohere = {
		endpoint = "https://api.cohere.com/v1",
		model = "command-r-plus-08-2024",
		timeout = 30000, -- Timeout in milliseconds
		temperature = 0,
		max_tokens = 4096,
		["local"] = false,
	},
	---To add support for custom provider, follow the format below
	---See https://github.com/yetone/avante.nvim/README.md#custom-providers for more details
	---@type {[string]: AvanteProvider}
	vendors = {},
	---Specify the behaviour of avante.nvim
	---1. auto_apply_diff_after_generation: Whether to automatically apply diff after LLM response.
	---                                     This would simulate similar behaviour to cursor. Default to false.
	---2. auto_set_keymaps                : Whether to automatically set the keymap for the current line. Default to true.
	---                                     Note that avante will safely set these keymap. See https://github.com/yetone/avante.nvim/wiki#keymaps-and-api-i-guess for more details.
	---3. auto_set_highlight_group        : Whether to automatically set the highlight group for the current line. Default to true.
	---4. support_paste_from_clipboard    : Whether to support pasting image from clipboard. This will be determined automatically based whether img-clip is available or not.
	behaviour = {
		auto_suggestions = false, -- Experimental stage
		auto_set_highlight_group = true,
		auto_set_keymaps = true,
		auto_apply_diff_after_generation = false,
		support_paste_from_clipboard = false,
	},
	history = {
		storage_path = vim.fn.stdpath("state") .. "/avante",
		paste = {
			extension = "png",
			filename = "pasted-%Y-%m-%d-%H-%M-%S",
		},
	},
	highlights = {
		---@type AvanteConflictHighlights
		diff = {
			current = "DiffText",
			incoming = "DiffAdd",
		},
	},
	mappings = {
		---@class AvanteConflictMappings
		diff = {
			ours = "co",
			theirs = "ct",
			all_theirs = "ca",
			both = "cb",
			cursor = "cc",
			next = "]x",
			prev = "[x",
		},
		suggestion = {
			accept = "<M-l>",
			next = "<M-]>",
			prev = "<M-[>",
			dismiss = "<C-]>",
		},
		jump = {
			next = "]]",
			prev = "[[",
		},
		submit = {
			normal = "<CR>",
			insert = "<C-s>",
		},
		-- NOTE: The following will be safely set by avante.nvim
		ask = "<leader>aa",
		edit = "<leader>ae",
		refresh = "<leader>ar",
		toggle = {
			default = "<leader>at",
			debug = "<leader>ad",
			hint = "<leader>ah",
			suggestion = "<leader>as",
		},
		sidebar = {
			switch_windows = "<Tab>",
			reverse_switch_windows = "<S-Tab>",
		},
	},
	windows = {
		---@alias AvantePosition "right" | "left" | "top" | "bottom"
		position = "right",
		wrap = true, -- similar to vim.o.wrap
		width = 30, -- default % based on available width in vertical layout
		height = 30, -- default % based on available height in horizontal layout
		sidebar_header = {
			align = "center", -- left, center, right for title
			rounded = true,
		},
		input = {
			prefix = "> ",
		},
		edit = {
			border = "rounded",
		},
	},
	--- @class AvanteConflictConfig
	diff = {
		autojump = true,
	},
	--- @class AvanteHintsConfig
	hints = {
		enabled = true,
	},
}

---@type avante.Config
M.options = {}

---@class avante.ConflictConfig: AvanteConflictConfig
---@field mappings AvanteConflictMappings
---@field highlights AvanteConflictHighlights
M.diff = {}

---@type Provider[]
M.providers = {}

---@param opts? avante.Config
function M.setup(opts)
	vim.validate({ opts = { opts, "table", true } })

	M.options = vim.tbl_deep_extend(
		"force",
		M.defaults,
		opts or {},
		---@type avante.Config
		{
			behaviour = {
				support_paste_from_clipboard = M.support_paste_image(),
			},
		}
	)
	M.providers = vim.iter(M.defaults)
		:filter(function(_, value)
			return type(value) == "table" and value.endpoint ~= nil
		end)
		:fold({}, function(acc, k)
			acc = vim.list_extend({}, acc)
			acc = vim.list_extend(acc, { k })
			return acc
		end)

	vim.validate({ provider = { M.options.provider, "string", false } })

	M.diff = vim.tbl_deep_extend(
		"force",
		{},
		M.options.diff,
		{ mappings = M.options.mappings.diff, highlights = M.options.highlights.diff }
	)

	if next(M.options.vendors) ~= nil then
		for k, v in pairs(M.options.vendors) do
			M.options.vendors[k] = type(v) == "function" and v() or v
		end
		vim.validate({ vendors = { M.options.vendors, "table", true } })
		M.providers = vim.list_extend(M.providers, vim.tbl_keys(M.options.vendors))
	end
end

---@param opts? avante.Config
function M.override(opts)
	vim.validate({ opts = { opts, "table", true } })

	M.options = vim.tbl_deep_extend("force", M.options, opts or {})
	M.diff = vim.tbl_deep_extend(
		"force",
		{},
		M.options.diff,
		{ mappings = M.options.mappings.diff, highlights = M.options.highlights.diff }
	)

	if next(M.options.vendors) ~= nil then
		for k, v in pairs(M.options.vendors) do
			M.options.vendors[k] = type(v) == "function" and v() or v
			if not vim.tbl_contains(M.providers, k) then
				M.providers = vim.list_extend(M.providers, { k })
			end
		end
		vim.validate({ vendors = { M.options.vendors, "table", true } })
	end
end

M = setmetatable(M, {
	__index = function(_, k)
		if M.options[k] then
			return M.options[k]
		end
	end,
})

M.support_paste_image = function()
	return Utils.has("img-clip.nvim") or Utils.has("img-clip")
end

M.get_window_width = function()
	return math.ceil(vim.o.columns * (M.windows.width / 100))
end

---@param provider Provider
---@return boolean
M.has_provider = function(provider)
	return M.options[provider] ~= nil or M.vendors[provider] ~= nil
end

---get supported providers
---@param provider Provider
---@return AvanteProviderFunctor
M.get_provider = function(provider)
	if M.options[provider] ~= nil then
		return vim.deepcopy(M.options[provider], true)
	elseif M.vendors[provider] ~= nil then
		return vim.deepcopy(M.vendors[provider], true)
	else
		error("Failed to find provider: " .. provider, 2)
	end
end

M.BASE_PROVIDER_KEYS = {
	"endpoint",
	"model",
	"deployment",
	"api_version",
	"proxy",
	"allow_insecure",
	"api_key_name",
	"timeout",
	-- internal
	"local",
	"_shellenv",
	"tokenizer_id",
	"use_xml_format",
}

return M

```

`~/.config/nvim/init.lua`中添加
```lua
require("plugin-config.avante").setup()
```

在`~/.bashrc`添加api key 
```bash
export ANTHROPIC_API_KEY=*** #码了
```
![](Pasted_image_20241007150217.png)

## Fix Error
### Error #1
运行时出现这个报错
![](Pasted_image_20241007151413.png)
参见 https://github.com/yetone/avante.nvim/pull/560/files

由于这个PR没有被merge所以决定fork一下这个仓库再应用更改
![](Pasted_image_20241007154329.png)
push到远程仓库后记得release一下

然后将该plugin的仓库地址改为我自己的
![](Pasted_image_20241007155603.png)
成功消除了这个报错

### Error #2
![](Pasted_image_20241007155718.png)
没有回复
访问 https://console.anthropic.com/settings/plans 发现是 没有Funds（说好的注册送5刀的额度的呢。。。）

使用WildCard服务 https://bewildcard.com/card ，具体账密见密码簿

### Error #3
发现服务器无响应
-  设置终端proxy `export https_proxy=127.0.0.1:7897`
- `sudo conda update curl` to solve curl(77) error


