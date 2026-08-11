return {
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				disable_netrw = true,
				hijack_cursor = true,
				view = {
					width = { min = 30 },
				},
				update_focused_file = {
					enable = true,
				},
				renderer = {
					group_empty = true, -- collapse empty dirs
				},
			})
			vim.keymap.set("n", "<leader>e", "<cmd> NvimTreeToggle <CR>")
		end,
	},
}
