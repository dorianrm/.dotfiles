return {
  cmd = {'lua-language-server'},
  filetypes = {'lua'},
  root_markers = {'.luarc.json', '.luarc.jsonc'},
}

-- Equivalent to:
-- vim.lsp.config('luals', { <- filename
--   cmd = {'lua-language-server'},
--   filetypes = {'lua'},
--   root_markers = {'.luarc.json', '.luarc.jsonc'},
-- })
