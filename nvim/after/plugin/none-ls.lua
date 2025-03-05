local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.isort,

		null_ls.builtins.diagnostics.mypy,
		null_ls.builtins.diagnostics.ruff,
		null_ls.builtins.diagnostics.alex,

		null_ls.builtins.completion.luasnip,
		null_ls.builtins.completion.spell,
	},
})

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
