require("config.lazy")
require("config")

vim.lsp.enable({
  'lua_ls',
  'ts_ls',
  'pyright',
  'terraformls',
  'graphql',
  'yamlls',
  'bashls',
  'jdtls',
  'java_language_server',
})
