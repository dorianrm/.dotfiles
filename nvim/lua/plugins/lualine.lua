return {
	{
		-- Statusline - Lualine
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					theme = "auto",
					-- theme = "powerline_dark",
					component_separators = "|",
					section_separators = "",
					globalstatus = true, -- Single status line regardless of number of splits
				},
				sections = {
					lualine_x = { "filetype" },
				},
			})
		end
	}
}
