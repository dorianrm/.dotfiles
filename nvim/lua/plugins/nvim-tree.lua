return {
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
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
      vim.keymap.set("n", "<leader>e", "<cmd> NvimTreeToggle <CR>")
    end
	}
}
