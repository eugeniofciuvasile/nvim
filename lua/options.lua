local opts = {}

-- vim.opt.mouse = ""
vim.api.nvim_set_keymap("v", "<C-r>", "<CMD>SearchReplaceSingleBufferVisualSelection<CR>", opts)
vim.api.nvim_set_keymap("v", "<C-s>", "<CMD>SearchReplaceWithinVisualSelection<CR>", opts)
vim.api.nvim_set_keymap("v", "<C-b>", "<CMD>SearchReplaceWithinVisualSelectionCWord<CR>", opts)

vim.api.nvim_set_keymap("n", "<Leader>rs", "<CMD>SearchReplaceSingleBufferSelections<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>ro", "<CMD>SearchReplaceSingleBufferOpen<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>rw", "<CMD>SearchReplaceSingleBufferCWord<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>rW", "<CMD>SearchReplaceSingleBufferCWORD<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>re", "<CMD>SearchReplaceSingleBufferCExpr<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>rf", "<CMD>SearchReplaceSingleBufferCFile<CR>", opts)

vim.api.nvim_set_keymap("n", "<Leader>rbs", "<CMD>SearchReplaceMultiBufferSelections<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>rbo", "<CMD>SearchReplaceMultiBufferOpen<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>rbw", "<CMD>SearchReplaceMultiBufferCWord<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>rbW", "<CMD>SearchReplaceMultiBufferCWORD<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>rbe", "<CMD>SearchReplaceMultiBufferCExpr<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>rbf", "<CMD>SearchReplaceMultiBufferCFile<CR>", opts)
vim.o.inccommand = "split"

local keymap = vim.keymap

keymap.set("n", "<Leader>h", "<cmd>Alpha<CR>", { desc = "Open Alpha Dashboard" })
-- LSP
keymap.set("n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "Hover description" })
keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>zz", { desc = "Go to definition" })
keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>zz", { desc = "Go to declaration" })
keymap.set("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>zz", { desc = "Go to implementation" })
keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { desc = "Go to references" })
keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { desc = "Signature help" })
keymap.set("n", "<leader>rr", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename symbols" })
keymap.set("n", "gF", "<cmd>lua vim.lsp.buf.format({async = true})<CR>", { desc = "Format" })
keymap.set("v", "gF", "<cmd>lua vim.lsp.buf.format({async = true})<CR>", { desc = "Format" })
keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "Actions" })
keymap.set("n", "gp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "Go to prev" })
keymap.set("n", "gn", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Go to next" })
keymap.set("n", "<Leader>tr", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", { desc = "Document symbol" })

-- Filetype-specific keymaps (these can be done in the ftplugin directory instead if you prefer)
keymap.set("n", "<Leader>jo", function()
  if vim.bo.filetype == "java" then require("jdtls").organize_imports() end
end, { desc = "Organize imports" })

keymap.set("n", "<Leader>ju", function()
  if vim.bo.filetype == "java" then require("jdtls").update_projects_config() end
end, { desc = "Update projects config" })

keymap.set("n", "<Leader>jp", function()
  if vim.bo.filetype == "java" then
    require("jdtls").javap() -- Use the appropriate method for renaming
  end
end, { desc = "Refactor/Rename package in Java project" })

keymap.set("n", "<Leader>tc", function()
  if vim.bo.filetype == "java" then require("jdtls").test_class() end
end, { desc = "Test class" })

keymap.set("n", "<Leader>tm", function()
  if vim.bo.filetype == "java" then require("jdtls").test_nearest_method() end
end, { desc = "Test nearest method" })

-- Debugging
keymap.set("n", "<Leader>bb", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", { desc = "Toggle breakpoint" })
keymap.set(
  "n",
  "<Leader>bc",
  "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
  { desc = "Set breakpoint" }
)
keymap.set(
  "n",
  "<Leader>bl",
  "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>",
  { desc = "Set breakpoint log" }
)
keymap.set("n", "<Leader>br", "<cmd>lua require'dap'.clear_breakpoints()<cr>", { desc = "Clear breakpoints" })
keymap.set("n", "<Leader>ba", "<cmd>Telescope dap list_breakpoints<cr>", { desc = "List breakpoints" })
keymap.set("n", "<Leader>dc", "<cmd>lua require'dap'.continue()<cr>", { desc = "Debug continue" })
keymap.set("n", "<Leader>dj", "<cmd>lua require'dap'.step_over()<cr>", { desc = "Step over" })
keymap.set("n", "<Leader>dk", "<cmd>lua require'dap'.step_into()<cr>", { desc = "Step into" })
keymap.set("n", "<Leader>do", "<cmd>lua require'dap'.step_out()<cr>", { desc = "Step out" })
keymap.set("n", "<Leader>dd", function()
  require("dap").disconnect()
  require("dapui").close()
end, { desc = "Disconnect debug" })
keymap.set("n", "<Leader>dt", function()
  require("dap").terminate()
  require("dapui").close()
end, { desc = "Close debug" })
keymap.set("n", "<Leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>")
keymap.set("n", "<Leader>dl", "<cmd>lua require'dap'.run_last()<cr>")
keymap.set("n", "<Leader>di", function() require("dap.ui.widgets").hover() end)
keymap.set("n", "<Leader>d?", function()
  local widgets = require "dap.ui.widgets"
  widgets.centered_float(widgets.scopes)
end)
keymap.set("n", "<Leader>df", "<cmd>Telescope dap frames<cr>")
keymap.set("n", "<Leader>dh", "<cmd>Telescope dap commands<cr>")
keymap.set("n", "<Leader>de", function() require("telescope.builtin").diagnostics { default_text = ":E:" } end)
keymap.set("n", "<Leader>ut", vim.cmd.UndotreeToggle, { desc = "UndotreeToggle" })

-- vim.keymap.set("x", "<Leader>re", function() require("refactoring").refactor("Extract Function") end)
-- vim.keymap.set("x", "<Leader>rf", function() require("refactoring").refactor("Extract Function To File") end)
-- -- Extract function supports only visual mode
-- vim.keymap.set("x", "<Leader>rv", function() require("refactoring").refactor("Extract Variable") end)
-- -- Extract variable supports only visual mode
-- vim.keymap.set("n", "<Leader>rI", function() require("refactoring").refactor("Inline Function") end)
-- -- Inline func supports only normal
-- vim.keymap.set({ "n", "x" }, "<leader>ri", function() require("refactoring").refactor("Inline Variable") end)
-- -- Inline var supports both normal and visual mode
--
-- vim.keymap.set("n", "<Leader>rb", function() require("refactoring").refactor("Extract Block") end)
-- vim.keymap.set("n", "<Leader>rbf", function() require("refactoring").refactor("Extract Block To File") end)
-- -- Extract block supports only normal mode
