---
title: VIM Snippets Customization
date: 2022-04-12 19:59:18
tags: 
- Plugin
- Vim
- Snippets
categories: 
- Note
cover: /gallery/vim.png
thumbnail: /thumb/vim.png
---
Studying note for customizing vim-snippets.

## Install vim-snippets
See [Github](https://github.com/honza/vim-snippets)

### Syntax

Module:
```snippets
snippet [trigger] ["Description"] [index]
[content]
endsnippet
```

Index:
| Index | Description |
|----|----|
| b | trigger should be in the front of the line |
| i | trigger can be inside a word |
| w | trigger should be in the edge of two words |
| r | trigger can be a regular expression |
| A | auto trigger |

## Example
Generate a two column table:
```snippets
snippet tb2 "Create table of two columns" b
| $1 | $2 |
|----|----|
| $3 | $4 |
| $5 | $6 |
endsnippet

snippet tbex2 "Create table of two columns" b
| $1 | $2 |
endsnippet
```
Or generate a code block for bash
```snippets
snippet bbl "Bashblock" b
\`\`\`bash
\$ ${2:${VISUAL}}
\`\`\`
$0
endsnippet
```














