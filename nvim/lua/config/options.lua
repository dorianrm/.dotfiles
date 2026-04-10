-- Numbers
vim.o.number = true
vim.o.relativenumber = true
vim.numberwidth = 2

-- Indenting
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.breakindent = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true

vim.o.termguicolors = true

vim.o.scrolloff = 10
vim.o.sidescrolloff = 15
vim.o.signcolumn = "yes"

vim.o.updatetime = 50
vim.o.timeoutlen = 300

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.colorcolumn = "80"

vim.o.clipboard = "unnamedplus"

vim.o.autoread = true

-- views can only be fully collapsed with the global statusline
vim.o.laststatus = 3

-- Highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank()
	end,
})

-- vim.diagnostic.config({
--     severity_sort = true,
--     virtual_text = true,
--     virtual_lines = {
--         current_line = true,
--     }
-- })

vim.diagnostic.config({
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	virtual_text = {
		spacing = 4,
		source = "if_many",
		prefix = "●",
	},
	float = { border = "rounded", source = "if_many" },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
})

-- Inlay hints
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
		end
	end,
})

-- -- Autocomplete
-- vim.api.nvim_create_autocmd('LspAttach', {
--   callback = function(ev)
--     local client = vim.lsp.get_client_by_id(ev.data.client_id)
--     if client:supports_method('textDocument/completion') then
--       vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
--     end
--   end,
-- })
-- Prevent autocompletion from being annoying
vim.cmd("set completeopt+=noselect")

-- Custom visual selection highlight
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		-- Light translucent pink options:
		-- vim.api.nvim_set_hl(0, "Visual", { bg = "#5a2f5e" }) -- Light translucent pink
		-- vim.api.nvim_set_hl(0, "Visual", { bg = "#6a3f6e" }) -- Lighter pink
		vim.api.nvim_set_hl(0, "Visual", { bg = "#7a4f7e" }) -- Even lighter
		-- vim.api.nvim_set_hl(0, "Visual", { bg = "#8a5f8e" }) -- Very light pink
	end,
})
