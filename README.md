# 🚀 Advanced Neovim Configuration Documentation

## 📋 Table of Contents
- [Overview](#overview)
- [Quick Start](#quick-start)
- [Plugin Architecture](#plugin-architecture)
- [Complete Plugin Reference](#complete-plugin-reference)
- [Custom Modules](#custom-modules)
- [Keybinding Reference](#keybinding-reference)
- [Obsidian Integration](#obsidian-integration)
- [Advanced Features](#advanced-features)
- [Installation & Setup](#installation--setup)
- [Troubleshooting](#troubleshooting)

## 🎯 Overview
This is a **comprehensive, production-ready Neovim configuration** built on top of Kickstart.nvim with extensive custom modules for enhanced productivity and workflow efficiency. It features:

- **85+ plugins** for complete development workflow
- **9 custom modules** with advanced functionality  
- **Obsidian integration** for note-taking and documentation
- **Advanced text manipulation** and multi-editing capabilities
- **Smart navigation** and window management
- **Git workflow** enhancements with visual diff tools
- **Session management** for project persistence
- **LSP integration** with multiple language servers
- **Markdown workflow** optimized for documentation and notes

## ⚡ Quick Start

### Essential Keybindings to Know
| Action | Keybinding | Description |
|--------|------------|-------------|
| **File Explorer** | `<leader>e` | Toggle Neo-tree |
| **Find Files** | `<leader>sf` | Telescope file finder |
| **Search Text** | `<leader>sg` | Live grep search |
| **Git Status** | `<leader>gg` | Open Neogit |
| **Terminal** | `<C-\>` | Toggle floating terminal |
| **Command Palette** | `<leader>ss` | Telescope builtin commands |
| **Obsidian Notes** | `<leader>on` | Create new note |
| **Multi-Edit** | `<leader>mh` | Highlight pattern matches |
| **Quick Actions** | `<leader>qd` | Duplicate current line |
| **Format Code** | `<leader>f` | Format buffer |

### First Time Setup
1. **Install dependencies**: `brew install lazygit ripgrep fd make`
2. **Open Neovim**: Plugins will auto-install
3. **Run health check**: `:checkhealth`
4. **Try Obsidian**: `<leader>on` to create your first note

## 🏗️ Installation Requirements

### Required Dependencies
```bash
# Install lazygit (for Git integration)
brew install lazygit  # macOS
# or
sudo apt install lazygit  # Ubuntu/Debian
# or  
sudo pacman -S lazygit  # Arch Linux

# Make sure these are available
make        # for telescope-fzf-native
git         # version control
ripgrep     # for telescope live_grep
fd          # for telescope find_files (optional but recommended)
```

## Core Structure

```
~/.config/nvim/
├── init.lua                           # Main configuration entry point
├── lazy-lock.json                     # Plugin version lock file
├── README.md                          # Custom documentation
├── doc/
│   ├── kickstart.txt                 # Kickstart documentation
│   └── tags                          # Help tags
└── lua/
    ├── kickstart/
    │   └── health.lua                # Health check utilities
    └── custom/                       # All custom modules
        ├── plugins/                  # Plugin definitions
        └── [module-dirs]/           # Custom functionality modules
```

## 🔧 Plugin Architecture

This configuration uses **Lazy.nvim** for plugin management with lazy loading for optimal performance.

### 📦 Core Framework (Kickstart.nvim Base)
| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **lazy.nvim** | Plugin manager | Lazy loading, lockfile, UI |
| **nvim-lspconfig** | LSP configuration | Auto-setup, diagnostics, formatting |
| **mason.nvim** | Tool installer | LSP servers, formatters, linters |
| **blink.cmp** | Autocompletion | Fast, LSP-powered, snippet support |
| **nvim-treesitter** | Code parsing | Syntax highlighting, text objects |
| **telescope.nvim** | Fuzzy finder | Files, grep, commands, LSP symbols |
| **which-key.nvim** | Key helper | Shows available keybindings |
| **gitsigns.nvim** | Git integration | Hunks, blame, staging |

### 🎨 UI & Experience
| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **tokyonight.nvim** | Color scheme | Modern, customizable theme |
| **noice.nvim** | Enhanced UI | Better messages, cmdline, popups |
| **neo-tree.nvim** | File explorer | Tree view, git status, multiple sources |
| **lualine.nvim** | Status line | Git branch, diagnostics, file info |
| **mini.nvim** | Utilities | Statusline, surround, text objects |
| **nvim-notify** | Notifications | Animated, customizable notifications |
| **indent-blankline.nvim** | Visual guides | Indentation visualization |
| **nvim-colorizer.lua** | Color preview | Shows colors in CSS, HTML, etc. |

### 🔍 Search & Navigation
| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **telescope-fzf-native.nvim** | Fast search | Native C fuzzy matching |
| **telescope-file-browser.nvim** | File browser | Create, delete, rename files |
| **flash.nvim** | Quick navigation | Jump to any position quickly |
| **nvim-spectre** | Find & replace | Project-wide search and replace |
| **trouble.nvim** | Error navigation | Better diagnostics interface |
| **marks.nvim** | Mark management | Visual marks, descriptions |

### 📝 Text Editing & Manipulation
| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **nvim-surround** | Text wrapping | Add/change/delete surroundings |
| **nvim-autopairs** | Auto-pairing | Smart bracket/quote pairing |
| **nvim-treesitter-textobjects** | Smart selection | Function/class/parameter objects |
| **conform.nvim** | Code formatting | Multiple formatters, auto-format |
| **mini.ai** | Text objects | Enhanced around/inside objects |
| **vim-wordmotion** | Word movement | CamelCase/snake_case aware |

### 🔄 Git & Version Control
| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **neogit** | Git interface | Interactive staging, committing |
| **diffview.nvim** | Diff viewer | Side-by-side, file history |
| **gitsigns.nvim** | Line-level git | Hunks, blame, staging |

### 📚 Note-Taking & Documentation
| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **obsidian.nvim** | Note management | Wiki links, daily notes, templates |
| **markdown-preview.nvim** | Live preview | Browser-based markdown preview |
| **vim-table-mode** | Table editing | Auto-formatting, calculations |
| **zen-mode.nvim** | Focus mode | Distraction-free writing |
| **twilight.nvim** | Code dimming | Highlight current section |
| **vim-markdown** | Markdown syntax | Enhanced highlighting |
| **vim-markdown-toc** | Table of contents | Auto-generated TOC |
| **img-paste.vim** | Image pasting | Direct image insertion |
| **bullets.vim** | List management | Smart bullet/numbering |

### 🛠️ Development Tools
| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **toggleterm.nvim** | Terminal | Floating, horizontal, vertical |
| **nvim-ufo** | Code folding | Treesitter-based folding |
| **fidget.nvim** | LSP progress | Shows LSP loading status |
| **lazydev.nvim** | Lua development | Neovim API completion |
| **project.nvim** | Project management | Auto-detection, switching |
| **nvim-bqf** | Quickfix | Better quickfix experience |

### 🔧 Workflow Enhancement
| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **neoscroll.nvim** | Smooth scrolling | Animated page movement |
| **vim-illuminate** | Symbol highlighting | Highlight symbol occurrences |
| **todo-comments.nvim** | TODO highlighting | Find and highlight TODOs |
| **vim-sleuth** | Auto-indent | Detect indentation automatically |

## 🎹 Complete Keybinding Reference

### 🗂️ File & Buffer Operations
| Keybinding | Action | Description |
|------------|--------|-------------|
| `<leader>e` | File Explorer | Toggle Neo-tree |
| `<leader>E` | Reveal File | Reveal current file in Neo-tree |
| `<leader>sf` | Find Files | Telescope file finder |
| `<leader>sr` | Recent Files | Search recent files |
| `<leader><leader>` | Buffer List | Find existing buffers |
| `<leader>qd` | Duplicate Line | Duplicate current line |
| `<leader>qb` | Delete Blanks | Remove blank lines |
| `<leader>qw` | Strip Whitespace | Remove trailing whitespace |
| `<leader>qo` | Close Others | Close other buffers |
| `<leader>qp` | Copy Path | Copy file path |
| `<leader>qn` | Copy Name | Copy filename |

### 🔍 Search & Replace
| Keybinding | Action | Description |
|------------|--------|-------------|
| `<leader>sg` | Live Grep | Search text in project |
| `<leader>sw` | Search Word | Search current word |
| `<leader>s/` | Search Buffers | Search in open files |
| `<leader>sd` | Search Diagnostics | Find errors/warnings |
| `<leader>sh` | Search Help | Search help tags |
| `<leader>sr` | Search Replace | Interactive find/replace |
| `<leader>sp` | Project Search | Advanced project search |
| `<leader>sb` | Buffer Search | Search all buffers |
| `<leader>S` | Spectre | Advanced find/replace tool |
| `*` (visual) | Search Selection | Search visual selection |

### 🎯 Multi-Edit & Text Manipulation
| Keybinding | Action | Description |
|------------|--------|-------------|
| `<leader>mh` | Highlight Matches | Highlight pattern matches |
| `<leader>md` | Delete Matches | Delete all pattern matches |
| `<leader>mr` | Replace Matches | Replace all pattern matches |
| `<leader>mwd` | Delete Words | Delete word matches only |
| `<leader>mwr` | Replace Words | Replace word matches only |
| `<leader>cs` | Snake Case | Convert to snake_case |
| `<leader>cc` | Camel Case | Convert to camelCase |
| `<leader>cp` | Pascal Case | Convert to PascalCase |
| `<leader>ck` | Kebab Case | Convert to kebab-case |
| `<leader>cu` | Upper Case | Convert to UPPERCASE |
| `<leader>cl` | Lower Case | Convert to lowercase |
| `<leader>a` | Align Text | Align by character |
| `<leader>ss` | Sort Lines | Sort selection |
| `<leader>sr` | Reverse Sort | Reverse sort selection |

### 🔄 Git Operations
| Keybinding | Action | Description |
|------------|--------|-------------|
| `<leader>gg` | Git Status | Open Neogit |
| `<leader>gb` | Git Blame | Show line blame |
| `<leader>gt` | Time Machine | Git file history |
| `<leader>gc` | Commit | Conventional commit |
| `<leader>gS` | Stash Menu | Stash management |
| `<leader>gp` | Cherry Pick | Git cherry-pick |
| `<leader>gd` | Diff View | Git diff viewer |
| `<leader>gh` | File History | Git file history |
| `<leader>hs` | Stage Hunk | Stage current hunk |
| `<leader>hr` | Reset Hunk | Reset current hunk |
| `<leader>lg` | LazyGit | Open LazyGit |

### 🧭 Navigation & Movement
| Keybinding | Action | Description |
|------------|--------|-------------|
| `<leader>nm` | Named Mark | Set named mark |
| `<leader>nl` | Mark List | List named marks |
| `]f` / `[f` | Function Jump | Next/previous function |
| `]c` / `[c` | Class Jump | Next/previous class |
| `<M-Left>` / `<M-Right>` | Jump History | Navigate jump history |
| `<leader>%` | Smart Jump | Smart bracket matching |
| `s` | Flash Jump | Quick jump to character |
| `S` | Flash Treesitter | Jump to syntax element |
| `<C-h/j/k/l>` | Window Move | Move between windows |

### 🏠 Window & Session Management
| Keybinding | Action | Description |
|------------|--------|-------------|
| `<leader>ws` | Smart Split | Intelligent window split |
| `<leader>wz` | Zoom Toggle | Toggle window zoom |
| `<leader>wh/j/k/l` | Swap Window | Swap windows |
| `<C-A-h/j/k/l>` | Smart Move | Move/create windows |
| `<leader>Ss` | Save Session | Save current session |
| `<leader>Sl` | Load Session | List/load sessions |
| `<leader>Sa` | Auto Save | Toggle session auto-save |

### 🔧 Development Tools
| Keybinding | Action | Description |
|------------|--------|-------------|
| `<leader>f` | Format | Format current buffer |
| `<leader>q` | Diagnostics | Open diagnostic quickfix |
| `<leader>xx` | Trouble | Toggle diagnostics panel |
| `<leader>xl` | Location List | Show location list |
| `<leader>xq` | Quickfix | Show quickfix list |
| `grn` | LSP Rename | Rename symbol |
| `gra` | Code Action | Show code actions |
| `grd` | Go Definition | Go to definition |
| `grr` | References | Find references |
| `gri` | Implementation | Go to implementation |

### 🔄 Refactoring
| Keybinding | Action | Description |
|------------|--------|-------------|
| `<leader>rv` | Extract Variable | Extract variable (visual) |
| `<leader>rf` | Extract Function | Extract function (visual) |
| `<leader>ri` | Inline Variable | Inline variable |
| `<leader>rt` | Toggle Function | Toggle function style |

### 📝 Text Surrounding
| Keybinding | Action | Description |
|------------|--------|-------------|
| `S` (visual) | Surround | Surround selection |
| `ys{motion}{char}` | Add Surround | Surround motion |
| `cs{old}{new}` | Change Surround | Change surrounding |
| `ds{char}` | Delete Surround | Delete surrounding |
| `<leader>w(` | Quick Parens | Surround with () |
| `<leader>w[` | Quick Brackets | Surround with [] |
| `<leader>w{` | Quick Braces | Surround with {} |
| `<leader>w"` | Quick Quotes | Surround with "" |
| `<leader>w'` | Quick Singles | Surround with '' |

### 📱 Terminal Operations
| Keybinding | Action | Description |
|------------|--------|-------------|
| `<C-\>` | Float Terminal | Toggle floating terminal |
| `<leader>th` | Horizontal | Horizontal terminal |
| `<leader>tv` | Vertical | Vertical terminal |
| `<leader>tf` | Float | Floating terminal |
| `<Esc><Esc>` | Exit Terminal | Exit terminal mode |

### 📚 Obsidian Note-Taking
| Keybinding | Action | Description |
|------------|--------|-------------|
| `<leader>on` | New Note | Create new note |
| `<leader>oo` | Open Obsidian | Open in Obsidian app |
| `<leader>os` | Search Notes | Search through notes |
| `<leader>ot` | Today's Note | Open today's daily note |
| `<leader>oy` | Yesterday | Open yesterday's note |
| `<leader>oT` | Tomorrow | Open tomorrow's note |
| `<leader>od` | Daily Notes | Browse daily notes |
| `<leader>ol` | Insert Link | Insert/create link |
| `<leader>oL` | New Linked | Create new linked note |
| `<leader>of` | Follow Link | Follow link under cursor |
| `<leader>ob` | Back/Action | Go back or smart action |
| `<leader>oc` | Toggle Checkbox | Toggle task checkbox |
| `<leader>ow` | Switch Workspace | Switch between workspaces |
| `<leader>op` | Paste Image | Paste image from clipboard |

### 📄 Markdown & Documentation
| Keybinding | Action | Description |
|------------|--------|-------------|
| `<leader>mp` | Preview | Start markdown preview |
| `<leader>ms` | Stop Preview | Stop markdown preview |
| `<leader>tm` | Table Mode | Toggle table mode |
| `<leader>z` | Zen Mode | Toggle zen mode |
| `<leader>tw` | Twilight | Toggle twilight |
| `<leader>mtc` | Create TOC | Create table of contents |
| `<leader>mtu` | Update TOC | Update table of contents |
| `<leader>mi` | Insert Image | Insert image in markdown |

### Quality of Life Enhancement Plugins

#### **nvim-notify**
- **Purpose**: Better notification system with animations
- **Usage**: Automatic for all `vim.notify()` calls
- **Features**: Customizable timeout, positioning, and styling
- **Commands**: `:Notifications` to view history

#### **neoscroll.nvim**
- **Purpose**: Smooth scrolling animations
- **Key mappings**: 
  - `<C-u>/<C-d>` - Smooth half-page up/down
  - `<C-b>/<C-f>` - Smooth full-page up/down
  - `<C-y>/<C-e>` - Smooth line up/down
- **Features**: Configurable easing functions

#### **indent-blankline.nvim**
- **Purpose**: Visual indent guides
- **Features**: Shows `┊` characters for indentation levels
- **Usage**: Automatic in all files
- **Customization**: Different colors for different indent levels

#### **nvim-bqf**
- **Purpose**: Better quickfix window experience
- **Features**: Preview window, better navigation
- **Usage**: Automatic when opening quickfix (`:copen`)
- **Key mappings**: 
  - `p` - Preview in quickfix
  - `<Tab>/<S-Tab>` - Navigate items

#### **nvim-colorizer.lua**
- **Purpose**: Highlights color codes in files
- **Features**: Supports hex, rgb, CSS colors, Tailwind CSS
- **Usage**: Automatic in CSS, HTML, JS files
- **Commands**: `:ColorizerToggle`

### Advanced Workflow Plugins

#### **telescope-fzf-native.nvim**
- **Purpose**: Faster fuzzy matching for Telescope
- **Features**: Native C implementation for better performance
- **Build requirement**: `make` command
- **Usage**: Automatic enhancement to all Telescope searches

#### **telescope-file-browser.nvim**
- **Purpose**: File manager integration with Telescope
- **Key mappings**:
  - `<leader>fb` - File browser
  - `<leader>fB` - File browser (current directory)
- **Features**: Create, delete, rename, move files
- **Usage**: Navigate with Telescope interface

#### **nvim-treesitter-textobjects**
- **Purpose**: Smart text objects using treesitter
- **Key mappings**:
  - `af/if` - Function (around/inside)
  - `ac/ic` - Class (around/inside)
  - `aa/ia` - Parameter/argument (around/inside)
  - `ab/ib` - Block (around/inside)
  - `]f/[f` - Next/previous function
  - `]c/[c` - Next/previous class
  - `]a/[a` - Next/previous parameter
  - `<leader>sa/sA` - Swap parameters
  - `<leader>sf/sF` - Swap functions
- **Usage**: Use in visual mode or with operators (`daf`, `yic`, etc.)

#### **nvim-autopairs**
- **Purpose**: Automatic bracket and quote pairing
- **Features**: 
  - Auto-close brackets, quotes, etc.
  - Fast wrap with `<C-e>`
  - Treesitter integration for smart pairing
- **Usage**: Automatic during typing

#### **nvim-ufo**
- **Purpose**: Advanced folding with treesitter
- **Key mappings**:
  - `zR` - Open all folds
  - `zM` - Close all folds
  - `zr` - Reduce fold level (open some)
  - `zm` - Increase fold level (close some)
- **Features**: Treesitter-based folding, fold preview
- **Usage**: Better code folding than default Vim

#### **project.nvim**
- **Purpose**: Project detection and management
- **Key mapping**: `<leader>fp` - Find/switch projects
- **Features**: Auto-detection of project root, project history
- **Integration**: Works with Telescope for project switching

#### **trouble.nvim**
- **Purpose**: Better diagnostics and error management
- **Key mappings**:
  - `<leader>xx` - Toggle diagnostics panel
  - `<leader>xX` - Buffer diagnostics only
  - `<leader>xl` - Location list
  - `<leader>xq` - Quickfix list
  - `<leader>xT` - Todo comments
- **Features**: Grouped diagnostics, quick navigation
- **Usage**: Better than default quickfix for errors

#### **vim-wordmotion**
- **Purpose**: Enhanced word motions (CamelCase, snake_case aware)
- **Key mappings**: 
  - `<Leader>w/b/e` - Smart word movements
  - Works with all operators (`d<leader>w`, `c<leader>w`)
- **Features**: Respects programming conventions
- **Usage**: More precise word-based navigation

#### **nvim-spectre**
- **Purpose**: Advanced search and replace across project
- **Key mappings**:
  - `<leader>S` - Open Spectre panel
  - `<leader>sw` - Search current word
  - `<leader>sp` - Search in current file
- **Features**: Live preview, regex support, file filtering
- **Usage**: Project-wide find and replace with preview

#### **marks.nvim**
- **Purpose**: Enhanced marks with visual indicators
- **Features**: 
  - Visual marks in sign column
  - Automatic mark descriptions
  - Mark bookmarks management
- **Usage**: Better than default Vim marks
- **Commands**: All standard mark commands work better

#### **diffview.nvim**
- **Purpose**: Advanced Git diff visualization
- **Key mappings**:
  - `<leader>gd` - Open Git diffview
  - `<leader>gh` - Git file history
  - `<leader>gH` - Git file history (current file)
- **Features**: Side-by-side diffs, file history, merge conflict resolution
- **Usage**: Better than default Git diff viewing

#### **toggleterm.nvim**
- **Purpose**: Better terminal integration
- **Key mappings**:
  - `<C-\>` - Toggle floating terminal
  - `<leader>lg` - LazyGit integration
  - `<leader>th` - Horizontal terminal
  - `<leader>tv` - Vertical terminal
- **Features**: Multiple terminals, LazyGit integration
- **Usage**: Seamless terminal access within Neovim

### Text Manipulation Plugins

#### **nvim-surround**
- **Purpose**: Professional text surrounding functionality
- **Key mappings**:
  - **Normal mode**:
    - `ys{motion}{char}` - Surround motion with character
    - `ysiw(` - Surround word with parentheses
    - `yss"` - Surround line with quotes
    - `cs{old}{new}` - Change surrounding
    - `ds{char}` - Delete surrounding
  - **Visual mode**:
    - `S{char}` - Surround selection
    - `<M-e>` - Alternative surround key
  - **Quick shortcuts**:
    - `<leader>ws` - Surround word under cursor
    - `<leader>wl` - Surround entire line
    - `<leader>w(` - Surround with parentheses
    - `<leader>w[` - Surround with brackets
    - `<leader>w{` - Surround with braces
    - `<leader>w"` - Surround with double quotes
    - `<leader>w'` - Surround with single quotes
    - `<leader>w`` - Surround with backticks
- **Usage**: Select text and press `S` then desired character

### Note-Taking and Documentation Plugins

#### **obsidian.nvim** (NEW)
- **Purpose**: Complete Obsidian-style note-taking in Neovim
- **Workspaces**: 
  - `~/Documents/Notes` (personal)
  - `~/Documents/Work-Notes` (work)
- **Key mappings**:
  - `<leader>on` - New note
  - `<leader>oo` - Open in Obsidian app
  - `<leader>os` - Search notes
  - `<leader>ot` - Today's daily note
  - `<leader>oy` - Yesterday's daily note
  - `<leader>oT` - Tomorrow's daily note
  - `<leader>od` - Browse daily notes
  - `<leader>oq` - Quick switch between notes
  - `<leader>ol` - Insert/create link
  - `<leader>oL` - Create new linked note
  - `<leader>ow` - Switch workspace
  - `<leader>op` - Paste image
  - `<leader>or` - Rename note
  - `<leader>of` - Follow link under cursor
  - `<leader>ob` - Go back/smart action
  - `<leader>oc` - Toggle checkbox
  - `<leader>otg` - Browse tags
  - `<leader>obl` - Show backlinks
  - `<leader>otp` - Insert template
- **Features**:
  - Wiki-style linking `[[note-name]]`
  - Daily notes with templates
  - Tag support `#tag`
  - Checkbox handling `- [ ]` / `- [x]`
  - Image paste support
  - Frontmatter management  
  - Telescope integration
  - Auto-completion for links and tags
  - Beautiful UI with custom highlighting
- **Templates**: Store in `~/Documents/Notes/templates/`
- **Images**: Auto-saved to `~/Documents/Notes/assets/imgs/`
- **Usage**: Perfect for Zettelkasten, daily journaling, project notes

## Custom Modules

### 1. Multi-Edit (`lua/custom/multi-edit/`)
**Purpose**: Pattern-based multi-cursor editing and manipulation

**Features**:
- Pattern matching with Lua regex support
- Word boundary support (NEW)
- Operations: delete, replace, highlight
- Visual selection support

**Keybindings**:
- `<leader>md` - Delete all matches
- `<leader>mr` - Replace all matches
- `<leader>mh` - Highlight all matches
- `<leader>mwd` - Delete word matches only (NEW)
- `<leader>mwr` - Replace word matches only (NEW)
- Visual mode: `<leader>md/mr/mh` - Operate on visual selection

**How Word Boundaries Work**:
- When prompted "Word boundaries only? (y/n)", answering "y" adds `\\<` and `\\>` to your pattern
- Example: searching for "test" becomes "\\<test\\>" which only matches whole words
- `<leader>mwr` automatically uses word boundaries

### 2. Text Manipulation (`lua/custom/text-manipulation/`)
**Purpose**: Advanced text transformation utilities

**Features**:
- Case conversion (snake_case, camelCase, PascalCase, kebab-case, UPPER, lower)
- Smart line joining based on context
- Text sorting (normal/reverse)
- Text alignment by character
- Text wrapping with brackets/quotes
- Number increment/decrement in selections

**Keybindings**:
- `<leader>cs/cc/cp/ck/cu/cl` - Case conversions (visual mode)
- `gJ` - Smart join lines
- `<leader>ss/sr` - Sort selection (normal/reverse)
- `<leader>a` - Align text by character
- `<leader>w(` - Wrap with parentheses (visual mode)
- `<C-a>/<C-x>` - Increment/decrement numbers (visual mode)

### 3. Quick Actions (`lua/custom/quick-actions/`)
**Purpose**: Rapid file and buffer operations

**Features**:
- Line duplication
- Whitespace management
- Buffer operations
- Smart LSP rename
- File execution by type
- Path/name copying
- Quickfix toggle

**Keybindings**:
- `<leader>qd` - Duplicate line
- `<leader>qb` - Delete blank lines
- `<leader>qw` - Strip trailing whitespace
- `<leader>ql` - Goto last change
- `<leader>qo` - Close other buffers
- `<leader>qr` - Smart rename (LSP)
- `<leader>qx` - Execute current file
- `<leader>qp/qn` - Copy file path/name
- `<leader>qq` - Toggle quickfix

### 4. Smart Navigation (`lua/custom/smart-navigation/`)
**Purpose**: Enhanced movement and positioning

**Features**:
- Named marks with descriptions
- Jump history management
- Function/class navigation
- Smart bracket matching
- Auto jump history tracking

**Keybindings**:
- `<leader>nm` - Set named mark
- `<leader>nl` - List named marks
- `]f/[f` - Next/previous function
- `<M-Left>/<M-Right>` - Navigate jump history
- `<leader>%` - Smart bracket jump

### 5. Advanced Search (`lua/custom/advanced-search/`)
**Purpose**: Enhanced search and replace capabilities

**Features**:
- Visual selection search
- Interactive search/replace with preview
- Project-wide search
- Multi-buffer search
- Search history
- Selection expansion

**Keybindings**:
- `*` (visual mode) - Search for visual selection
- `<leader>sr` - Search/replace with preview
- `<leader>sp` - Project search
- `<leader>sb` - Search all buffers
- `<leader>sh` - Search history
- `<C-Space>` - Expand selection

### 6. Smart Window Management (`lua/custom/smart-splits/`)
**Purpose**: Intelligent window handling

**Features**:
- Smart splitting based on dimensions
- Window zoom toggle
- Smart navigation with auto-creation
- Window swapping
- Auto-resize on window changes

**Keybindings**:
- `<leader>ws` - Smart split
- `<leader>wz` - Toggle zoom
- `<C-A-h/j/k/l>` - Smart move (creates if needed)
- `<leader>wh/j/k/l>` - Swap windows

### 7. Git Enhanced (`lua/custom/git-enhanced/`)
**Purpose**: Advanced Git workflow integration

**Features**:
- Line-level git blame
- Interactive hunk staging
- File history time machine
- Conventional commits
- Stash management
- Cherry-pick helper

**Keybindings**:
- `<leader>gb` - Git blame line
- `<leader>gt` - Git time machine
- `<leader>gc` - Quick commit (conventional)
- `<leader>gS` - Stash menu
- `<leader>gp` - Cherry-pick
- `<leader>hs` - Stage hunk
- `<leader>gd` - Git diffview (NEW)
- `<leader>gh` - Git history (NEW)
- `<leader>lg` - LazyGit integration (NEW)

### 8. Session Management (`lua/custom/sessions/`)
**Purpose**: Project-based session persistence

**Features**:
- Automatic session naming by directory
- Session listing and selection
- Auto-save toggle
- Session deletion
- Exit auto-save

**Keybindings**:
- `<leader>Ss` - Save session
- `<leader>Sl` - List sessions
- `<leader>Sa` - Toggle auto-save

**Commands**:
- `:SessionSave [name]`
- `:SessionLoad [name]`
- `:SessionList`
- `:SessionDelete`

### 9. Refactoring Tools (`lua/custom/refactoring/`)
**Purpose**: Code refactoring utilities

**Features**:
- Extract variable from selection
- Extract function from selection
- Inline variable
- Toggle function styles (arrow ↔ regular)
- Language-aware syntax

**Keybindings**:
- `<leader>rv` - Extract variable (visual mode)
- `<leader>rf` - Extract function (visual mode)
- `<leader>ri` - Inline variable
- `<leader>rt` - Toggle function style

**Supported Languages**:
- JavaScript/TypeScript
- Python
- Lua
- Go
- Generic fallback

## Treesitter Explanation

### What is Treesitter?
**Treesitter** is a parser generator and incremental parsing library that builds concrete syntax trees for your code. Think of it as a super-smart way to understand code structure.

### What it does:
1. **Syntax Highlighting**: More accurate than regex-based highlighting
2. **Code Structure Understanding**: Knows about functions, classes, variables, etc.
3. **Text Objects**: Can select/manipulate code constructs intelligently
4. **Folding**: Understands code blocks for smart folding
5. **Navigation**: Jump between functions, classes, etc.

### New Treesitter Text Objects Added:
- `af` - **A**round **F**unction (includes function signature + body)
- `if` - **I**nside **F**unction (function body only)
- `ac` - **A**round **C**lass (entire class definition)
- `ic` - **I**nside **C**lass (class body only)
- `aa` - **A**round **A**rgument/parameter
- `ia` - **I**nside **A**rgument/parameter
- `ab` - **A**round **B**lock (code block)
- `ib` - **I**nside **B**lock

### Usage Examples:
```vim
" Select entire function
vaf

" Delete function body
dif

" Change function parameter
cia

" Copy entire class
yac

" Navigate to next function
]f

" Navigate to previous class
[c

" Swap current parameter with next
<leader>sa
```

## Text Wrapping/Surrounding Functionality

### nvim-surround Plugin (NEW & RELIABLE)
**Professional-grade surround functionality** using the popular nvim-surround plugin:

### Visual Mode Surrounding
1. **Select text in visual mode**
2. **Press `S`** (capital S)
3. **Type the character** you want to surround with: `(`, `[`, `{`, `"`, `'`, etc.
4. Text gets surrounded automatically

**Examples**:
```
Before: hello world (selected in visual mode)
Press S then (
After: (hello world)

Before: hello world (selected)
Press S then "
After: "hello world"
```

### Quick Visual Shortcuts
**Status**: ✅ Working as of latest update

For instant surrounding in visual mode:
- `<leader>w(` → `(text)` 
- `<leader>w[` → `[text]`  
- `<leader>w{` → `{text}`
- `<leader>w"` → `"text"`
- `<leader>w'` → `'text'`
- `<leader>w\`` → `` `text` ``
- `<M-e>` → Same as `S` (alternative key)

**Note**: After restart, you should see a notification "Custom surround shortcuts loaded!" confirming these work.

### Normal Mode Surrounding
- `ys` + motion + character → Surround motion with character
  - `ysiw(` → Surround word with ()
  - `yss"` → Surround entire line with ""
- `<leader>ws` → Quick surround word under cursor
- `<leader>wl` → Quick surround line

### Change/Delete Surrounding
- `cs` + old + new → Change surrounding
  - `cs"'` → Change " to '
  - `cs({` → Change ( to {
- `ds` + character → Delete surrounding
  - `ds"` → Remove surrounding quotes
  - `ds)` → Remove surrounding parentheses

### Advanced Examples
```vim
" Surround word with parentheses
ysiw)

" Surround inside parentheses with quotes  
ysi)"

" Change surrounding quotes to brackets
cs"[

" Delete surrounding brackets
ds[

" Surround line with braces
yss}
```

## Key Leader Mappings Summary

### File Operations
- `<leader>e/E` - Neo-tree toggle/reveal
- `<leader>fb/fB` - File browser
- `<leader>fp` - Find projects
- `<leader>f` - Format buffer

### Search Operations
- `<leader>s*` - Various search functions
- `<leader>S` - Advanced search/replace (Spectre)
- `<leader>/` - Buffer fuzzy search

### Multi-Edit
- `<leader>m*` - Multi-edit operations
- `<leader>mw*` - Word-only multi-edit

### Quick Actions
- `<leader>q*` - Quick file/buffer operations

### Text Manipulation
- `<leader>c*` - Case conversions
- `<leader>w*` - Text wrapping
- `<leader>a` - Text alignment

### Git Operations
- `<leader>g*` - Git operations
- `<leader>h*` - Git hunk operations

### Navigation
- `<leader>n*` - Named marks
- `<leader>%` - Smart bracket jump

### Refactoring
- `<leader>r*` - Refactoring operations

### Sessions
- `<leader>S*` - Session operations

### Diagnostics & Debugging
- `<leader>x*` - Trouble diagnostics
- `<leader>d*` - Debug operations

### Terminal
- `<leader>t*` - Terminal operations
- `<leader>lg` - LazyGit

### Window Management
- `<leader>w*` - Window operations

## Installation & Setup

1. **Install dependencies**:
   ```bash
   brew install lazygit ripgrep fd make
   ```

2. **Restart Neovim** - Lazy.nvim will auto-install plugins

3. **Run health checks**:
   ```vim
   :checkhealth
   ```

4. **Install LSP servers** (optional):
   ```vim
   :Mason
   ```

## Troubleshooting

### LazyGit Issues
- **Install lazygit**: `brew install lazygit`
- **Check PATH**: `which lazygit` should return a path
- **Alternative**: Use `<leader>gg` for Neogit instead

### Plugin Issues
- **Lazy status**: `:Lazy` to see plugin status
- **Reload config**: `:source %` in init.lua
- **Clean install**: `:Lazy clean` then `:Lazy sync`

### Performance Issues
- **Check startup time**: `nvim --startuptime startup.log`
- **Disable heavy plugins**: Comment out in plugin files
- **Profile**: `:profile start profile.log | profile func * | profile file *`

## Customization

### Adding New Plugins
1. Create new file in `lua/custom/plugins/`
2. Return plugin spec table
3. Restart Neovim

### Modifying Keybindings
1. Edit relevant module in `lua/custom/[module]/init.lua`
2. Modify the `setup()` function
3. `:source %` to reload

### Adding Custom Functions
1. Add to appropriate module or create new one
2. Follow existing patterns
3. Document in this file

## Performance Optimization

- **Lazy loading**: Most plugins load on events/commands
- **Treesitter**: Only enabled parsers are loaded
- **LSP**: Only attached when file types match
- **Caching**: Plugin specs cached for faster startup

## Backup & Sync

**Important files to backup**:
- `~/.config/nvim/` (entire directory)
- `lazy-lock.json` (for reproducible installs)

**Sync across machines**:
```bash
# Backup
cp ~/.config/nvim/lazy-lock.json ~/backup/

# Restore  
cp ~/backup/lazy-lock.json ~/.config/nvim/
nvim --headless -c 'Lazy! restore' -c 'qa'
```

## Additional Resources

- **Kickstart.nvim**: https://github.com/nvim-lua/kickstart.nvim
- **Plugin docs**: `:help plugin-name` for most plugins
- **Lua guide**: `:help lua-guide`
- **Treesitter**: `:help nvim-treesitter`
- **LSP**: `:help lsp`

---

*This configuration is designed for maximum productivity with minimal learning curve. All custom modules follow consistent patterns and are thoroughly documented.*
