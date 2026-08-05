require("config.lazy")
require("config")

vim.lsp.enable({
  'lua_ls',
  'ts_ls',
  'pyright',
  'terraformls',
  'graphql',
  'intelephense',
  'yamlls',
  'bashls',
  'marksman',
  'gopls',
})
