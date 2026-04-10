return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()

			local ensure_installed = {
				-- lsp
				"bash-language-server",
				"gopls",
				"graphql-language-service-cli",
				"jdtls",
				"lua-language-server",
				"marksman",
				"pyright",
				"spring-boot-tools",
				"terraform-ls",
				"typescript-language-server",
				"yaml-language-server",
				-- formatters
				"black",
				"gofumpt",
				"isort",
				"prettier",
				"stylua",
				"xmlformatter",
				"yamlfmt",
				-- linters
				"flake8",
				"golangci-lint",
				"markdownlint-cli2",
				"markdown-toc",
				"mypy",
				"ruff",
				-- java
				"java-debug-adapter",
				"java-test",
				"lombok-nightly",
				"openjdk-17",
			}

			local mr = require("mason-registry")
			mr:on("refresh", function()
				for _, tool in ipairs(ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end)
			if mr.refresh then
				mr.refresh()
			end
		end,
	},
}
