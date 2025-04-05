require("zen-mode").setup {
  window = {
    width = .6,
    options = {
    },
  },
}

vim.keymap.set("n", "<leader>zz", function()
  require("zen-mode").toggle()
end)
