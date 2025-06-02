-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    sessions = {
      -- Configure auto saving
      autosave = {
        last = true, -- auto save last session
        cwd = true, -- auto save session for each working directory
      },
      -- Patterns to ignore when saving sessions
      ignore = {
        dirs = {}, -- working directories to ignore sessions in
        filetypes = { "gitcommit", "gitrebase" }, -- filetypes to ignore sessions
        buftypes = {}, -- buffer types to ignore sessions
      },
    },
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to auto
        wrap = false, -- sets vim.opt.wrap
        tabstop = 2,
        shiftwidth = 4,
        expandtab = true,
        autoindent = true,
        ignorecase = true,
        smartcase = true,
        splitright = true,
        splitbelow = true,
        swapfile = false,
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        H = { "^", desc = "Jump to init of the line" },
        L = { "g_", desc = "Jump to end of the line" },
        ["*"] = { "*zzv" },
        ["#"] = { "#zzv" },
        ["g*"] = { "g*zz" },
        ["g#"] = { "g#zz" },
        ["<Leader>m"] = { ":Telescope git_status<CR>", desc = "Search modified files" },
        -- navigate buffer tabs with `->` and `<-`
        ["<Tab>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["<S-Tab>"] = {
          function() require("astrocore.buffer").nav(-vim.v.count1) end,
          desc = "Previous buffer",
        },
        ["<ciaoC-d>"] = { "<C-d>zz" },
        ["<C-u>"] = { "<C-u>zz" },
        ["<C-c>"] = { "<ESC><ESC>" },
        n = { "nzzzv" },
        N = { "Nzzzv" },
        J = { "mzJ`z" },
        -- mappings seen under group name "Buffer"
        ["<Leader>tr"] = { function() require("neotest").run.run() end, desc = "Run nearest test" },
        ["<Leader>tF"] = {
          function() require("neotest").run.run(vim.fn.expand "%") end,
          desc = "Run current file",
        },
        ["<Leader>tD"] = {
          function() require("neotest").run.run { strategy = "dap" } end,
          desc = "Run debug test",
        },
        ["<Leader>bD"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Pick to close",
        },
        ["<Leader>b"] = { desc = "Buffers" },
        ["<Leader>nh"] = {
          ":nohl<CR>",
          desc = "Clear search highlights",
        },
        ["<Leader>+"] = {
          "<C-a>",
          desc = "Increment number",
        },
        ["<Leader>-"] = {
          "<C-x>",
          desc = "Decrement number",
        },
        ["<Leader>sv"] = {
          "<C-w>v",
          desc = "Split window vertically",
        },
        ["<Leader>sh"] = {
          "<C-w>s",
          desc = "Split window horizontally",
        },
        ["<Leader>se"] = {
          "<C-x>=",
          desc = "Make splits equal size",
        },
        ["<Leader>sx"] = {
          "<cmd>close<CR>",
          desc = "Close current split",
        },
        ["<C-\\>"] = { "<cmd>ToggleTerm<CR>", desc = "Toggle term" },
      },
      i = {
        jk = { "<ESC>" },
        jj = { "<ESC>" },
      },
      t = {
        ["<ESC>"] = { "<C-\\><C-n>", desc = "Back to normal mode" },
      },
    },
  },
}
