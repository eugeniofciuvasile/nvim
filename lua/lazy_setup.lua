require("lazy").setup({
    {
        "AstroNvim/AstroNvim",
        version = "^4", -- Remove version tracking to elect for nighly AstroNvim
        import = "astronvim.plugins",
        opts = { -- AstroNvim options must be set here with the `import` key
            mapleader = " ", -- This ensures the leader key must be configured before Lazy is set up
            maplocalleader = ",", -- This ensures the localleader key must be configured before Lazy is set up
            icons_enabled = true, -- Set to false to disable icons (if no Nerd Font is available)
            pin_plugins = nil, -- Default will pin plugins when tracking `version` of AstroNvim, set to true/false to override
            update_notifications = true, -- Enable/disable notification about running `:Lazy update` twice to update pinned plugins
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "debugloop/telescope-undo.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            { "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" },
        },
    },

    { import = "community" },
    { import = "euz.plugins" },
    { import = "euz.core" },
    { import = "euz.lsp-config" },
} --[[@as LazySpec]], {
    ui = { backdrop = 100 },
    performance = {
        rtp = {
            -- disable some rtp plugins, add more to your liking
            disabled_plugins = {
                "gzip",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "zipPlugin",
                "indent-blankline",
            },
        },
    },
} --[[@as LazyConfig]])
