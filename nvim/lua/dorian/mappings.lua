vim.keymap.set("n", "<leader>pv", vim.cmd.Ex) -- netrw go to prev window
vim.keymap.set("n", "Space", "<Nop>")

vim.keymap.set("n", "<ESC>", "<cmd> noh <CR>")

-- window navigation
-- vim.keymap.set("n", "<C-h>", "<C-w>h")
-- vim.keymap.set("n", "<C-l>", "<C-w>l")
-- vim.keymap.set("n", "<C-j>", "<C-w>j")
-- vim.keymap.set("n", "<C-k>", "<C-w>k")


vim.keymap.set("n", "<leader>h", "<cmd> bprev <CR>")
vim.keymap.set("n", "<leader>l", "<cmd> bnext <CR>")

-- vim.keymap.set("n", "<C-s>", "<cmd> w <CR>") -- Save file
-- vim.keymap.set("n", "<C-c>", "<cmd> %y+ <CR>") -- Copy entire file

vim.keymap.set("n", "<leader>n", "<cmd> set nu! <CR>") -- Toggle line numbers
vim.keymap.set("n", "<leader>rn", "<cmd> set rnu! <CR>") -- Toggle relative line numbers

-- Allow movement through wrapped lines
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Move highlighted text in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z") -- Append line below and keep cursor in place

-- Keep cursor centered when half-page hopping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Keep searched text centered when jumping
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]]) -- Paste over highlighted text without overwriting clipboard

-- Copy to vim clipboard vs system clipboard (Need to turn clipboard setting off in vim settings)
-- vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Delete to void register
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Replace word currently on in current file
-- vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- fugitive
vim.keymap.set("n", "<leader>gg", "<cmd>:G<CR>")
vim.keymap.set("n", "<leader>gd", "<cmd>:Gdiff<CR>")
vim.keymap.set("n", "<leader>gv", "<cmd>:Gvdiffsplit<CR>")
vim.keymap.set("n", "<leader>gb", "<cmd>:G blame<CR>")
vim.keymap.set("n", "<leader>gp", "<cmd>:G push<CR>")
vim.keymap.set("n", "<leader>gP", "<cmd>:G push --force-with-lease<CR>")

-- undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- trouble.nvim diagnostics
vim.keymap.set("n", "<leader>q", "<cmd>TroubleToggle quickfix<CR>")

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>")

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")


-- Highlight when yanking
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

