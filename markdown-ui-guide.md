# Markdown UI Enhancements Guide

## Width Issue Fixed
Changed `textwidth = 80` to `textwidth = 0` in markdown-workflow.lua to use full window width.

## Text Formatting Shortcuts
### Visual Mode (select text first)
- `<leader>mb` - **Bold** selected text
- `<leader>mi` - *Italic* selected text  
- `<leader>mc` - `Code` selected text
- `<leader>ms` - ~~Strikethrough~~ selected text
- `<leader>ml` - Create [link](url) from selected text
- `<leader>mw` - Create [[wiki link]] from selected text

### Normal Mode
- `<leader>m1-4` - Add heading levels (# to ####)
- `<leader>mx` - Toggle checkbox [ ] / [x]
- `<leader>mcc` - Insert code block
- `<leader>mhr` - Insert horizontal rule (---)
- `<leader>mw` - Show word count

## UI Features Active
1. **Checkbox Icons**: Your checkboxes show as:
   - [ ] Empty: 󰄱
   - [x] Checked: 
   - [>] Arrow: 
   - [~] Tilde: 󰰱

2. **Syntax Highlighting**:
   - Headers have different background colors
   - Links show with icons (󰌹 for web, 󰇮 for email)
   - Code blocks have borders
   - Quotes show with ▍ marker

3. **Conceal Mode**: Links and formatting are hidden when cursor is not on line (conceallevel=2)

## Obsidian Commands
- `<leader>on` - New note
- `<leader>os` - Search notes
- `<leader>oq` - Quick switch between notes
- `<leader>of` - Follow link under cursor
- `<leader>oc` - Toggle checkbox
- `<leader>ot` - Today's daily note

## Zen Mode
- `<leader>z` - Toggle Zen mode for distraction-free writing (120 char width)

## To See All UI Elements
1. Open any .md file
2. Try different elements:
   - Headers: # Test Header
   - Checkboxes: - [ ] Task
   - Links: [example](http://example.com)
   - Code blocks: ```language
   - Quotes: > Quote text

The render-markdown.nvim plugin provides the visual enhancements automatically when you use markdown syntax.