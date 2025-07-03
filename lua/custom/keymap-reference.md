# Neovim Keymap Reference

## Search Keymaps (<leader>s*)
- `<leader>sf` - Search Files (Telescope)
- `<leader>sg` - Search by Grep (Telescope)
- `<leader>sh` - Search Help (Telescope)
- `<leader>sk` - Search Keymaps (Telescope)
- `<leader>ss` - Search Select Telescope
- `<leader>sw` - Search current Word (Telescope)
- `<leader>sd` - Search Diagnostics (Telescope)
- `<leader>sr` - Search Resume (Telescope)
- `<leader>sn` - Search Neovim config files
- `<leader>sb` - Search all Buffers (advanced-search)
- `<leader>sR` - Search Replace with preview (advanced-search)
- `<leader>sP` - Search Project replace (advanced-search)
- `<leader>sH` - Search History (advanced-search)

## Swap Operations (<leader>S*)
- `<leader>Sa` - Swap parameter next (Treesitter)
- `<leader>SA` - Swap parameter previous (Treesitter)
- `<leader>Sf` - Swap function next (Treesitter)
- `<leader>SF` - Swap function previous (Treesitter)

## Spectre Search/Replace (<leader>S*)
- `<leader>S` - Toggle Spectre
- `<leader>Sw` - Spectre search current word
- `<leader>Sp` - Spectre search on current file

## Text Manipulation (<leader>t*)
- `<leader>tss` - Text Sort Selection
- `<leader>tsr` - Text Sort Reverse
- `<leader>a` - Align text (visual mode)

## Obsidian (<leader>o*)
- `<leader>of` - Obsidian Follow link
- `<leader>ob` - Obsidian Back/Smart action
- `<leader>oc` - Obsidian Toggle Checkbox
- `<leader>on` - Obsidian New note
- `<leader>oo` - Obsidian Open in app
- `<leader>os` - Obsidian Search
- `<leader>ot` - Obsidian Today's note
- `<leader>oy` - Obsidian Yesterday's note
- `<leader>oT` - Obsidian Tomorrow's note
- `<leader>od` - Obsidian Dailies
- `<leader>oq` - Obsidian Quick switch
- `<leader>ol` - Obsidian Links
- `<leader>oL` - Obsidian Link new
- `<leader>ow` - Obsidian Workspace
- `<leader>op` - Obsidian Paste image
- `<leader>or` - Obsidian Rename note
- `<leader>oe` - Obsidian Extract note (visual)
- `<leader>otp` - Obsidian Template Paste
- `<leader>otg` - Obsidian Tags
- `<leader>obl` - Obsidian BackLinks

## Directory Navigation (<leader>c*)
- `<leader>cd` - Change Directory
- `<leader>c-` - Cd to previous directory
- `<leader>ch` - Cd Home
- `<leader>cr` - Cd to Root (git)
- `<leader>cb` - Cd Back
- `<leader>cf` - Cd Forward
- `<leader>cu` - Cd Up
- `<leader>cuu` - Cd Up 2 levels
- `<leader>cH` - Cd History
- `<leader>cp` - Cd Picker (history)
- `<leader>cB` - Cd Browse
- `<leader>cc` - Cd Config
- `<leader>cn` - Cd Notes
- `<leader>ct` - Cd Tmp
- `<leader>cD` - Cd Documents
- `<leader>cP` - Cd Projects
- `<leader>pwd` - Print working directory

## Markdown (<leader>m*)
- `<leader>mp` - Markdown Preview
- `<leader>ms` - Markdown preview Stop
- `<leader>mt` - Markdown preview Toggle
- `<leader>tm` - Table Mode toggle
- `<leader>tt` - Tableize Text
- `<leader>mtc` - Markdown TOC Create
- `<leader>mtu` - Markdown TOC Update
- `<leader>mtr` - Markdown TOC Remove
- `<leader>mi` - Markdown paste Image

## Other
- `<leader>z` - Zen mode toggle
- `<leader>tw` - Twilight toggle

## Naming Conventions
To avoid future conflicts:
- `<leader>s*` - Search operations (lowercase)
- `<leader>S*` - Swap/Spectre operations (uppercase S)
- `<leader>t*` - Text manipulation
- `<leader>o*` - Obsidian operations
- `<leader>c*` - Change directory operations
- `<leader>m*` - Markdown operations
- `<leader>g*` - Git operations
- `<leader>r*` - Refactoring operations
- `<leader>q*` - Quick actions