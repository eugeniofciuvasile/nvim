local telescope = require "telescope"
local actions = require "telescope.actions"
local state = require "telescope.state"
local action_state = require "telescope.actions.state"

-- Smooth preview scrolling
local slow_scroll = function(prompt_bufnr, direction)
  local previewer = action_state.get_current_picker(prompt_bufnr).previewer
  local status = state.get_status(prompt_bufnr)
  if type(previewer) ~= "table" or previewer.scroll_fn == nil or status.preview_win == nil then return end
  previewer:scroll_fn(1 * direction)
end

-- Filename first path display
local function filename_first(_, path)
  local tail = vim.fs.basename(path)
  local parent = vim.fs.dirname(path)
  if parent == "." then return tail end
  return string.format("%s\t\t%s", tail, parent)
end

-- Highlight parent folder in results
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
    find_files = { hidden = true },
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
      fuzzy = true,
      override_generic_sorter = true,
      case_mode = "smart_case",
    },
  },
}

require("telescope").load_extension "fzf"
require("telescope").load_extension "undo"
require("telescope").load_extension "live_grep_args"

-- SEARCH & REPLACE MAPPING
local function search_and_replace()
  vim.ui.input({ prompt = "Search for: " }, function(search_term)
    if not search_term or search_term == "" then return end
    require("telescope.builtin").grep_string {
      search = search_term,
      attach_mappings = function(_, map)
        map("i", "<C-q>", function(prompt_bufnr)
          actions.send_to_qflist(prompt_bufnr)
          -- Do NOT call actions.close! It is handled by send_to_qflist.
          vim.schedule(function()
            vim.ui.input({ prompt = "Replace with: " }, function(replace_term)
              if not replace_term or replace_term == "" then return end
              -- Note: 'gc' prompts for confirmation for each match
              vim.cmd(string.format("cfdo %%s/%s/%s/gc | update", search_term, replace_term))
            end)
          end)
        end)
        return true
      end,
    }
  end)
end

vim.keymap.set("n", "<Leader>fR", search_and_replace, { desc = "Telescope search & replace in files" })
