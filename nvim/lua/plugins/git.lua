return {
	{
		"NeogitOrg/neogit",
		dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
		keys = {
			{ "<leader>gg", function() require("neogit").open() end, desc = "Neogit" },
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
			{ "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
		},
	},
	{
		"tpope/vim-fugitive",
		keys = {
			{ "<leader>gb", "<cmd>Git blame<cr>", desc = "Git Blame (Fugitive)" },
		},
	},
	{
		-- Adds git releated signs to the gutter & utilities for managing changes
		"lewis6991/gitsigns.nvim",
		event = "BufWinEnter",
    opts = { current_line_blame = true },  -- who last touched this line
	},
}
