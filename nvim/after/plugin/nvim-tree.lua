require('nvim-tree').setup({
    disable_netrw = true,
    hijack_netrw = true,
    hijack_cursor = true,
    view = {
        adaptive_size = true,
    },
    update_focused_file = {
        enable = true,
    },
    renderer = {
      group_empty = true, -- collapse emtpy dirs
    },
    -- git = {
    --   ignore = false,
    -- },
})

-- toggle
-- vim.keymap.set("n", "<C-n>", "<cmd> NvimTreeToggle <CR>")

-- focus
vim.keymap.set("n", "<leader>e", "<cmd> NvimTreeToggle <CR>")
-- vim.keymap.set("n", "<leader>e", "<cmd> NvimTreeFocus <CR>")

