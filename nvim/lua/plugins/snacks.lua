return {
	{
		"folke/snacks.nvim",
		lazy = false,
		opts = {
			git = { enabled = true },
			lazygit = {
				configure = true,
				config = {
					os = { editPreset = "nvim-remote" },
					gui = { nerdFontsVersion = "3" },
				},
			},
		},
		keys = {
			{ "<leader>gzz", function() Snacks.lazygit({ cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1] }) end, desc = "Lazygit (Root Dir)" },
			{ "<leader>gzc", function() Snacks.lazygit() end, desc = "Lazygit (cwd)" },
			{ "<leader>gzf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
			{ "<leader>gzb", function() Snacks.git.blame_line() end, desc = "Lazygit Blame Line" },
			{ "<leader>gzl", function() Snacks.lazygit.log() end, desc = "Lazygit Log" },
		},
	},
}
