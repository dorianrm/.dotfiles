return {
	{
		"folke/snacks.nvim",
		lazy = false,
		opts = {
			lazygit = {
				configure = true,
				config = {
					os = { editPreset = "nvim-remote" },
					gui = { nerdFontsVersion = "3" },
				},
			},
		},
		keys = {
			{ "<leader>gg", function() Snacks.lazygit({ cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1] }) end, desc = "Lazygit (Root Dir)" },
			{ "<leader>gG", function() Snacks.lazygit() end, desc = "Lazygit (cwd)" },
			{ "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
			{ "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log" },
		},
	},
}
