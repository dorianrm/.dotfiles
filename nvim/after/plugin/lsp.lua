-- local lsp = require('lsp-zero')
--
-- lsp.preset('recommended')
--
-- lsp.ensure_installed({
--   'tsserver',   -- Supports javascript
--   'rust_analyzer',
--   'terraformls',
--   'pyright',
--   'lemminx',   -- xml
--   'yamlls',
--   'html',
--   'lua_ls',
--   'graphql',
--   'prismals',
--   'bashls',
-- })
--
-- -- (Optional) Configure lua language server for neovim
-- lsp.nvim_workspace()
--
-- lsp.on_attach(function(client, bufnr)
--   local opts = { buffer = bufnr }
--
--   vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
--   vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
--   vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
--   vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
--   vim.keymap.set("n", "go", function() vim.lsp.buf.type_definition() end, opts)
--   vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
--   vim.keymap.set("n", "gh", function() vim.lsp.buf.signature_help() end, opts)
--   vim.keymap.set("n", "gn", function() vim.lsp.buf.rename() end, opts)
--   vim.keymap.set("n", "ga", function() vim.lsp.buf.code_action() end, opts)
--   vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end, opts)
--   vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
--   vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
-- end)
--
-- lsp.setup()


local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  -- lsp.default_keymaps({ buffer = bufnr })
  local opts = { buffer = bufnr }

  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
  vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
  vim.keymap.set("n", "go", function() vim.lsp.buf.type_definition() end, opts)
  vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "gh", function() vim.lsp.buf.signature_help() end, opts)
  vim.keymap.set("n", "gn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("n", "ga", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
end)

lsp.set_sign_icons({
  error = '✘',
  warn = '▲',
  hint = '⚑',
  info = '»'
})

-- (Optional) Configure lua language server for neovim
-- require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()




-- Make sure you setup `cmp` after lsp-zero

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
  mapping = {
    -- `Enter` key to confirm completion
    ['<CR>'] = cmp.mapping.confirm({ select = false }),

    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
  }
})
