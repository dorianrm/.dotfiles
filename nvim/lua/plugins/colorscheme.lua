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
				-- transparent = true
				overrides = function(colors)
					local c = require("kanagawa.lib.color")
					-- Options for visual selection colors:
					-- Blue: local visual_color = c("#4A90E2"):blend(colors.theme.ui.bg, 0.8):to_hex()
					-- Green: local visual_color = c("#7CB342"):blend(colors.theme.ui.bg, 0.8):to_hex()
					-- Orange: local visual_color = c("#FF9800"):blend(colors.theme.ui.bg, 0.8):to_hex()
					-- Purple: local visual_color = c("#9C27B0"):blend(colors.theme.ui.bg, 0.8):to_hex()
					-- Current pink (more vibrant): 
					local visual_color = c("#FF69B4"):blend(colors.theme.ui.bg, 0.1):to_hex()
					
					return {
						["@markup.link.url.markdown_inline"] = { link = "Special" },
						["@markup.link.label.markdown_inline"] = { link = "WarningMsg" },
						["@markup.italic.markdown_inline"] = { link = "Exception" },
						["@markup.raw.markdown_inline"] = { link = "String" },
						["@markup.list.markdown"] = { link = "Function" },
						["@markup.quote.markdown"] = { link = "Error" },
						Visual = { bg = visual_color },
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
