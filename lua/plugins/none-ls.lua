-- Customize None-ls sources

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    -- Make sure opts.sources is always a table
    opts.sources = require("astrocore").list_insert_unique(opts.sources or {}, {
      -- Example: Add formatters
      -- require("null-ls").builtins.formatting.stylua,
      -- require("null-ls").builtins.formatting.prettier,
    })
  end,
}
