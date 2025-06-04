return {
  -- {
  --   "folke/tokyonight.nvim",
  -- lazy = false, -- make sure we load this during startup if it is your main colorscheme
  -- priority = 1000, -- make sure to load this before all the other start plugings
  --   -- opts = { style = "moon" },
  -- config = function()
  -- 	require("tokyonight").load({ style = "moon" }) -- one line implementation of above
  --   end
  -- },

  {
    "rebelot/kanagawa.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugings
    config = function()
      require("kanagawa")
      .setup({
        compile = true,
        -- transparent = true
        overrides = function(colors)
          return {
            ["@markup.link.url.markdown_inline"] = { link = "Special" }, -- (url)
            ["@markup.link.label.markdown_inline"] = { link = "WarningMsg" }, -- [label]
            ["@markup.italic.markdown_inline"] = { link = "Exception" }, -- *italic*
            ["@markup.raw.markdown_inline"] = { link = "String" }, -- `code`
            ["@markup.list.markdown"] = { link = "Function" }, -- + list
            ["@markup.quote.markdown"] = { link = "Error" }, -- > blockcode
          }
      end
      });
      require("kanagawa").load("wave") -- dragon, lotus
    end,
    build = function()
      vim.cmd("KanagawaCompile");
    end,
  },
}
