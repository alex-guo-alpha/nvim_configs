# 📚 Complete Obsidian-Neovim Integration Guide

## 🎯 Overview
This guide covers everything you need to know about using Obsidian.nvim for powerful note-taking directly in Neovim. The integration provides Wiki-style linking, daily notes, templates, and seamless synchronization with the Obsidian app.

## 🚀 Quick Start

### Basic Setup
Your Obsidian workspaces are already configured:
- **Personal Notes**: `~/Documents/Notes`
- **Work Notes**: `~/Documents/Work-Notes`

### Essential Commands
1. **Create a note**: `<leader>on` 
2. **Search notes**: `<leader>os`
3. **Today's daily note**: `<leader>ot`
4. **Follow link**: `<leader>of` (with cursor on link)
5. **Insert link**: `<leader>ol`

## 📝 Core Features

### 1. Wiki-Style Linking
Create links between notes using double brackets:
```markdown
[[My Other Note]]
[[Projects/Project Name]]
[[Daily Notes/2024-01-15]]
```

**Tips:**
- Use `<leader>ol` to insert links with auto-completion
- Use `<leader>of` to follow links under cursor
- Use `<leader>ob` to go back to previous note

### 2. Daily Notes
Daily notes help track progress and maintain a journal:
- `<leader>ot` - Today's note
- `<leader>oy` - Yesterday's note
- `<leader>oT` - Tomorrow's note
- `<leader>od` - Browse all daily notes

**Template**: Create `~/Documents/Notes/templates/daily.md`:
```markdown
# {{date}}

## Tasks
- [ ] 

## Notes

## Links
```

### 3. Templates
Store templates in `~/Documents/Notes/templates/`:
- Use `<leader>otp` to insert a template
- Common templates: `daily.md`, `meeting.md`, `project.md`

**Example Project Template**:
```markdown
# {{title}}

## Overview

## Goals
- [ ] 

## Resources

## Notes

---
Created: {{date}}
Tags: #project
```

### 4. Tags
Use hashtags for organization:
```markdown
#project #idea #todo #reference
```
- Use `<leader>otg` to browse all tags
- Tags are searchable with `<leader>os`

### 5. Task Management
Create tasks with checkboxes:
```markdown
- [ ] Incomplete task
- [x] Completed task
- [-] Cancelled task
- [>] Deferred task
```
- Use `<leader>oc` to toggle checkboxes

### 6. Image Management
- `<leader>op` - Paste image from clipboard
- Images saved to: `~/Documents/Notes/assets/imgs/`
- Automatic markdown link generation

## 🔧 Advanced Features

### Frontmatter
Obsidian.nvim automatically manages frontmatter:
```yaml
---
id: unique-note-id
aliases: ["Alternative Name", "Shortcut"]
tags: [tag1, tag2]
---
```

### Note Search
`<leader>os` opens Telescope with:
- Fuzzy file name search
- Content search
- Tag filtering
- Recent notes

### Backlinks
- `<leader>obl` - Show all notes linking to current note
- Helps discover connections between ideas

### Workspaces
- `<leader>ow` - Switch between personal/work notes
- Each workspace has separate settings and templates

## 🎨 Markdown Enhancements

### Syntax Highlighting
Enhanced markdown syntax with:
- Code block highlighting
- Task list colors
- Link highlighting
- Tag colors

### Table Support
With vim-table-mode:
- `<leader>tm` - Toggle table mode
- Auto-formatting as you type
- Column alignment

### Preview
- `<leader>mp` - Start live preview in browser
- Updates in real-time as you type

## 📋 Best Practices

### 1. Note Organization
```
~/Documents/Notes/
├── Daily Notes/       # Automatic daily notes
├── Projects/          # Project documentation
├── Areas/            # Life areas (Health, Finance, etc.)
├── Resources/        # Reference materials
├── Archive/          # Old notes
└── templates/        # Note templates
```

### 2. Naming Conventions
- Use descriptive names: `Project - Meeting Notes 2024-01-15`
- Avoid special characters (except `-` and `_`)
- Use folders for major categories

### 3. Linking Strategy
- Create hub notes for major topics
- Link liberally between related notes
- Use aliases for common references

### 4. Tagging System
- Use hierarchical tags: `#project/active`, `#idea/tech`
- Keep tag list manageable
- Review and consolidate tags regularly

## 🔌 Recommended Neovim Settings

### Custom Markdown Settings
Add to your config for better markdown experience:
```lua
-- Better markdown concealing
vim.opt.conceallevel = 2
vim.opt.concealcursor = 'nc'

-- Wrap text in markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})
```

### Additional Keybindings
```lua
-- Quick note creation with timestamp
vim.keymap.set('n', '<leader>onn', function()
  local timestamp = os.date("%Y%m%d%H%M")
  vim.cmd('ObsidianNew ' .. timestamp)
end, { desc = 'New timestamped note' })
```

## 🚀 Workflow Examples

### 1. Zettelkasten Method
```markdown
# 202401151430 - Permanent Note Title

## Main Idea
One atomic idea per note

## Context
Why this matters

## Links
- [[Related Note 1]]
- [[Related Note 2]]

## References
- Source citations

Tags: #permanent #topic
```

### 2. Project Management
```markdown
# Project Name

## Overview
[[Project Goals]] | [[Project Timeline]]

## Current Sprint
- [ ] [[Task 1 - Description]]
- [ ] [[Task 2 - Description]]

## Meeting Notes
- [[2024-01-15 - Kickoff Meeting]]
- [[2024-01-22 - Status Update]]

## Resources
- [[Technical Specification]]
- [[Design Documents]]
```

### 3. Daily Review
```markdown
# 2024-01-15

## Morning Planning
- [ ] Review [[Project A]]
- [ ] Write [[Blog Post Draft]]

## Notes
Connected [[New Idea]] with [[Existing Project]]

## Evening Review
- Completed: 4/5 tasks
- Tomorrow: Focus on [[Priority Task]]
```

## 🐛 Troubleshooting

### Link Completion Not Working
- Ensure you're in an Obsidian workspace
- Check if notes exist in the vault
- Try `:checkhealth obsidian`

### Images Not Pasting
- Install `pngpaste` (macOS): `brew install pngpaste`
- Ensure clipboard contains an image
- Check image directory permissions

### Slow Performance
- Limit workspace size (archive old notes)
- Disable unused features in config
- Use `.obsidianignore` for large files

## 🔗 Integration with Obsidian App

### Sync Options
1. **iCloud**: Place vaults in iCloud Drive
2. **Obsidian Sync**: Official sync service
3. **Git**: Version control with git
4. **Syncthing**: Open-source sync

### Compatible Features
- ✅ Links and backlinks
- ✅ Tags
- ✅ Templates
- ✅ Daily notes
- ✅ Frontmatter
- ⚠️  Plugins (app-specific)
- ⚠️  Custom CSS (app-specific)

## 🎯 Next Steps

1. Create your first daily note: `<leader>ot`
2. Set up personal templates
3. Start linking notes together
4. Develop your tagging system
5. Explore advanced features as needed

Remember: The best note system is the one you actually use. Start simple and evolve your workflow over time.

## 🚀 Enhanced Obsidian Plugins (Just Added!)

I've installed additional plugins to supercharge your Obsidian-Neovim experience:

### 1. **Headlines.nvim** - Visual Heading Enhancement
- Makes markdown headers visually distinct with background colors
- Different colors for each heading level (H1-H6)
- Code blocks get special highlighting

### 2. **Better Text Objects**
- `as` / `is` - Select around/inside sentence (in markdown files)
- Works with all vim operations: `das` (delete a sentence), `cis` (change inside sentence)

### 3. **Follow MD Links** 
- Better link following with `gf` or `<leader>of`
- Works with relative paths and markdown links

### 4. **Calendar Integration**
- `<leader>ocal` - Open calendar view
- Navigate to daily notes by date
- Visual calendar for planning

### 5. **MKDX** - Markdown Extensions
- Smart checkbox toggling: ` ` → `x` → `-` → `~`
- Better link handling
- Table of contents generation
- External link recognition

### 6. **Better Markdown Folding**
- Fold by heading levels
- Nested folding support
- `za` - Toggle fold
- `zM` - Close all folds
- `zR` - Open all folds

### 7. **Render Markdown** - Live Preview in Neovim!
- Renders markdown directly in your buffer
- Beautiful icons for headers, links, checkboxes
- Code blocks with borders
- Bullet points with custom icons
- No need to open external preview!

### 8. **Enhanced TODO Comments** (Already Installed)
- Highlights TODO, FIXME, NOTE, IDEA, QUESTION in your notes
- `<leader>xT` - Browse all TODOs across your vault
- Supports: TODO, FIXME, HACK, WARN, PERF, NOTE, TEST, IDEA, QUESTION

## 🔧 Fixing the Vertical Line Issue

The black vertical line in markdown files was the `colorcolumn` at column 80. I've disabled it for you! 

If you want to re-enable it or adjust it:
```lua
-- In lua/custom/markdown-workflow.lua
vim.opt_local.colorcolumn = "80"  -- Show line at column 80
-- or
vim.opt_local.colorcolumn = "100" -- Show line at column 100
-- or
vim.opt_local.colorcolumn = ""    -- Remove the line (current setting)
```

## 📝 Quick Tips

1. **Auto-save** is enabled for markdown files - no need to manually save!
2. **Spell check** is on by default in markdown - use `z=` on misspelled words
3. **Smart lists** - Press Enter in a list to continue it
4. **Word count** - Use `<leader>mw` to see word/character count
5. **Quick formatting**:
   - `<leader>mb` - Bold selection
   - `<leader>mi` - Italic selection
   - `<leader>mc` - Code selection
   - `<leader>ms` - Strikethrough selection

Happy note-taking! 🎉