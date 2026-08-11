return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			vim.diagnostic.config({
				severity_sort = true,
				virtual_text = {
					source = "if_many",
					prefix = "●",
				},
				float = { border = "rounded", source = "if_many" },
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
					numhl = {
						[vim.diagnostic.severity.ERROR] = "DiagnosticError",
						[vim.diagnostic.severity.WARN] = "DiagnosticWarn",
						[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
						[vim.diagnostic.severity.HINT] = "DiagnosticHint",
					},
				},
			})
		end,
	},
}
