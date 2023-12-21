--[[

Fix Errors:
1. Open lazy package manager using :Lazy
2. DO NOT GO TO UPDATE (U) TAB
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
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {

  {
    -- 'folke/tokyonight.nvim',
    'rebelot/kanagawa.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugings
    config = function()
      -- local tokyonight = require("tokyonight")
      -- tokyonight.setup({
      --   style = "moon"
      -- })
      -- tokyonight.load()
      -- require("tokyonight").load({ style = "moon" }) -- one line implementation of above

      require("kanagawa").load("wave")
    end,
  },

  {
    -- Statusline - Lualine
    'nvim-lualine/lualine.nvim',
    config = function()
      require("lualine").setup({
        options = {
          theme = 'powerline_dark',
          component_separators = '|',
          section_separators = '',
        },
        sections = {
          lualine_x = { 'encoding', 'filetype' },
        },
      })
    end,
  },

  {
    -- Lsp, cmp, snippets
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' }, -- Required
      {
        -- Optional
        'williamboman/mason.nvim',
        build = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },         -- Required
      { 'hrsh7th/cmp-nvim-lsp' },     -- Required
      { 'hrsh7th/cmp-buffer' },       -- Optional
      { 'hrsh7th/cmp-path' },         -- Optional
      { 'saadparwaiz1/cmp_luasnip' }, -- Optional
      { 'hrsh7th/cmp-nvim-lua' },     -- Optional

      -- Snippets
      {
        'L3MON4D3/LuaSnip',                                -- Required
        dependencies = { 'rafamadriz/friendly-snippets' }, -- Optional
      },
    }
  },

  -- {
  --   -- Lsp, cmp, snippets
  --   'VonHeikemen/lsp-zero.nvim',
  --   branch = 'v1.x',
  --   dependencies = {
  --     -- LSP Support
  --     { 'neovim/nvim-lspconfig' },             -- Required
  --     { 'williamboman/mason.nvim' },           -- Optional
  --     { 'williamboman/mason-lspconfig.nvim' }, -- Optional
  --
  --     -- Autocompletion
  --     { 'hrsh7th/nvim-cmp' },         -- Required
  --     { 'hrsh7th/cmp-nvim-lsp' },     -- Required
  --     { 'hrsh7th/cmp-buffer' },       -- Optional
  --     { 'hrsh7th/cmp-path' },         -- Optional
  --     { 'saadparwaiz1/cmp_luasnip' }, -- Optional
  --     { 'hrsh7th/cmp-nvim-lua' },     -- Optional
  --
  --     -- Snippets
  --     { 'L3MON4D3/LuaSnip' },             -- Required
  --     { 'rafamadriz/friendly-snippets' }, -- Optional
  --   }
  -- },

  {
    -- Add indentationguides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    config = function()
      require("ibl").setup({})
    end,
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',          opts = {} },
  -- Use :checkhealth which-key to display conflicting keymaps
  -- z= on word for spelling suggestions, ' for marks, " for registers

  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- Easy comment keybinds
  { 'numToStr/Comment.nvim', opts = {}, lazy = false, },

  -- Finder
  { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },
  {
    -- Add fuzzy finding to search in telescope
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      -- 'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-context',
    },
    config = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  },

  -- Folder dir window
  { "nvim-tree/nvim-tree.lua", version = "*", dependencies = { "nvim-tree/nvim-web-devicons" } },

  {
    -- Note taking app
    'vimwiki/vimwiki',
    init = function() --replace 'config' with 'init'
      vim.g.vimwiki_list = { { path = '~/vimwiki/', syntax = 'markdown', ext = '.md' } }
      vim.g.vimwiki_global_ext = 0
    end
  },

  -- Oil lathered slipping and slidin
  { "theprimeagen/harpoon",    opts = {} },

  -- Auto type closing char
  -- { "windwp/nvim-autopairs", opts = {} },

  { "folke/zen-mode.nvim" },
  { "folke/trouble.nvim" },

  { "tpope/vim-fugitive" },

  { "mbbill/undotree" },

}

require("lazy").setup(plugins, opts)
