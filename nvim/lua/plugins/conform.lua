return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform will run multiple formatters sequentially
				python = { "black", "isort" },
				-- You can customize some of the format options for the filetype (:help conform.format)
				rust = { "rustfmt", lsp_format = "fallback" },
				-- Conform will run the first available formatter
				javascript = { "prettierd", "prettier", stop_after_first = true },
				go = { "gofumpt" },
				markdown = { "prettierd", "prettier", stop_after_first = true },
			},
			-- format_on_save = {
			-- 	-- These options will be passed to conform.format()
			-- 	timeout_ms = 2000,
			-- 	lsp_format = "fallback",
			-- },
			formatters = {
				black = {
					prepend_args = { "--line-length", "79" },
				},
				prettierd = {
					prepend_args = function(_, ctx)
						if vim.bo[ctx.buf].filetype == "markdown" then
							return { "--prose-wrap", "always", "--print-width", "120" }
						end
						return {}
					end,
				},
				prettier = {
					prepend_args = function(_, ctx)
						if vim.bo[ctx.buf].filetype == "markdown" then
							return { "--prose-wrap", "always", "--print-width", "120" }
						end
						return {}
					end,
				},
			},
		},
	},
}
