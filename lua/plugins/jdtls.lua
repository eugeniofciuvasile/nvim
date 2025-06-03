return {
  { "mfussenegger/nvim-jdtls", lazy = true }, -- load jdtls on module
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      setup_handlers = {
        -- add custom handler
        jdtls = function(_, opts)
          vim.api.nvim_create_autocmd("Filetype", {
            pattern = "java", -- autocmd to start jdtls
            callback = function()
              if opts.root_dir and opts.root_dir ~= "" then require("jdtls").start_or_attach(opts) end
            end,
          })
        end,
      },
      ---@diagnostic disable-next-line: missing-fields
      config = {
        -- set jdtls server settings
        jdtls = (function()
          -- use this function notation to build some variables
          local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
          local root_dir = require("jdtls.setup").find_root(root_markers)

          -- calculate workspace dir
          local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
          local workspace_dir = vim.fn.stdpath "data" .. "/site/java/workspace-root/" .. project_name
          os.execute("mkdir -p " .. workspace_dir)

          -- get the mason jdtls path
          local jdtls_files = vim.fn.expand "$MASON/share/jdtls"

          -- return the server config table
          return {
            cmd = {
              "java",
              "-Declipse.application=org.eclipse.jdt.ls.core.id1",
              "-Dosgi.bundles.defaultStartLevel=4",
              "-Declipse.product=org.eclipse.jdt.ls.core.product",
              "-Dlog.protocol=true",
              "-Dlog.level=ALL",
              "-javaagent:" .. jdtls_files .. "/lombok.jar",
              "-Xms1g",
              "--add-modules=ALL-SYSTEM",
              "--add-opens",
              "java.base/java.util=ALL-UNNAMED",
              "--add-opens",
              "java.base/java.lang=ALL-UNNAMED",
              "-jar",
              jdtls_files .. "/plugins/org.eclipse.equinox.launcher.jar",
              "-configuration",
              jdtls_files .. "/config",
              "-data",
              workspace_dir,
            },
            root_dir = root_dir,
          }
        end)(),
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = { "jdtls" },
    },
  },
}
