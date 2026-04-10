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
				markdown = { "prettierd", "prettier", stop_after_first = true, "markdownlint-cli2", "markdown-toc" },
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
				["markdownlint-cli2"] = {
					condition = function(_, ctx)
						local diag = vim.tbl_filter(function(d)
							return d.source == "markdownlint"
						end, vim.diagnostic.get(ctx.buf))
						return #diag > 0
					end,
				},
				["markdown-toc"] = {
					condition = function(_, ctx)
						for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
							if line:find("<!%-%- toc %-%->") then
								return true
							end
						end
						return false
					end,
				},
			},
		},
	},
}
