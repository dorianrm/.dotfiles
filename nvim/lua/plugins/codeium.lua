return {
	{
		"Exafunction/codeium.vim",
		event = "BufEnter",
		config = function()
			vim.keymap.set("i", "<C-y>", function()
				return vim.fn["codeium#Accept"]()
			end, { expr = true, silent = true })
			vim.keymap.set("n", "<C-.>", function()
				return vim.fn["codeium#Chat"]()
			end, { expr = true, silent = true })
		end,
	}
}
