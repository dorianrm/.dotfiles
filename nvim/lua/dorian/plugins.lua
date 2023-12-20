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
    -- 'navarasu/onedark.nvim',
    -- 'rose-pine/neovim',
    'folke/tokyonight.nvim',
    -- 'catppuccin/nvim',
    lazy = false,
    priority = 1000,

    config = function(_, opts)
      local tokyonight = require("tokyonight")
      tokyonight.setup({
        style = "moon"
      })
      tokyonight.load()

      -- local rosepine = require("rose-pine")
      -- rosepine.setup({
      --     variant = 'moon'
      -- })
      -- vim.cmd.colorscheme 'rose-pine'

      -- require("catppuccin").setup()
      -- vim.cmd.colorscheme 'catppuccin-macchiato'
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        theme = 'tokyonight',
        -- theme = 'rose-pine',
        -- theme = 'powerline',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_x = { 'encoding', 'filetype' },
      },
    },
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
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    opts = {
      -- show_trailing_blankline_indent = false,
      show_current_context = true,
      show_current_context_start = true,
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',          opts = {} },
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
  { 'numToStr/Comment.nvim',         opts = {} },

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
