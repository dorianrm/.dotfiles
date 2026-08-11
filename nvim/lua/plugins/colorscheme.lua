return {
	-- {
	--   "folke/tokyonight.nvim",
	-- lazy = false, -- make sure we load this during startup if it is your main colorscheme
	-- priority = 1000, -- make sure to load this before all the other start plugings
	--   -- opts = { style = "moon" },
	-- config = function()
	-- 	require("tokyonight").load({ style = "moon" }) -- one line implementation of above
	--   end
	-- },

	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				compile = true,
				theme = "wave", -- Set the theme here instead
				transparent = true,
				overrides = function(colors)
					return {
						["@markup.link.url.markdown_inline"] = { link = "Special" },
						["@markup.link.label.markdown_inline"] = { link = "WarningMsg" },
						["@markup.italic.markdown_inline"] = { link = "Exception" },
						["@markup.raw.markdown_inline"] = { link = "String" },
						["@markup.list.markdown"] = { link = "Function" },
						["@markup.quote.markdown"] = { link = "Error" },
					}
				end,
			})
			vim.cmd("colorscheme kanagawa") -- Use this instead of load()
			-- Force visual highlight after colorscheme loads
			vim.api.nvim_set_hl(0, "Visual", { bg = "#7a4f7e", blend = 99 })
		end,
		build = function()
			vim.cmd("KanagawaCompile")
		end,
	},
}
