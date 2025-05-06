--[[

Fix Errors:
1. Open lazy package manager using :Lazy
2. DO NOT GO TO UPDATE (U) or (S) SYNC tab
3. On the first lazy.nvim page hit 'u' on any package to update


What do to do when accidentally mass updating
1. Delete the 'nvim/lazy-lock.json' package from git changes
2. Open neovim
3. Open lazy (:Lazy)
4. Go to Restore Profile (R)

--]]

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		-- import your plugins from repo
		{ import = "plugins" },
	},
  install = { colorscheme = { "kanagawa" } },
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	-- automatically check for plugin updates
	checker = { enabled = false },
})
