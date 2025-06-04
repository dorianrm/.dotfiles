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

vim.g.codeium_no_map_tab = true

-- views can only be fully collapsed with the global statusline
vim.o.laststatus = 3

-- Highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.hl.on_yank()
    end,
})

vim.diagnostic.config({
    severity_sort = true,
    virtual_text = true,
    virtual_lines = {
        current_line = true,
    }
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
