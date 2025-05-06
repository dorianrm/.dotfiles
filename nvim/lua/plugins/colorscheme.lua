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
		-- 'folke/tokyonight.nvim',
		"rebelot/kanagawa.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugings
		config = function()
			require("kanagawa").load("wave")
		end,
	},
}
