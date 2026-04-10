return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()

			local ensure_installed = {
				"markdownlint-cli2",
				"markdown-toc",
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
