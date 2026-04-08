return {
	{
		"tpope/vim-fugitive",
		keys = {
			{ "<leader>gg", "<cmd>Git<cr>", desc = "Git Status (Fugitive)" },
			{ "<leader>gb", "<cmd>Git blame<cr>", desc = "Git Blame (Fugitive)" },
			{ "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git Diff Split (Fugitive)" },
			{ "<leader>gl", "<cmd>Git log --oneline<cr>", desc = "Git Log (Fugitive)" },
		},
	},
}
