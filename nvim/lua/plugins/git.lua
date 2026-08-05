return {
	{
		"NeogitOrg/neogit",
		dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
		keys = { { "<leader>gg", function() require("neogit").open() end, desc = "Neogit" } },
	},
	{
		"tpope/vim-fugitive",
		keys = {
			{ "<leader>gb", "<cmd>Git blame<cr>", desc = "Git Blame (Fugitive)" },
			{ "<leader>gd", "<cmd>Gvdiffsplit<cr>", desc = "Git Diff Split (Fugitive)" },
		},
	},
	{
		-- Adds git releated signs to the gutter & utilities for managing changes
		"lewis6991/gitsigns.nvim",
		event = "BufWinEnter",
    opts = { current_line_blame = true },  -- who last touched this line
	},
}
