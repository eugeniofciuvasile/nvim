local telescope = require "telescope"
local actions = require "telescope.actions"
local state = require "telescope.state"
local action_state = require "telescope.actions.state"

local slow_scroll = function(prompt_bufnr, direction)
  local previewer = action_state.get_current_picker(prompt_bufnr).previewer
  local status = state.get_status(prompt_bufnr)

  -- Check if we actually have a previewer and a preview window
  if type(previewer) ~= "table" or previewer.scroll_fn == nil or status.preview_win == nil then return end

  previewer:scroll_fn(1 * direction)
end

local function filename_first(_, path)
  local tail = vim.fs.basename(path)
  local parent = vim.fs.dirname(path)
  if parent == "." then return tail end
  return string.format("%s\t\t%s", tail, parent)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "TelescopeResults",
  callback = function(ctx)
    vim.api.nvim_buf_call(ctx.buf, function()
      vim.fn.matchadd("TelescopeParent", "\t\t.*$")
      vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
    end)
  end,
})

telescope.setup {
  pickers = {
    find_files = {
      hidden = true,
    },
    buffers = {
      ignore_current_buffer = false,
      sort_lastused = true,
    },
  },
  defaults = {
    path_display = filename_first,
    file_ignore_patterns = { "node_modules" },
    layout_config = {},
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-e>"] = function(bufnr) slow_scroll(bufnr, 1) end,
        ["<C-y>"] = function(bufnr) slow_scroll(bufnr, -1) end,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      -- override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
  },
}

require("telescope").load_extension "fzf"
require("telescope").load_extension "undo"
require("telescope").load_extension "live_grep_args"
