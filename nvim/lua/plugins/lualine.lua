return {
	{
		-- Statusline - Lualine
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					theme = "powerline_dark",
					component_separators = "|",
					section_separators = "",
				},
				sections = {
					lualine_x = { "encoding", "filetype" },
				},
			})
		end
	}
}
