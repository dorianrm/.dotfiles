-- Numbers
vim.o.number = true -- show line number on cursor line
vim.o.relativenumber = true -- relative numbers elsewhere

-- Indenting
vim.o.expandtab = true -- spaces, not tabs
vim.o.shiftwidth = 2 -- columns per indent level
vim.o.tabstop = 2 -- columns per tab
vim.o.breakindent = true -- preserve indent on wrapped lines

-- search
vim.o.ignorecase = true -- search is case-insensitive by default
vim.o.smartcase = true -- case-sensitive only if search has a capital

-- screen
vim.o.scrolloff = 10 -- keep cursor away from top/bottom edge
vim.o.sidescrolloff = 15 -- keep cursor away from left/right edge
vim.o.signcolumn = "yes" -- always show sign column, no text shifting
vim.o.splitbelow = true -- horizontal splits open below
vim.o.splitright = true -- vertical splits open to the right

-- misc
vim.o.updatetime = 200 -- faster CursorHold / swap write / diagnostics
vim.o.timeoutlen = 300 -- faster mapped-sequence timeout (which-key etc)
vim.o.clipboard = "unnamedplus" -- share the system clipboard
vim.o.undofile = true -- persistent undo across sessions
vim.o.laststatus = 3 -- views can only be fully collapsed with the global statusline
vim.cmd("set completeopt+=noselect") -- Prevent autocompletion from being annoying

