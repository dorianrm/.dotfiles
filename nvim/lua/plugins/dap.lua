-- require('dap').setup()
require('dapui').setup()
require('nvim-dap-virtual-text').setup()
vim.fn.sign_define('DapBreakpoint', { text='🔴', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })

-- Debugger
vim.keymap.set("n", "<leader>dt", "<cmd> lua require('dapui').toggle() <CR>")
-- vim.api.nvim_set_keymap("n", "<leader>dr", ":lua require('dapui').open({reset = true})<CR>", {noremap=true})

vim.api.nvim_set_keymap("n", "<leader>db", ":DapToggleBreakpoint<CR>", {noremap=true})
vim.api.nvim_set_keymap("n", "<leader>dc", ":DapContinue<CR>", {noremap=true})
vim.api.nvim_set_keymap("n", "<leader>di", ":DapStepInto<CR>", {noremap=true})
vim.api.nvim_set_keymap("n", "<leader>do", ":DapStepOver<CR>", {noremap=true})
vim.api.nvim_set_keymap("n", "<leader>du", ":DapStepOut<CR>", {noremap=true})
vim.api.nvim_set_keymap("n", "<leader>dr", ":DapToggleRepl<CR>", {noremap=true})
vim.api.nvim_set_keymap("n", "<leader>dq", ":DapTerminate<CR>", {noremap=true})
