local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup({
  settings = {
    save_on_toggle = true,
  }
})
-- REQUIRED

harpoon:extend({
  UI_CREATE = function(cx)
    vim.keymap.set("n", "<C-v>", function()
      harpoon.ui:select_menu_item({ vsplit = true })
    end, { buffer = cx.bufnr })

    vim.keymap.set("n", "<C-x>", function()
      harpoon.ui:select_menu_item({ split = true })
    end, { buffer = cx.bufnr })
  end,
})

local toggle_opts = {
    height_in_lines = 10,
    ui_width_ratio = 0.85
}

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list(), toggle_opts) end)

vim.keymap.set("n", "<C-j>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-k>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-l>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-;>", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<C-,>", function() harpoon:list():select(5) end)
vim.keymap.set("n", "<C-m>", function() harpoon:list():select(6) end)
