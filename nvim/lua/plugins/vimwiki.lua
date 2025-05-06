return {
	{
		-- Note taking app
		"vimwiki/vimwiki",
		init = function() --replace 'config' with 'init'
			vim.g.vimwiki_list = { { path = "~/vimwiki/", syntax = "markdown", ext = ".md" } }
			vim.g.vimwiki_global_ext = 0
		end,
	}
}
