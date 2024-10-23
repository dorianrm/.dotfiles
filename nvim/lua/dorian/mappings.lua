--[[
  Note: Use :verbose nmap to check all available keybindings in normal mode
  Check specific keymapping - :nmap <mapping>
  Can also use :Telescope keymaps
--]]

vim.keymap.set("n", "<ESC>", "<cmd> noh <CR>") -- Clear search highlights
vim.keymap.set("n", "Space", "<Nop>") -- Disable space key
vim.keymap.set("n", "Q", "<nop>") -- Disable Ex mode

-- Line number toggle settings
vim.keymap.set("n", "<leader>n", "<cmd> set nu! <CR>") -- Toggle line numbers
vim.keymap.set("n", "<leader>rn", "<cmd> set rnu! <CR>") -- Toggle relative line numbers

-- Allow movement through wrapped lines
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Move highlighted text in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor centered when half-page hopping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Keep searched text centered when jumping
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Register settings for pasting/deleting
vim.keymap.set("x", "<leader>p", [["_dP]]) -- Paste over highlighted text without overwriting clipboard
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]]) -- Delete to void register

-- fugitive (git)
vim.keymap.set("n", "<leader>gg", "<cmd>:G<CR>")
vim.keymap.set("n", "<leader>gd", "<cmd>:Gdiff<CR>")
vim.keymap.set("n", "<leader>gv", "<cmd>:Gvdiffsplit<CR>")
vim.keymap.set("n", "<leader>gb", "<cmd>:G blame<CR>")
vim.keymap.set("n", "<leader>gp", "<cmd>:G push<CR>")
vim.keymap.set("n", "<leader>gP", "<cmd>:G push --force-with-lease<CR>")

-- trouble.nvim diagnostics
vim.keymap.set("n", "<leader>q", function()
	require("trouble").toggle()
end)

vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>") -- Undo Tree

-- Highlight when yanking
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- Special mappings
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>") -- Make file executable
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>") -- Open tmux session

-- Replace word currently on in current file
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
